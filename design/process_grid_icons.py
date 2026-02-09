#!/usr/bin/env python3
"""
Process the 3x3 grid of Canva icons.
Extract each icon, crop inside the rounded corners, and scale to fill canvas.
"""

from PIL import Image
import os
import math

# Icon names in order (top-left to bottom-right, row by row)
ICON_NAMES = [
    'navy_stars',      # row 1
    'cream_olive',
    'gold_luxe',
    'white_wave',      # row 2
    'teal_pink',
    'ocean_clouds',
    'night_gold',      # row 3
    'sunset_coral',
    'royal_purple',
]

def get_pixel_rgb(img, x, y):
    """Get RGB tuple from pixel."""
    p = img.getpixel((x, y))
    return p[:3] if isinstance(p, tuple) else (p, p, p)

def color_distance(c1, c2):
    """Euclidean color distance."""
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(c1[:3], c2[:3])))

def find_icon_inner_rect(img, margin_ratio=0.18):
    """
    Find the inner rectangular region of a single icon (inside rounded corners).
    """
    width, height = img.size

    # Sample corner to get background
    bg_color = get_pixel_rgb(img, 2, 2)

    # Find icon bounds
    left, top, right, bottom = width, height, 0, 0

    for y in range(height):
        for x in range(width):
            if color_distance(get_pixel_rgb(img, x, y), bg_color) > 25:
                left = min(left, x)
                top = min(top, y)
                right = max(right, x)
                bottom = max(bottom, y)

    if left >= right or top >= bottom:
        # No icon found, return center region
        margin = int(width * 0.1)
        return margin, margin, width - margin, height - margin

    # Calculate margins to get inside rounded corners
    icon_w = right - left
    icon_h = bottom - top
    margin_x = int(icon_w * margin_ratio)
    margin_y = int(icon_h * margin_ratio)

    return left + margin_x, top + margin_y, right - margin_x, bottom - margin_y

def crop_and_scale_single(img, output_size=1024):
    """Crop inner region and scale to fill canvas."""
    # Find inner rectangle
    inner_rect = find_icon_inner_rect(img)
    inner_left, inner_top, inner_right, inner_bottom = inner_rect

    # Crop
    cropped = img.crop((inner_left, inner_top, inner_right + 1, inner_bottom + 1))
    crop_w, crop_h = cropped.size

    if crop_w <= 0 or crop_h <= 0:
        return img.resize((output_size, output_size), Image.Resampling.LANCZOS)

    # Scale to fill
    scale = max(output_size / crop_w, output_size / crop_h)
    new_w = int(crop_w * scale)
    new_h = int(crop_h * scale)

    scaled = cropped.resize((new_w, new_h), Image.Resampling.LANCZOS)

    # Center crop to exact size
    start_x = (new_w - output_size) // 2
    start_y = (new_h - output_size) // 2
    result = scaled.crop((start_x, start_y, start_x + output_size, start_y + output_size))

    return result

def extract_icons_from_grid(grid_path, output_dir, output_size=1024):
    """Extract individual icons from a 3x3 grid."""
    grid = Image.open(grid_path).convert('RGB')
    grid_w, grid_h = grid.size

    # Calculate cell size (3x3 grid)
    cell_w = grid_w // 3
    cell_h = grid_h // 3

    print(f"Grid size: {grid_w}x{grid_h}")
    print(f"Cell size: {cell_w}x{cell_h}")

    os.makedirs(output_dir, exist_ok=True)

    results = {}

    for idx, name in enumerate(ICON_NAMES):
        row = idx // 3
        col = idx % 3

        # Extract cell
        x1 = col * cell_w
        y1 = row * cell_h
        x2 = x1 + cell_w
        y2 = y1 + cell_h

        cell = grid.crop((x1, y1, x2, y2))

        # Process the cell
        processed = crop_and_scale_single(cell, output_size)

        # Save
        output_path = os.path.join(output_dir, f'{name}_1024.png')
        processed.save(output_path, 'PNG')

        results[name] = processed
        print(f"  Processed {name}")

    return results

def generate_all_sizes(icons_dict, base_dir):
    """Generate all platform sizes for each icon."""
    project_dir = os.path.dirname(base_dir)

    ios_assets = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets')
    android_res = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')
    flutter_icons = os.path.join(project_dir, 'assets', 'icons')

    ios_sizes = [(40, 'Icon-40.png'), (58, 'Icon-58.png'), (60, 'Icon-60.png'),
                 (80, 'Icon-80.png'), (87, 'Icon-87.png'), (120, 'Icon-120.png'),
                 (180, 'Icon-180.png')]

    android_sizes = [(48, 'mipmap-mdpi'), (72, 'mipmap-hdpi'), (96, 'mipmap-xhdpi'),
                     (144, 'mipmap-xxhdpi'), (192, 'mipmap-xxxhdpi')]

    for name, img in icons_dict.items():
        # iOS
        ios_folder = os.path.join(ios_assets, f'AppIcon-{name}.appiconset')
        os.makedirs(ios_folder, exist_ok=True)

        for size, filename in ios_sizes:
            resized = img.resize((size, size), Image.Resampling.LANCZOS)
            resized.save(os.path.join(ios_folder, filename), 'PNG')

        # Android
        for size, folder in android_sizes:
            out_dir = os.path.join(android_res, folder)
            os.makedirs(out_dir, exist_ok=True)
            resized = img.resize((size, size), Image.Resampling.LANCZOS)
            resized.save(os.path.join(out_dir, f'ic_launcher_{name}.png'), 'PNG')

        # Flutter preview
        os.makedirs(flutter_icons, exist_ok=True)
        preview = img.resize((120, 120), Image.Resampling.LANCZOS)
        preview.save(os.path.join(flutter_icons, f'icon_{name}.png'), 'PNG')

        print(f"  Generated all sizes for {name}")

if __name__ == '__main__':
    base_dir = os.path.dirname(os.path.abspath(__file__))

    # Use high resolution grid
    grid_path = os.path.join(base_dir, 'grid_highres.png')
    output_dir = os.path.join(base_dir, 'processed_icons')

    if os.path.exists(grid_path):
        print("Extracting icons from grid...")
        icons = extract_icons_from_grid(grid_path, output_dir)

        print("\nGenerating platform sizes...")
        generate_all_sizes(icons, base_dir)

        print("\n✓ All icons processed!")
    else:
        print(f"Grid file not found: {grid_path}")
