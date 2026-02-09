#!/usr/bin/env python3
"""Reprocess a single icon."""

from PIL import Image
import os
import json
import sys

IOS_SIZES = [
    (20, 2), (20, 3), (29, 2), (29, 3),
    (40, 2), (40, 3), (60, 2), (60, 3),
]

ANDROID_SIZES = [
    (48, 'mipmap-mdpi'), (72, 'mipmap-hdpi'), (96, 'mipmap-xhdpi'),
    (144, 'mipmap-xxhdpi'), (192, 'mipmap-xxxhdpi'),
]

def create_ios_contents_json():
    images = []
    for size, scale in IOS_SIZES:
        pixel_size = size * scale
        images.append({
            "size": f"{size}x{size}",
            "idiom": "iphone",
            "filename": f"icon_{pixel_size}.png",
            "scale": f"{scale}x"
        })
    return {"images": images, "info": {"version": 1, "author": "xcode"}}

def process_icon(name, source_path, base_dir, project_dir):
    img = Image.open(source_path).convert('RGB')
    print(f"Source: {img.size[0]}x{img.size[1]}")

    # iOS
    ios_folder = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets',
                              f'AppIcon-{name}.appiconset')
    os.makedirs(ios_folder, exist_ok=True)

    for size, scale in IOS_SIZES:
        pixel_size = size * scale
        resized = img.resize((pixel_size, pixel_size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(ios_folder, f'icon_{pixel_size}.png'), 'PNG')

    with open(os.path.join(ios_folder, 'Contents.json'), 'w') as f:
        json.dump(create_ios_contents_json(), f, indent=2)

    # Android
    android_res = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')
    for pixel_size, folder in ANDROID_SIZES:
        out_dir = os.path.join(android_res, folder)
        os.makedirs(out_dir, exist_ok=True)
        resized = img.resize((pixel_size, pixel_size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(out_dir, f'ic_launcher_{name}.png'), 'PNG')

    # Flutter preview
    flutter_dir = os.path.join(project_dir, 'assets', 'icons')
    os.makedirs(flutter_dir, exist_ok=True)
    preview = img.resize((120, 120), Image.Resampling.LANCZOS)
    preview.save(os.path.join(flutter_dir, f'icon_{name}.png'), 'PNG')

    # Master
    master_dir = os.path.join(base_dir, 'master_icons')
    os.makedirs(master_dir, exist_ok=True)
    master = img.resize((1024, 1024), Image.Resampling.LANCZOS)
    master.save(os.path.join(master_dir, f'{name}_1024.png'), 'PNG')

    print(f"✓ Processed {name}")

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: python reprocess_single_icon.py <name> <source_file>")
        sys.exit(1)

    name = sys.argv[1]
    source_file = sys.argv[2]

    base_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(base_dir)
    source_path = os.path.join(base_dir, 'nano_icons', source_file)

    process_icon(name, source_path, base_dir, project_dir)
