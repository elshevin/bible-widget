#!/usr/bin/env python3
"""
Crop the inner rectangular region of Canva icons (inside the rounded corners)
and scale it to fill the entire canvas.
"""

from PIL import Image
import os
import math

def get_pixel_rgb(img, x, y):
    """Get RGB tuple from pixel."""
    p = img.getpixel((x, y))
    return p[:3] if isinstance(p, tuple) else (p, p, p)

def color_distance(c1, c2):
    """Euclidean color distance."""
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(c1[:3], c2[:3])))

def find_icon_inner_rect(img, margin_ratio=0.12):
    """
    Find the inner rectangular region of the icon, inside the rounded corners.
    margin_ratio: how much to trim from each side (as fraction of icon size)
    """
    width, height = img.size

    # Get outer background
    outer_bg = get_pixel_rgb(img, 5, 5)

    # Find the icon's bounding box
    left, top, right, bottom = width, height, 0, 0

    for y in range(height):
        for x in range(width):
            if color_distance(get_pixel_rgb(img, x, y), outer_bg) > 30:
                left = min(left, x)
                top = min(top, y)
                right = max(right, x)
                bottom = max(bottom, y)

    # Calculate the icon dimensions
    icon_width = right - left
    icon_height = bottom - top

    # Apply margin to get inside the rounded corners
    margin_x = int(icon_width * margin_ratio)
    margin_y = int(icon_height * margin_ratio)

    inner_left = left + margin_x
    inner_top = top + margin_y
    inner_right = right - margin_x
    inner_bottom = bottom - margin_y

    return inner_left, inner_top, inner_right, inner_bottom

def crop_and_scale(input_path, output_path):
    """Crop inner region and scale to fill canvas."""
    img = Image.open(input_path).convert('RGB')
    width, height = img.size

    print(f"Processing: {input_path}")
    print(f"  Original size: {width}x{height}")

    # Find inner rectangle
    inner_rect = find_icon_inner_rect(img, margin_ratio=0.15)
    inner_left, inner_top, inner_right, inner_bottom = inner_rect
    print(f"  Inner rect: ({inner_left}, {inner_top}) to ({inner_right}, {inner_bottom})")

    # Crop the inner region
    cropped = img.crop((inner_left, inner_top, inner_right + 1, inner_bottom + 1))
    crop_w, crop_h = cropped.size
    print(f"  Cropped size: {crop_w}x{crop_h}")

    # Scale to fill the original canvas size
    # Use the smaller dimension to maintain aspect ratio, then crop to square
    scale = max(width / crop_w, height / crop_h)
    new_w = int(crop_w * scale)
    new_h = int(crop_h * scale)

    scaled = cropped.resize((new_w, new_h), Image.Resampling.LANCZOS)

    # Center crop to get exact square
    start_x = (new_w - width) // 2
    start_y = (new_h - height) // 2
    result = scaled.crop((start_x, start_y, start_x + width, start_y + height))

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

    input_path = os.path.join(base_dir, 'exported_navy_stars.png')
    output_path = os.path.join(base_dir, 'navy_stars_cropped.png')

    if os.path.exists(input_path):
        result = crop_and_scale(input_path, output_path)
        generate_sizes(result, 'navy_stars', base_dir)
