#!/usr/bin/env python3
"""
Fix Canva icons by replacing the outer gray background with the icon's internal background color.
This preserves Canva's beautiful design while ensuring no visible seams when displayed.
"""

from PIL import Image
import os
import math
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

def get_rgb(img, x, y):
    """Get RGB tuple from pixel."""
    p = img.getpixel((x, y))
    return p[:3] if isinstance(p, tuple) else (p, p, p)

def color_distance(c1, c2):
    """Euclidean color distance."""
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(c1[:3], c2[:3])))

def find_icon_bounds(img, outer_bg, threshold=30):
    """Find the bounding box of the icon (non-background area)."""
    width, height = img.size

    left, top, right, bottom = width, height, 0, 0

    for y in range(height):
        for x in range(width):
            if color_distance(get_rgb(img, x, y), outer_bg) > threshold:
                left = min(left, x)
                top = min(top, y)
                right = max(right, x)
                bottom = max(bottom, y)

    return left, top, right, bottom

def sample_inner_background(img, bounds, margin=80):
    """Sample the icon's internal background color."""
    left, top, right, bottom = bounds

    # Sample from edges inside the icon (avoiding the center where the cross is)
    sample_points = [
        # Top edge inside
        (left + margin, top + 20),
        ((left + right) // 2, top + 20),
        (right - margin, top + 20),
        # Left edge inside
        (left + 20, top + margin),
        (left + 20, (top + bottom) // 2),
        # Right edge inside
        (right - 20, top + margin),
        (right - 20, (top + bottom) // 2),
        # Bottom edge inside
        (left + margin, bottom - 20),
        (right - margin, bottom - 20),
    ]

    colors = []
    for x, y in sample_points:
        if left < x < right and top < y < bottom:
            colors.append(get_rgb(img, int(x), int(y)))

    if colors:
        return Counter(colors).most_common(1)[0][0]
    return (128, 128, 128)

def fix_icon_background(img):
    """Replace outer background with icon's internal background color."""
    width, height = img.size
    img = img.convert('RGB')

    # Get outer background color (from corner)
    outer_bg = get_rgb(img, 5, 5)
    print(f"    Outer background: {outer_bg}")

    # Find icon bounds
    bounds = find_icon_bounds(img, outer_bg)
    left, top, right, bottom = bounds
    print(f"    Icon bounds: ({left}, {top}) to ({right}, {bottom})")

    # Sample inner background
    inner_bg = sample_inner_background(img, bounds)
    print(f"    Inner background: {inner_bg}")

    # Create result - replace outer background with inner background
    result = img.copy()

    for y in range(height):
        for x in range(width):
            pixel = get_rgb(img, x, y)
            # If pixel is similar to outer background, replace with inner background
            if color_distance(pixel, outer_bg) < 25:
                result.putpixel((x, y), inner_bg)

    return result

def process_grid(grid_path, output_dir):
    """Process 3x3 grid of icons."""
    grid = Image.open(grid_path).convert('RGB')
    grid_w, grid_h = grid.size

    cell_w = grid_w // 3
    cell_h = grid_h // 3

    print(f"Grid: {grid_w}x{grid_h}, Cell: {cell_w}x{cell_h}")

    os.makedirs(output_dir, exist_ok=True)
    results = {}

    for idx, name in enumerate(ICON_NAMES):
        row = idx // 3
        col = idx % 3

        x1 = col * cell_w
        y1 = row * cell_h

        cell = grid.crop((x1, y1, x1 + cell_w, y1 + cell_h))

        print(f"  Processing {name}...")
        fixed = fix_icon_background(cell)

        # Save at 1024x1024
        fixed_1024 = fixed.resize((1024, 1024), Image.Resampling.LANCZOS)
        fixed_1024.save(os.path.join(output_dir, f'{name}_1024.png'), 'PNG')

        results[name] = fixed_1024

    return results

def generate_all_sizes(icons, base_dir):
    """Generate all platform sizes."""
    project_dir = os.path.dirname(base_dir)

    ios_assets = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets')
    android_res = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')
    flutter_icons = os.path.join(project_dir, 'assets', 'icons')

    ios_sizes = [(40, 'Icon-40.png'), (58, 'Icon-58.png'), (60, 'Icon-60.png'),
                 (80, 'Icon-80.png'), (87, 'Icon-87.png'), (120, 'Icon-120.png'),
                 (180, 'Icon-180.png')]

    android_sizes = [(48, 'mipmap-mdpi'), (72, 'mipmap-hdpi'), (96, 'mipmap-xhdpi'),
                     (144, 'mipmap-xxhdpi'), (192, 'mipmap-xxxhdpi')]

    for name, img in icons.items():
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

        print(f"    Generated all sizes for {name}")

if __name__ == '__main__':
    base_dir = os.path.dirname(os.path.abspath(__file__))

    grid_path = os.path.join(base_dir, 'grid_highres.png')
    output_dir = os.path.join(base_dir, 'fixed_icons')

    if os.path.exists(grid_path):
        print("Processing Canva icons...")
        icons = process_grid(grid_path, output_dir)

        print("\nGenerating platform sizes...")
        generate_all_sizes(icons, base_dir)

        print("\n✓ Done!")
    else:
        print(f"Grid not found: {grid_path}")
