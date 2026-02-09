#!/usr/bin/env python3
"""
Process the Canva-generated 3x3 icon grid.
Extract each icon and generate all required sizes for iOS and Android.
"""

from PIL import Image
import os

# Icon names in order (left to right, top to bottom)
ICON_NAMES = [
    'navy_stars',    # Row 1
    'cream_olive',
    'gold_luxe',
    'white_wave',    # Row 2
    'teal_pink',
    'ocean_clouds',
    'night_gold',    # Row 3
    'sunset_coral',
    'royal_purple',
]

# iOS required sizes for alternate icons
IOS_SIZES = [
    (40, '20x20@2x'),
    (60, '20x20@3x'),
    (58, '29x29@2x'),
    (87, '29x29@3x'),
    (80, '40x40@2x'),
    (120, '40x40@3x'),
    (120, '60x60@2x'),
    (180, '60x60@3x'),
]

# Android mipmap sizes
ANDROID_SIZES = [
    (48, 'mipmap-mdpi'),
    (72, 'mipmap-hdpi'),
    (96, 'mipmap-xhdpi'),
    (144, 'mipmap-xxhdpi'),
    (192, 'mipmap-xxxhdpi'),
]


def extract_icons_from_grid(grid_path, output_dir):
    """Extract 9 icons from the 3x3 grid image."""
    img = Image.open(grid_path)
    width, height = img.size

    print(f"Grid image size: {width}x{height}")

    # Based on the actual Canva grid layout:
    # The 1024x1024 image has 9 icons in a 3x3 grid
    # Each icon is approximately 290x290 with small gaps
    # Starting position is around (55, 55)

    start_x = 55
    start_y = 55
    icon_size = 290
    gap = 22  # Gap between icons

    print(f"Icon size: {icon_size}, gap: {gap}")

    icons = {}
    for idx, name in enumerate(ICON_NAMES):
        row = idx // 3
        col = idx % 3

        # Calculate position
        x = start_x + col * (icon_size + gap)
        y = start_y + row * (icon_size + gap)

        # Crop the icon
        box = (x, y, x + icon_size, y + icon_size)
        icon = img.crop(box)

        # Save the extracted icon at max size
        icon_path = os.path.join(output_dir, f'{name}_raw.png')
        icon.save(icon_path, 'PNG')
        icons[name] = icon
        print(f"Extracted {name} at position ({x}, {y})")

    return icons


def remove_rounded_corners(img, corner_radius_percent=0.18):
    """
    The Canva icons have rounded corners. We need to fill them with the
    dominant background color to make them square.
    """
    width, height = img.size

    # Sample colors from the edges (away from corners) to get the actual icon background
    # Take multiple samples along each edge and find the dominant color
    samples = []

    # Top edge (middle section)
    for x in range(width // 3, 2 * width // 3, 5):
        samples.append(img.getpixel((x, 5)))

    # Bottom edge (middle section)
    for x in range(width // 3, 2 * width // 3, 5):
        samples.append(img.getpixel((x, height - 6)))

    # Left edge (middle section)
    for y in range(height // 3, 2 * height // 3, 5):
        samples.append(img.getpixel((5, y)))

    # Right edge (middle section)
    for y in range(height // 3, 2 * height // 3, 5):
        samples.append(img.getpixel((width - 6, y)))

    # Find the most common color (this is likely the background)
    from collections import Counter
    bg_color = Counter(samples).most_common(1)[0][0]

    # Convert to RGB if necessary
    if len(bg_color) == 4:
        bg_color = bg_color[:3]

    # Create a new image with the background color filling everything
    result = Image.new('RGB', (width, height), bg_color)

    # The rounded corner radius - Canva uses about 18% of icon size
    radius = int(width * corner_radius_percent)

    # Create a mask for the rounded rectangle
    # We want to KEEP the center and fill corners with bg_color

    # Copy pixels from original, but for corners, extend the edge color
    img_rgb = img.convert('RGB')

    for y in range(height):
        for x in range(width):
            # Determine if this pixel is in a corner region
            in_corner = False
            corner_center = None

            # Top-left corner
            if x < radius and y < radius:
                in_corner = True
                corner_center = (radius, radius)

            # Top-right corner
            elif x >= width - radius and y < radius:
                in_corner = True
                corner_center = (width - radius, radius)

            # Bottom-left corner
            elif x < radius and y >= height - radius:
                in_corner = True
                corner_center = (radius, height - radius)

            # Bottom-right corner
            elif x >= width - radius and y >= height - radius:
                in_corner = True
                corner_center = (width - radius, height - radius)

            if in_corner:
                # Check if outside the rounded corner
                dist = ((x - corner_center[0]) ** 2 + (y - corner_center[1]) ** 2) ** 0.5
                if dist > radius:
                    # Outside the rounded corner - use background color
                    result.putpixel((x, y), bg_color)
                else:
                    # Inside the rounded area - use original pixel
                    result.putpixel((x, y), img_rgb.getpixel((x, y)))
            else:
                # Not in a corner - use original pixel
                result.putpixel((x, y), img_rgb.getpixel((x, y)))

    return result


def generate_ios_icons(icons, output_base):
    """Generate all required iOS icon sizes."""
    ios_assets = os.path.join(output_base, 'ios', 'Runner', 'Assets.xcassets')

    for name, icon in icons.items():
        # Make icon square (fill corners)
        square_icon = remove_rounded_corners(icon)

        # Create appiconset folder
        folder = os.path.join(ios_assets, f'AppIcon-{name}.appiconset')
        os.makedirs(folder, exist_ok=True)

        # Generate each size
        for size, size_name in IOS_SIZES:
            resized = square_icon.resize((size, size), Image.Resampling.LANCZOS)
            filename = f'Icon-{size}.png'
            resized.save(os.path.join(folder, filename), 'PNG')

        # Generate Contents.json
        contents = generate_ios_contents_json()
        with open(os.path.join(folder, 'Contents.json'), 'w') as f:
            import json
            json.dump(contents, f, indent=2)

        print(f"Generated iOS icons for {name}")


def generate_ios_contents_json():
    """Generate Contents.json for iOS alternate icon."""
    images = [
        {"size": "20x20", "idiom": "iphone", "filename": "Icon-40.png", "scale": "2x"},
        {"size": "20x20", "idiom": "iphone", "filename": "Icon-60.png", "scale": "3x"},
        {"size": "29x29", "idiom": "iphone", "filename": "Icon-58.png", "scale": "2x"},
        {"size": "29x29", "idiom": "iphone", "filename": "Icon-87.png", "scale": "3x"},
        {"size": "40x40", "idiom": "iphone", "filename": "Icon-80.png", "scale": "2x"},
        {"size": "40x40", "idiom": "iphone", "filename": "Icon-120.png", "scale": "3x"},
        {"size": "60x60", "idiom": "iphone", "filename": "Icon-120.png", "scale": "2x"},
        {"size": "60x60", "idiom": "iphone", "filename": "Icon-180.png", "scale": "3x"},
    ]
    return {
        "images": images,
        "info": {"version": 1, "author": "xcode"}
    }


def generate_android_icons(icons, output_base):
    """Generate Android mipmap icons."""
    android_res = os.path.join(output_base, 'android', 'app', 'src', 'main', 'res')

    for name, icon in icons.items():
        # Make icon square (fill corners)
        square_icon = remove_rounded_corners(icon)

        for size, folder in ANDROID_SIZES:
            output_dir = os.path.join(android_res, folder)
            os.makedirs(output_dir, exist_ok=True)

            resized = square_icon.resize((size, size), Image.Resampling.LANCZOS)
            resized.save(os.path.join(output_dir, f'ic_launcher_{name}.png'), 'PNG')

        print(f"Generated Android icons for {name}")


def generate_flutter_preview(icons, output_base):
    """Generate preview icons for Flutter app."""
    preview_dir = os.path.join(output_base, 'assets', 'icons')
    os.makedirs(preview_dir, exist_ok=True)

    for name, icon in icons.items():
        # For preview, keep the rounded corners (looks nicer in the app)
        resized = icon.resize((120, 120), Image.Resampling.LANCZOS)
        resized.save(os.path.join(preview_dir, f'icon_{name}.png'), 'PNG')
        print(f"Generated Flutter preview for {name}")


def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(base_dir)

    # Input: the Canva-generated grid
    grid_path = os.path.join(project_dir, 'test_icon.png')

    if not os.path.exists(grid_path):
        print(f"Error: Grid image not found at {grid_path}")
        return

    # Create temp dir for extracted icons
    temp_dir = os.path.join(base_dir, 'extracted_icons')
    os.makedirs(temp_dir, exist_ok=True)

    print("Extracting icons from grid...")
    icons = extract_icons_from_grid(grid_path, temp_dir)

    print("\nGenerating iOS icons...")
    generate_ios_icons(icons, project_dir)

    print("\nGenerating Android icons...")
    generate_android_icons(icons, project_dir)

    print("\nGenerating Flutter previews...")
    generate_flutter_preview(icons, project_dir)

    print("\n✓ All icons processed successfully!")


if __name__ == '__main__':
    main()
