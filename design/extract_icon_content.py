#!/usr/bin/env python3
"""
Extract the icon content from Canva's rounded-corner icons and place them on
a full-canvas background. This preserves Canva's beautiful design while fixing
the display issue.

Strategy:
1. Load the Canva icon with rounded corners
2. Find the icon's internal background color (sample from inside the rounded area)
3. Create a new canvas filled with that background color
4. Mask out the external background and paste the icon content
"""

from PIL import Image, ImageDraw, ImageFilter
import os
from collections import Counter
import math

def get_pixel_rgb(img, x, y):
    """Get RGB values from a pixel."""
    pixel = img.getpixel((x, y))
    if isinstance(pixel, tuple):
        return pixel[:3]
    return (pixel, pixel, pixel)

def color_distance(c1, c2):
    """Calculate Euclidean distance between two colors."""
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(c1[:3], c2[:3])))

def find_icon_bounds(img, bg_color, threshold=35):
    """Find the bounding box of the icon (non-background area)."""
    width, height = img.size

    # Find left bound
    left = 0
    for x in range(width):
        for y in range(height // 4, 3 * height // 4):
            if color_distance(get_pixel_rgb(img, x, y), bg_color) > threshold:
                left = x
                break
        if left > 0:
            break

    # Find right bound
    right = width - 1
    for x in range(width - 1, -1, -1):
        for y in range(height // 4, 3 * height // 4):
            if color_distance(get_pixel_rgb(img, x, y), bg_color) > threshold:
                right = x
                break
        if right < width - 1:
            break

    # Find top bound
    top = 0
    for y in range(height):
        for x in range(width // 4, 3 * width // 4):
            if color_distance(get_pixel_rgb(img, x, y), bg_color) > threshold:
                top = y
                break
        if top > 0:
            break

    # Find bottom bound
    bottom = height - 1
    for y in range(height - 1, -1, -1):
        for x in range(width // 4, 3 * width // 4):
            if color_distance(get_pixel_rgb(img, x, y), bg_color) > threshold:
                bottom = y
                break
        if bottom < height - 1:
            break

    return left, top, right, bottom

def sample_inner_background(img, bounds, corner_offset=100):
    """Sample the icon's inner background color (avoiding the rounded corners)."""
    left, top, right, bottom = bounds

    # Sample from multiple points inside the icon, away from corners
    sample_points = [
        (left + corner_offset, top + 30),  # top edge
        (right - corner_offset, top + 30),
        (left + 30, top + corner_offset),  # left edge
        (left + 30, bottom - corner_offset),
        (right - 30, top + corner_offset),  # right edge
        (right - 30, bottom - corner_offset),
        (left + corner_offset, bottom - 30),  # bottom edge
        (right - corner_offset, bottom - 30),
    ]

    colors = []
    for x, y in sample_points:
        if left < x < right and top < y < bottom:
            colors.append(get_pixel_rgb(img, x, y))

    # Return most common color
    return Counter(colors).most_common(1)[0][0] if colors else (128, 128, 128)

def extract_and_fill(input_path, output_path):
    """
    Extract icon content and place on filled background.
    """
    img = Image.open(input_path).convert('RGB')
    width, height = img.size

    print(f"Processing: {input_path}")
    print(f"  Size: {width}x{height}")

    # Get the outer background color
    outer_bg = get_pixel_rgb(img, 5, 5)
    print(f"  Outer background: {outer_bg}")

    # Find icon bounds
    bounds = find_icon_bounds(img, outer_bg)
    left, top, right, bottom = bounds
    print(f"  Icon bounds: ({left}, {top}) to ({right}, {bottom})")

    # Sample the inner background color
    inner_bg = sample_inner_background(img, bounds)
    print(f"  Inner background: {inner_bg}")

    # Create result image filled with inner background
    result = Image.new('RGB', (width, height), inner_bg)

    # Copy pixels from original, replacing outer background with inner background
    for y in range(height):
        for x in range(width):
            pixel = get_pixel_rgb(img, x, y)

            # If pixel is similar to outer background, use inner background
            if color_distance(pixel, outer_bg) < 25:
                result.putpixel((x, y), inner_bg)
            else:
                result.putpixel((x, y), pixel)

    result.save(output_path, 'PNG')
    print(f"  Saved: {output_path}")
    return result

def generate_sizes(img, name, base_dir):
    """Generate all platform sizes."""
    project_dir = os.path.dirname(base_dir)

    # iOS
    ios_folder = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets',
                              f'AppIcon-{name}.appiconset')
    os.makedirs(ios_folder, exist_ok=True)

    for size, filename in [(40, 'Icon-40.png'), (58, 'Icon-58.png'), (60, 'Icon-60.png'),
                           (80, 'Icon-80.png'), (87, 'Icon-87.png'), (120, 'Icon-120.png'),
                           (180, 'Icon-180.png')]:
        resized = img.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(ios_folder, filename), 'PNG')

    # Android
    android_res = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')
    for size, folder in [(48, 'mipmap-mdpi'), (72, 'mipmap-hdpi'), (96, 'mipmap-xhdpi'),
                         (144, 'mipmap-xxhdpi'), (192, 'mipmap-xxxhdpi')]:
        out_dir = os.path.join(android_res, folder)
        os.makedirs(out_dir, exist_ok=True)
        resized = img.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(out_dir, f'ic_launcher_{name}.png'), 'PNG')

    # Flutter
    flutter_dir = os.path.join(project_dir, 'assets', 'icons')
    os.makedirs(flutter_dir, exist_ok=True)
    preview = img.resize((120, 120), Image.Resampling.LANCZOS)
    preview.save(os.path.join(flutter_dir, f'icon_{name}.png'), 'PNG')

    print(f"  Generated all sizes for {name}")

if __name__ == '__main__':
    base_dir = os.path.dirname(os.path.abspath(__file__))

    # Test with the exported navy_stars
    input_path = os.path.join(base_dir, 'exported_navy_stars.png')
    output_path = os.path.join(base_dir, 'navy_stars_final.png')

    if os.path.exists(input_path):
        result = extract_and_fill(input_path, output_path)
        generate_sizes(result, 'navy_stars', base_dir)
