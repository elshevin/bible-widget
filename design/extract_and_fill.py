#!/usr/bin/env python3
"""
Extract the icon from Canva output and fill the entire canvas.
Canva generates icons with rounded corners on a gray background.
We need to extract just the icon area and extend it to fill the whole square.
"""

from PIL import Image
import os

def find_icon_bounds(img):
    """Find the bounding box of the actual icon (non-gray area)."""
    width, height = img.size

    # Get the background color (corner pixel)
    bg_color = img.getpixel((5, 5))

    # Find bounds
    left, top, right, bottom = width, height, 0, 0

    for y in range(height):
        for x in range(width):
            pixel = img.getpixel((x, y))
            # Check if pixel is significantly different from background
            diff = sum(abs(pixel[i] - bg_color[i]) for i in range(3))
            if diff > 30:  # Threshold
                left = min(left, x)
                top = min(top, y)
                right = max(right, x)
                bottom = max(bottom, y)

    return left, top, right, bottom


def get_dominant_edge_color(img, edge, bounds):
    """Get the dominant color along an edge of the icon area."""
    left, top, right, bottom = bounds
    samples = []

    if edge == 'top':
        for x in range(left + 10, right - 10, 5):
            samples.append(img.getpixel((x, top + 5)))
    elif edge == 'bottom':
        for x in range(left + 10, right - 10, 5):
            samples.append(img.getpixel((x, bottom - 5)))
    elif edge == 'left':
        for y in range(top + 10, bottom - 10, 5):
            samples.append(img.getpixel((left + 5, y)))
    elif edge == 'right':
        for y in range(top + 10, bottom - 10, 5):
            samples.append(img.getpixel((right - 5, y)))

    from collections import Counter
    if samples:
        return Counter(samples).most_common(1)[0][0]
    return (128, 128, 128)


def extract_and_fill_icon(img_path, output_path):
    """Extract icon and fill entire canvas with it."""
    img = Image.open(img_path).convert('RGB')
    width, height = img.size

    # Find the icon bounds
    bounds = find_icon_bounds(img)
    left, top, right, bottom = bounds

    print(f"  Icon bounds: ({left}, {top}) to ({right}, {bottom})")

    # Crop just the icon area
    icon = img.crop((left, top, right + 1, bottom + 1))
    icon_w, icon_h = icon.size

    # Get the icon's background color (from center-top edge)
    icon_bg = icon.getpixel((icon_w // 2, 5))

    # Create new image with icon background color filling everything
    result = Image.new('RGB', (width, height), icon_bg)

    # Calculate position to center the icon
    paste_x = (width - icon_w) // 2
    paste_y = (height - icon_h) // 2

    # Paste the icon
    result.paste(icon, (paste_x, paste_y))

    # Now fill the edges with the icon's edge colors
    # Top edge
    top_color = get_dominant_edge_color(result, 'top', (paste_x, paste_y, paste_x + icon_w, paste_y + icon_h))
    for y in range(paste_y):
        for x in range(width):
            result.putpixel((x, y), top_color)

    # Bottom edge
    bottom_color = get_dominant_edge_color(result, 'bottom', (paste_x, paste_y, paste_x + icon_w, paste_y + icon_h))
    for y in range(paste_y + icon_h, height):
        for x in range(width):
            result.putpixel((x, y), bottom_color)

    # Left edge
    left_color = get_dominant_edge_color(result, 'left', (paste_x, paste_y, paste_x + icon_w, paste_y + icon_h))
    for y in range(paste_y, paste_y + icon_h):
        for x in range(paste_x):
            result.putpixel((x, y), left_color)

    # Right edge
    right_color = get_dominant_edge_color(result, 'right', (paste_x, paste_y, paste_x + icon_w, paste_y + icon_h))
    for y in range(paste_y, paste_y + icon_h):
        for x in range(paste_x + icon_w, width):
            result.putpixel((x, y), right_color)

    # Fill corners
    # Top-left
    for y in range(paste_y):
        for x in range(paste_x):
            result.putpixel((x, y), top_color)
    # Top-right
    for y in range(paste_y):
        for x in range(paste_x + icon_w, width):
            result.putpixel((x, y), top_color)
    # Bottom-left
    for y in range(paste_y + icon_h, height):
        for x in range(paste_x):
            result.putpixel((x, y), bottom_color)
    # Bottom-right
    for y in range(paste_y + icon_h, height):
        for x in range(paste_x + icon_w, width):
            result.putpixel((x, y), bottom_color)

    result.save(output_path, 'PNG')
    print(f"  Saved to {output_path}")
    return result


def process_icon(input_path, name):
    """Process a single icon and generate all sizes."""
    base_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(base_dir)

    # Extract and fill
    output_path = os.path.join(base_dir, 'canva_icons', f'{name}_filled.png')
    filled = extract_and_fill_icon(input_path, output_path)

    # Generate iOS sizes
    ios_assets = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets')
    ios_folder = os.path.join(ios_assets, f'AppIcon-{name}.appiconset')

    ios_sizes = [(40, 'Icon-40.png'), (58, 'Icon-58.png'), (60, 'Icon-60.png'),
                 (80, 'Icon-80.png'), (87, 'Icon-87.png'), (120, 'Icon-120.png'),
                 (180, 'Icon-180.png')]

    for size, filename in ios_sizes:
        resized = filled.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(ios_folder, filename), 'PNG')

    # Generate Android sizes
    android_res = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')
    android_sizes = [(48, 'mipmap-mdpi'), (72, 'mipmap-hdpi'), (96, 'mipmap-xhdpi'),
                     (144, 'mipmap-xxhdpi'), (192, 'mipmap-xxxhdpi')]

    for size, folder in android_sizes:
        output_dir = os.path.join(android_res, folder)
        resized = filled.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(output_dir, f'ic_launcher_{name}.png'), 'PNG')

    # Generate Flutter preview
    flutter_icons = os.path.join(project_dir, 'assets', 'icons')
    preview = filled.resize((120, 120), Image.Resampling.LANCZOS)
    preview.save(os.path.join(flutter_icons, f'icon_{name}.png'), 'PNG')

    print(f"  ✓ All sizes generated for {name}")


if __name__ == '__main__':
    base_dir = os.path.dirname(os.path.abspath(__file__))

    # Process navy_stars
    input_path = os.path.join(base_dir, 'canva_icons', 'icon_navy_stars.png')
    if os.path.exists(input_path):
        print("Processing navy_stars...")
        process_icon(input_path, 'navy_stars')
