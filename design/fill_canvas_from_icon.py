#!/usr/bin/env python3
"""
Fill the entire canvas with the icon's internal content.
The Canva export has a rounded-corner icon on a background - we need to:
1. Detect the icon's internal area (inside the rounded corners)
2. Sample the icon's edge colors
3. Extend those colors to fill the entire canvas
"""

from PIL import Image
import os
import colorsys

def get_color_brightness(color):
    """Get brightness of a color (0-1)."""
    r, g, b = color[:3]
    return (r * 0.299 + g * 0.587 + b * 0.114) / 255

def is_similar_color(c1, c2, threshold=30):
    """Check if two colors are similar."""
    return all(abs(c1[i] - c2[i]) < threshold for i in range(3))

def find_icon_inner_bounds(img, corner_radius=80):
    """
    Find the inner rectangular area of the rounded-corner icon.
    We look for the area where the icon content is, avoiding the rounded corners.
    """
    width, height = img.size

    # Sample the outer background color (top-left corner)
    outer_bg = img.getpixel((10, 10))

    # Find where the icon starts (first pixel that differs from outer background)
    left = 0
    for x in range(width):
        if not is_similar_color(img.getpixel((x, height // 2)), outer_bg, 40):
            left = x
            break

    right = width - 1
    for x in range(width - 1, -1, -1):
        if not is_similar_color(img.getpixel((x, height // 2)), outer_bg, 40):
            right = x
            break

    top = 0
    for y in range(height):
        if not is_similar_color(img.getpixel((width // 2, y)), outer_bg, 40):
            top = y
            break

    bottom = height - 1
    for y in range(height - 1, -1, -1):
        if not is_similar_color(img.getpixel((width // 2, y)), outer_bg, 40):
            bottom = y
            break

    # Add corner radius offset to get inside the rounded corners
    inner_left = left + corner_radius
    inner_right = right - corner_radius
    inner_top = top + corner_radius
    inner_bottom = bottom - corner_radius

    return (inner_left, inner_top, inner_right, inner_bottom)

def get_edge_color(img, edge, bounds, sample_depth=30):
    """
    Sample colors along an edge of the inner icon area.
    Returns the most common color at that edge.
    """
    inner_left, inner_top, inner_right, inner_bottom = bounds
    samples = []

    if edge == 'top':
        for x in range(inner_left, inner_right, 5):
            for d in range(sample_depth):
                samples.append(img.getpixel((x, inner_top + d)))
    elif edge == 'bottom':
        for x in range(inner_left, inner_right, 5):
            for d in range(sample_depth):
                samples.append(img.getpixel((x, inner_bottom - d)))
    elif edge == 'left':
        for y in range(inner_top, inner_bottom, 5):
            for d in range(sample_depth):
                samples.append(img.getpixel((inner_left + d, y)))
    elif edge == 'right':
        for y in range(inner_top, inner_bottom, 5):
            for d in range(sample_depth):
                samples.append(img.getpixel((inner_right - d, y)))

    # Find the most common color (excluding very dark or very bright outliers)
    from collections import Counter
    filtered = [c for c in samples if 0.05 < get_color_brightness(c) < 0.95]
    if not filtered:
        filtered = samples

    return Counter(filtered).most_common(1)[0][0] if filtered else (128, 128, 128)

def fill_canvas_from_icon(input_path, output_path):
    """
    Take an icon with rounded corners on a background and fill the entire canvas.
    """
    img = Image.open(input_path).convert('RGB')
    width, height = img.size

    print(f"Processing {input_path}")
    print(f"  Image size: {width}x{height}")

    # Find the inner bounds (inside rounded corners)
    bounds = find_icon_inner_bounds(img)
    inner_left, inner_top, inner_right, inner_bottom = bounds
    print(f"  Inner bounds: ({inner_left}, {inner_top}) to ({inner_right}, {inner_bottom})")

    # Get edge colors
    top_color = get_edge_color(img, 'top', bounds)
    bottom_color = get_edge_color(img, 'bottom', bounds)
    left_color = get_edge_color(img, 'left', bounds)
    right_color = get_edge_color(img, 'right', bounds)

    print(f"  Edge colors: top={top_color}, bottom={bottom_color}, left={left_color}, right={right_color}")

    # Create result image
    result = img.copy()

    # Fill top edge
    for y in range(inner_top):
        for x in range(width):
            result.putpixel((x, y), top_color)

    # Fill bottom edge
    for y in range(inner_bottom, height):
        for x in range(width):
            result.putpixel((x, y), bottom_color)

    # Fill left edge (between top and bottom fills)
    for y in range(inner_top, inner_bottom):
        for x in range(inner_left):
            result.putpixel((x, y), left_color)

    # Fill right edge (between top and bottom fills)
    for y in range(inner_top, inner_bottom):
        for x in range(inner_right, width):
            result.putpixel((x, y), right_color)

    # Handle the icon's rounded corners by filling them with the icon background color
    # Sample the icon's internal background (center area, avoiding the cross)
    icon_bg_samples = []
    center_x, center_y = width // 2, height // 2
    # Sample from the corners of the inner area (inside the icon but away from the cross)
    sample_points = [
        (inner_left + 20, inner_top + 20),
        (inner_right - 20, inner_top + 20),
        (inner_left + 20, inner_bottom - 20),
        (inner_right - 20, inner_bottom - 20),
    ]
    for px, py in sample_points:
        if inner_left < px < inner_right and inner_top < py < inner_bottom:
            icon_bg_samples.append(img.getpixel((px, py)))

    if icon_bg_samples:
        from collections import Counter
        icon_bg = Counter(icon_bg_samples).most_common(1)[0][0]
    else:
        icon_bg = top_color

    print(f"  Icon background: {icon_bg}")

    # Fill the rounded corner regions with the icon background
    # These are the corners between the edges and the icon content
    outer_bg = img.getpixel((10, 10))

    for y in range(height):
        for x in range(width):
            pixel = img.getpixel((x, y))
            # If this pixel is similar to the outer background, fill it
            if is_similar_color(pixel, outer_bg, 25):
                # Determine which edge color to use based on position
                if y < height // 2:
                    if x < width // 2:
                        fill_color = top_color  # top-left
                    else:
                        fill_color = top_color  # top-right
                else:
                    if x < width // 2:
                        fill_color = bottom_color  # bottom-left
                    else:
                        fill_color = bottom_color  # bottom-right
                result.putpixel((x, y), fill_color)

    result.save(output_path, 'PNG')
    print(f"  Saved to {output_path}")
    return result

def generate_all_sizes(filled_img, name, base_dir):
    """Generate all required sizes for iOS and Android."""
    project_dir = os.path.dirname(base_dir)

    # iOS sizes
    ios_assets = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets')
    ios_folder = os.path.join(ios_assets, f'AppIcon-{name}.appiconset')

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

    print(f"  Generated iOS icons for {name}")

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
        resized = filled_img.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(output_dir, f'ic_launcher_{name}.png'), 'PNG')

    print(f"  Generated Android icons for {name}")

    # Flutter preview
    flutter_icons = os.path.join(project_dir, 'assets', 'icons')
    preview = filled_img.resize((120, 120), Image.Resampling.LANCZOS)
    preview.save(os.path.join(flutter_icons, f'icon_{name}.png'), 'PNG')

    print(f"  Generated Flutter preview for {name}")

if __name__ == '__main__':
    base_dir = os.path.dirname(os.path.abspath(__file__))

    # Process the exported navy_stars icon
    input_path = os.path.join(base_dir, 'exported_navy_stars.png')
    output_path = os.path.join(base_dir, 'navy_stars_filled.png')

    if os.path.exists(input_path):
        filled = fill_canvas_from_icon(input_path, output_path)
        generate_all_sizes(filled, 'navy_stars', base_dir)
