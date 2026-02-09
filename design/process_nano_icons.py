#!/usr/bin/env python3
"""
Process Nano Banana generated icons into all required iOS/Android/Flutter sizes.
These icons already have iOS-style rounded corners baked in, which works perfectly
since iOS will clip them anyway.
"""

from PIL import Image
import os
import json

# Icon mapping: name -> source file
ICONS = {
    'navy_stars': 'navy_stars.jpg',
    'cream_olive': 'cream_olive.jpg',
    'gold_luxe': 'gold_luxe_v2.jpg',  # Fixed version with proper cross
    'white_wave': 'white_wave.jpg',
    'teal_pink': 'teal_pink.jpg',
    'ocean_clouds': 'ocean_clouds.jpg',
    'night_gold': 'night_gold.jpg',
    'sunset_coral': 'sunset_coral.jpg',
    'royal_purple': 'royal_purple_v2.jpg',
}

# iOS icon sizes for iPhone
IOS_SIZES = [
    (20, 2),   # 40x40 - Notification 2x
    (20, 3),   # 60x60 - Notification 3x
    (29, 2),   # 58x58 - Settings 2x
    (29, 3),   # 87x87 - Settings 3x
    (40, 2),   # 80x80 - Spotlight 2x
    (40, 3),   # 120x120 - Spotlight 3x
    (60, 2),   # 120x120 - App 2x
    (60, 3),   # 180x180 - App 3x
]

# Android mipmap sizes
ANDROID_SIZES = [
    (48, 'mipmap-mdpi'),
    (72, 'mipmap-hdpi'),
    (96, 'mipmap-xhdpi'),
    (144, 'mipmap-xxhdpi'),
    (192, 'mipmap-xxxhdpi'),
]

def create_ios_contents_json(icon_name):
    """Create Contents.json for iOS alternate icon."""
    images = []
    for size, scale in IOS_SIZES:
        pixel_size = size * scale
        filename = f"icon_{pixel_size}.png"
        images.append({
            "size": f"{size}x{size}",
            "idiom": "iphone",
            "filename": filename,
            "scale": f"{scale}x"
        })

    return {
        "images": images,
        "info": {
            "version": 1,
            "author": "xcode"
        }
    }

def process_icon(name, source_file, base_dir, project_dir):
    """Process a single icon into all required sizes."""
    source_path = os.path.join(base_dir, 'nano_icons', source_file)

    if not os.path.exists(source_path):
        print(f"  Warning: {source_path} not found, skipping")
        return False

    img = Image.open(source_path).convert('RGB')
    print(f"  Source: {img.size[0]}x{img.size[1]}")

    # iOS - create complete appiconset
    ios_folder = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets',
                              f'AppIcon-{name}.appiconset')
    os.makedirs(ios_folder, exist_ok=True)

    for size, scale in IOS_SIZES:
        pixel_size = size * scale
        resized = img.resize((pixel_size, pixel_size), Image.Resampling.LANCZOS)
        output_path = os.path.join(ios_folder, f'icon_{pixel_size}.png')
        resized.save(output_path, 'PNG')

    # Write Contents.json
    contents = create_ios_contents_json(name)
    contents_path = os.path.join(ios_folder, 'Contents.json')
    with open(contents_path, 'w') as f:
        json.dump(contents, f, indent=2)

    print(f"  iOS: Created {len(IOS_SIZES)} sizes + Contents.json")

    # Android
    android_res = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')
    for pixel_size, folder in ANDROID_SIZES:
        out_dir = os.path.join(android_res, folder)
        os.makedirs(out_dir, exist_ok=True)
        resized = img.resize((pixel_size, pixel_size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(out_dir, f'ic_launcher_{name}.png'), 'PNG')

    print(f"  Android: Created {len(ANDROID_SIZES)} mipmap sizes")

    # Flutter preview icons
    flutter_dir = os.path.join(project_dir, 'assets', 'icons')
    os.makedirs(flutter_dir, exist_ok=True)
    preview = img.resize((120, 120), Image.Resampling.LANCZOS)
    preview.save(os.path.join(flutter_dir, f'icon_{name}.png'), 'PNG')
    print(f"  Flutter: Created preview icon")

    # Save 1024x1024 master copy
    master_dir = os.path.join(base_dir, 'master_icons')
    os.makedirs(master_dir, exist_ok=True)
    master = img.resize((1024, 1024), Image.Resampling.LANCZOS)
    master.save(os.path.join(master_dir, f'{name}_1024.png'), 'PNG')

    return True

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(base_dir)

    print("Processing Nano Banana icons...")
    print(f"Base dir: {base_dir}")
    print(f"Project dir: {project_dir}")
    print()

    success_count = 0
    for name, source_file in ICONS.items():
        print(f"Processing {name}...")
        if process_icon(name, source_file, base_dir, project_dir):
            success_count += 1
        print()

    print(f"✓ Processed {success_count}/{len(ICONS)} icons")

    # Summary
    print("\nGenerated files:")
    print(f"  iOS: ios/Runner/Assets.xcassets/AppIcon-*.appiconset/")
    print(f"  Android: android/app/src/main/res/mipmap-*/ic_launcher_*.png")
    print(f"  Flutter: assets/icons/icon_*.png")
    print(f"  Masters: design/master_icons/*_1024.png")

if __name__ == '__main__':
    main()
