#!/usr/bin/env python3
"""
Fix icon corners by extending edge colors to fill the entire square.
The Canva grid has gray background showing in corners.
"""

from PIL import Image
import os

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


def get_edge_color(img, edge='top'):
    """Sample colors from the middle of an edge to get the true background."""
    width, height = img.size
    samples = []

    if edge == 'top':
        # Sample from top edge, middle third
        for x in range(width // 3, 2 * width // 3):
            samples.append(img.getpixel((x, 0)))
    elif edge == 'bottom':
        for x in range(width // 3, 2 * width // 3):
            samples.append(img.getpixel((x, height - 1)))
    elif edge == 'left':
        for y in range(height // 3, 2 * height // 3):
            samples.append(img.getpixel((0, y)))
    elif edge == 'right':
        for y in range(height // 3, 2 * height // 3):
            samples.append(img.getpixel((width - 1, y)))

    # Return the most common color
    from collections import Counter
    return Counter(samples).most_common(1)[0][0]


def fix_corners(img):
    """
    Fill corners with the appropriate edge color.
    Each corner gets the average of its two adjacent edges.
    """
    width, height = img.size
    img = img.convert('RGB')
    result = img.copy()

    # Get edge colors
    top_color = get_edge_color(img, 'top')
    bottom_color = get_edge_color(img, 'bottom')
    left_color = get_edge_color(img, 'left')
    right_color = get_edge_color(img, 'right')

    # The gray background color from Canva grid (approximately)
    # We'll detect it by checking if pixel is grayish
    def is_gray_background(pixel):
        r, g, b = pixel[:3]
        # Check if it's a grayish color (all channels similar, medium brightness)
        avg = (r + g + b) / 3
        spread = max(abs(r - avg), abs(g - avg), abs(b - avg))
        return spread < 20 and 180 < avg < 240  # Gray range

    # Corner radius is about 18% of icon size
    radius = int(width * 0.20)

    # Process each corner
    corners = [
        ('top-left', (0, 0), (radius, radius), top_color, left_color),
        ('top-right', (width - radius, 0), (width, radius), top_color, right_color),
        ('bottom-left', (0, height - radius), (radius, height), bottom_color, left_color),
        ('bottom-right', (width - radius, height - radius), (width, height), bottom_color, right_color),
    ]

    for name, (x1, y1), (x2, y2), color1, color2 in corners:
        # Blend the two edge colors for corner
        corner_color = (
            (color1[0] + color2[0]) // 2,
            (color1[1] + color2[1]) // 2,
            (color1[2] + color2[2]) // 2,
        )

        # Determine the corner center for distance calculation
        if 'top-left' in name:
            cx, cy = radius, radius
        elif 'top-right' in name:
            cx, cy = width - radius, radius
        elif 'bottom-left' in name:
            cx, cy = radius, height - radius
        else:  # bottom-right
            cx, cy = width - radius, height - radius

        # Fill pixels outside the rounded corner
        for y in range(y1, y2):
            for x in range(x1, x2):
                # Distance from corner center
                dist = ((x - cx) ** 2 + (y - cy) ** 2) ** 0.5

                if dist > radius:
                    # This pixel is outside the rounded corner
                    current = result.getpixel((x, y))

                    # Check if it's the gray background
                    if is_gray_background(current):
                        # Get the nearest edge color based on position
                        # Use gradient based on position within corner
                        if 'top' in name:
                            edge_y_color = top_color
                        else:
                            edge_y_color = bottom_color

                        if 'left' in name:
                            edge_x_color = left_color
                        else:
                            edge_x_color = right_color

                        # Blend based on position
                        dx = abs(x - cx) / radius if radius > 0 else 0
                        dy = abs(y - cy) / radius if radius > 0 else 0

                        # Simple blend - use the dominant direction's color
                        if dx > dy:
                            fill_color = edge_x_color
                        else:
                            fill_color = edge_y_color

                        result.putpixel((x, y), fill_color)

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

        # Load and fix corners
        img = Image.open(raw_path)
        fixed = fix_corners(img)

        # Save fixed version
        fixed_path = os.path.join(extracted_dir, f'{name}_fixed.png')
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

        # Generate Flutter preview
        preview = fixed.resize((120, 120), Image.Resampling.LANCZOS)
        preview.save(os.path.join(flutter_icons, f'icon_{name}.png'), 'PNG')

        print(f"  ✓ Generated all sizes for {name}")

    print("\n✓ All icons processed!")


if __name__ == '__main__':
    process_all_icons()
