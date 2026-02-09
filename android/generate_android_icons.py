#!/usr/bin/env python3
"""
Generate Android mipmap icons from iOS icon sources.
Converts 180x180 iOS icons to Android's required mipmap sizes.
"""

from PIL import Image
import os

# Android mipmap sizes (for adaptive icons, we need slightly larger for foreground)
MIPMAP_SIZES = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

# New icon names matching iOS
ICONS = [
    'navy_stars',
    'cream_olive',
    'gold_luxe',
    'white_wave',
    'teal_pink',
    'ocean_clouds',
    'night_gold',
    'sunset_coral',
    'royal_purple',
]

def generate_icons():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    ios_assets_dir = os.path.join(base_dir, '..', 'ios', 'Runner', 'Assets.xcassets')
    android_res_dir = os.path.join(base_dir, 'app', 'src', 'main', 'res')

    for icon_name in ICONS:
        # Source: iOS 180x180 icon
        ios_icon_path = os.path.join(ios_assets_dir, f'AppIcon-{icon_name}.appiconset', 'icon_180.png')

        if not os.path.exists(ios_icon_path):
            print(f"Warning: Source icon not found: {ios_icon_path}")
            continue

        print(f"Processing {icon_name}...")
        source_img = Image.open(ios_icon_path)

        # Generate for each mipmap density
        for mipmap_folder, size in MIPMAP_SIZES.items():
            output_dir = os.path.join(android_res_dir, mipmap_folder)
            os.makedirs(output_dir, exist_ok=True)

            # Resize with high quality
            resized = source_img.resize((size, size), Image.Resampling.LANCZOS)

            # Save as ic_launcher_{name}.png
            output_path = os.path.join(output_dir, f'ic_launcher_{icon_name}.png')
            resized.save(output_path, 'PNG')
            print(f"  Created: {mipmap_folder}/ic_launcher_{icon_name}.png ({size}x{size})")

    print("\nDone! Android icons generated successfully.")

if __name__ == '__main__':
    generate_icons()
