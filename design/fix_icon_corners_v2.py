#!/usr/bin/env python3
"""
Fix icon corners by replacing ALL gray background pixels with edge colors.
More aggressive approach - detects and replaces the Canva grid background.
"""

from PIL import Image
import os
from collections import Counter

ICON_NAMES = [
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

# iOS required sizes
IOS_SIZES = [
    (40, 'Icon-40.png'),
    (58, 'Icon-58.png'),
    (60, 'Icon-60.png'),
    (80, 'Icon-80.png'),
    (87, 'Icon-87.png'),
    (120, 'Icon-120.png'),
    (180, 'Icon-180.png'),
]

# Android mipmap sizes
ANDROID_SIZES = [
    (48, 'mipmap-mdpi'),
    (72, 'mipmap-hdpi'),
    (96, 'mipmap-xhdpi'),
    (144, 'mipmap-xxhdpi'),
    (192, 'mipmap-xxxhdpi'),
]


def is_canva_gray(pixel):
    """Check if a pixel is the Canva grid background gray."""
    r, g, b = pixel[:3]
    # Canva background is around (226, 226, 231) - light grayish
    # Also check for slightly different grays
    avg = (r + g + b) / 3
    spread = max(abs(r - avg), abs(g - avg), abs(b - avg))

    # Gray: all channels similar (spread < 15) and in the light gray range (200-240)
    return spread < 15 and 200 <= avg <= 245


def get_nearest_non_gray_color(img, x, y, max_search=50):
    """Find the nearest non-gray pixel color by searching inward."""
    width, height = img.size

    # Search in a spiral pattern toward center
    cx, cy = width // 2, height // 2

    # Direction toward center
    dx = 1 if x < cx else -1
    dy = 1 if y < cy else -1

    # Search along the line toward center
    for i in range(1, max_search):
        nx = x + dx * i
        ny = y + dy * i

        if 0 <= nx < width and 0 <= ny < height:
            pixel = img.getpixel((nx, ny))
            if not is_canva_gray(pixel):
                return pixel

    # Fallback: search horizontally and vertically
    for i in range(1, max_search):
        # Check horizontal
        if x + i < width:
            pixel = img.getpixel((x + i, y))
            if not is_canva_gray(pixel):
                return pixel
        if x - i >= 0:
            pixel = img.getpixel((x - i, y))
            if not is_canva_gray(pixel):
                return pixel

        # Check vertical
        if y + i < height:
            pixel = img.getpixel((x, y + i))
            if not is_canva_gray(pixel):
                return pixel
        if y - i >= 0:
            pixel = img.getpixel((x, y - i))
            if not is_canva_gray(pixel):
                return pixel

    # Last fallback - return a neutral color
    return (128, 128, 128)


def fix_gray_pixels(img):
    """Replace all gray background pixels with the nearest non-gray color."""
    width, height = img.size
    img = img.convert('RGB')
    result = img.copy()

    # First pass: identify all gray pixels
    gray_pixels = []
    for y in range(height):
        for x in range(width):
            pixel = img.getpixel((x, y))
            if is_canva_gray(pixel):
                gray_pixels.append((x, y))

    print(f"    Found {len(gray_pixels)} gray pixels to fix")

    # Second pass: replace gray pixels
    for x, y in gray_pixels:
        new_color = get_nearest_non_gray_color(img, x, y)
        result.putpixel((x, y), new_color)

    return result


def process_all_icons():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(base_dir)
    extracted_dir = os.path.join(base_dir, 'extracted_icons')

    ios_assets = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets')
    android_res = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')
    flutter_icons = os.path.join(project_dir, 'assets', 'icons')

    for name in ICON_NAMES:
        raw_path = os.path.join(extracted_dir, f'{name}_raw.png')
        if not os.path.exists(raw_path):
            print(f"Skipping {name} - raw file not found")
            continue

        print(f"Processing {name}...")

        # Load and fix gray pixels
        img = Image.open(raw_path)
        fixed = fix_gray_pixels(img)

        # Save fixed version
        fixed_path = os.path.join(extracted_dir, f'{name}_fixed_v2.png')
        fixed.save(fixed_path, 'PNG')

        # Generate iOS icons
        ios_folder = os.path.join(ios_assets, f'AppIcon-{name}.appiconset')
        for size, filename in IOS_SIZES:
            resized = fixed.resize((size, size), Image.Resampling.LANCZOS)
            resized.save(os.path.join(ios_folder, filename), 'PNG')

        # Generate Android icons
        for size, folder in ANDROID_SIZES:
            output_dir = os.path.join(android_res, folder)
            resized = fixed.resize((size, size), Image.Resampling.LANCZOS)
            resized.save(os.path.join(output_dir, f'ic_launcher_{name}.png'), 'PNG')

        # Generate Flutter preview (keep original with rounded corners for nice preview)
        preview = img.resize((120, 120), Image.Resampling.LANCZOS)
        preview.save(os.path.join(flutter_icons, f'icon_{name}.png'), 'PNG')

        print(f"  ✓ Generated all sizes for {name}")

    print("\n✓ All icons processed!")


if __name__ == '__main__':
    process_all_icons()
