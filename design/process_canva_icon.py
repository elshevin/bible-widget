#!/usr/bin/env python3
"""
Process Canva-generated icons to fill the entire canvas.
Strategy:
1. Detect the icon's main background color (inside the rounded corners)
2. Fill the entire canvas with that color
3. Composite the icon content (cross, stars, etc.) on top
"""

from PIL import Image, ImageFilter
import os
from collections import Counter
import numpy as np

def get_dominant_color(img, region):
    """Get the most common color in a region."""
    left, top, right, bottom = region
    colors = []
    for y in range(top, bottom, 2):
        for x in range(left, right, 2):
            colors.append(img.getpixel((x, y)))

    # Find most common color
    return Counter(colors).most_common(1)[0][0]

def is_similar_color(c1, c2, threshold=30):
    """Check if two colors are similar."""
    return all(abs(c1[i] - c2[i]) < threshold for i in range(3))

def find_icon_region(img):
    """Find the bounding box of the icon (excluding outer background)."""
    width, height = img.size

    # Outer background color
    outer_bg = img.getpixel((5, 5))

    # Find icon boundaries
    left = 0
    for x in range(width):
        col_colors = [img.getpixel((x, y)) for y in range(0, height, 10)]
        if not all(is_similar_color(c, outer_bg, 25) for c in col_colors):
            left = x
            break

    right = width - 1
    for x in range(width - 1, -1, -1):
        col_colors = [img.getpixel((x, y)) for y in range(0, height, 10)]
        if not all(is_similar_color(c, outer_bg, 25) for c in col_colors):
            right = x
            break

    top = 0
    for y in range(height):
        row_colors = [img.getpixel((x, y)) for x in range(0, width, 10)]
        if not all(is_similar_color(c, outer_bg, 25) for c in row_colors):
            top = y
            break

    bottom = height - 1
    for y in range(height - 1, -1, -1):
        row_colors = [img.getpixel((x, y)) for x in range(0, width, 10)]
        if not all(is_similar_color(c, outer_bg, 25) for c in row_colors):
            bottom = y
            break

    return left, top, right, bottom

def process_icon(input_path, output_path):
    """
    Process a Canva icon to fill the entire canvas with the icon content.
    """
    img = Image.open(input_path).convert('RGB')
    width, height = img.size

    print(f"Processing {input_path}")
    print(f"  Size: {width}x{height}")

    # Find the icon region
    icon_region = find_icon_region(img)
    icon_left, icon_top, icon_right, icon_bottom = icon_region
    print(f"  Icon region: ({icon_left}, {icon_top}) to ({icon_right}, {icon_bottom})")

    # Get the icon's internal background color
    # Sample from the center-top of the icon (inside the rounded corner area)
    icon_center_x = (icon_left + icon_right) // 2
    icon_center_y = (icon_top + icon_bottom) // 2

    # Sample from multiple points inside the icon
    sample_region = (
        icon_left + 100, icon_top + 50,
        icon_left + 200, icon_top + 100
    )
    icon_bg = get_dominant_color(img, sample_region)
    print(f"  Icon background: {icon_bg}")

    # Get the outer background
    outer_bg = img.getpixel((5, 5))
    print(f"  Outer background: {outer_bg}")

    # Create a new image filled with the icon's background color
    result = Image.new('RGB', (width, height), icon_bg)

    # Now we need to paste the icon content, but not the rounded corners
    # We'll go pixel by pixel and only copy non-background pixels
    icon_cropped = img.crop((icon_left, icon_top, icon_right + 1, icon_bottom + 1))
    icon_w, icon_h = icon_cropped.size

    # Calculate offset to center the icon content
    offset_x = (width - icon_w) // 2
    offset_y = (height - icon_h) // 2

    # For each pixel in the cropped icon, check if it's background or content
    for y in range(icon_h):
        for x in range(icon_w):
            pixel = icon_cropped.getpixel((x, y))

            # Skip if it's the outer background color (from the rounded corners)
            if is_similar_color(pixel, outer_bg, 20):
                continue

            # Copy this pixel to the result
            result.putpixel((offset_x + x, offset_y + y), pixel)

    result.save(output_path, 'PNG')
    print(f"  Saved to {output_path}")
    return result

def generate_all_sizes(filled_img, name, base_dir):
    """Generate all required sizes for iOS, Android, and Flutter."""
    project_dir = os.path.dirname(base_dir)

    # iOS sizes
    ios_assets = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets')
    ios_folder = os.path.join(ios_assets, f'AppIcon-{name}.appiconset')

    os.makedirs(ios_folder, exist_ok=True)

    ios_sizes = [
        (40, 'Icon-40.png'),
        (58, 'Icon-58.png'),
        (60, 'Icon-60.png'),
        (80, 'Icon-80.png'),
        (87, 'Icon-87.png'),
        (120, 'Icon-120.png'),
        (180, 'Icon-180.png'),
    ]

    for size, filename in ios_sizes:
        resized = filled_img.resize((size, size), Image.Resampling.LANCZOS)
        output_path = os.path.join(ios_folder, filename)
        resized.save(output_path, 'PNG')
    print(f"  Generated iOS icons")

    # Android sizes
    android_res = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')
    android_sizes = [
        (48, 'mipmap-mdpi'),
        (72, 'mipmap-hdpi'),
        (96, 'mipmap-xhdpi'),
        (144, 'mipmap-xxhdpi'),
        (192, 'mipmap-xxxhdpi'),
    ]

    for size, folder in android_sizes:
        output_dir = os.path.join(android_res, folder)
        os.makedirs(output_dir, exist_ok=True)
        resized = filled_img.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(output_dir, f'ic_launcher_{name}.png'), 'PNG')
    print(f"  Generated Android icons")

    # Flutter preview
    flutter_icons = os.path.join(project_dir, 'assets', 'icons')
    os.makedirs(flutter_icons, exist_ok=True)
    preview = filled_img.resize((120, 120), Image.Resampling.LANCZOS)
    preview.save(os.path.join(flutter_icons, f'icon_{name}.png'), 'PNG')
    print(f"  Generated Flutter preview")

if __name__ == '__main__':
    base_dir = os.path.dirname(os.path.abspath(__file__))

    # Process exported icons
    input_path = os.path.join(base_dir, 'exported_navy_stars.png')
    output_path = os.path.join(base_dir, 'navy_stars_processed.png')

    if os.path.exists(input_path):
        filled = process_icon(input_path, output_path)
        generate_all_sizes(filled, 'navy_stars', base_dir)
