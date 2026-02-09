#!/usr/bin/env python3
"""
Create simple, clean app icons with solid backgrounds that fill the entire canvas.
Each icon will have a solid color background with a simple cross design.
"""

from PIL import Image, ImageDraw, ImageFont
import os
import math

# Icon configurations - name: (bg_color, cross_color, accent_color)
ICON_CONFIGS = {
    'navy_stars': ((26, 35, 64), (212, 175, 85), (255, 215, 100)),  # Navy + Gold
    'cream_olive': ((245, 240, 230), (107, 142, 35), (85, 107, 47)),  # Cream + Olive
    'gold_luxe': ((25, 25, 30), (212, 175, 55), (255, 215, 0)),  # Black + Gold
    'white_wave': ((250, 250, 255), (100, 130, 180), (70, 100, 150)),  # White + Blue
    'teal_pink': ((0, 128, 128), (255, 182, 193), (255, 105, 180)),  # Teal + Pink
    'ocean_clouds': ((135, 206, 235), (255, 255, 255), (70, 130, 180)),  # Sky Blue + White
    'night_gold': ((20, 20, 35), (255, 215, 0), (255, 200, 50)),  # Dark + Gold
    'sunset_coral': ((255, 127, 80), (255, 255, 255), (255, 99, 71)),  # Coral + White
    'royal_purple': ((75, 0, 130), (255, 215, 0), (238, 130, 238)),  # Purple + Gold
}

def create_gradient_background(size, color1, color2, direction='vertical'):
    """Create a gradient background."""
    img = Image.new('RGB', (size, size))
    draw = ImageDraw.Draw(img)

    for i in range(size):
        ratio = i / size
        r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
        g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
        b = int(color1[2] * (1 - ratio) + color2[2] * ratio)

        if direction == 'vertical':
            draw.line([(0, i), (size, i)], fill=(r, g, b))
        else:
            draw.line([(i, 0), (i, size)], fill=(r, g, b))

    return img

def draw_cross(draw, size, color, thickness_ratio=0.08, length_ratio=0.5):
    """Draw a simple cross in the center."""
    center = size // 2
    thickness = int(size * thickness_ratio)
    arm_length = int(size * length_ratio)

    # Vertical bar
    draw.rectangle([
        center - thickness // 2,
        center - arm_length,
        center + thickness // 2,
        center + arm_length
    ], fill=color)

    # Horizontal bar (slightly higher than center)
    h_center = center - int(arm_length * 0.2)
    h_arm = int(arm_length * 0.7)
    draw.rectangle([
        center - h_arm,
        h_center - thickness // 2,
        center + h_arm,
        h_center + thickness // 2
    ], fill=color)

def draw_stars(draw, size, color, count=8):
    """Draw small decorative stars around the cross."""
    center = size // 2
    radius = size * 0.35

    for i in range(count):
        angle = (2 * math.pi * i / count) - math.pi / 2
        x = center + int(radius * math.cos(angle))
        y = center + int(radius * math.sin(angle))

        # Simple 4-point star
        star_size = size // 40
        points = [
            (x, y - star_size),
            (x + star_size // 2, y),
            (x, y + star_size),
            (x - star_size // 2, y),
        ]
        draw.polygon(points, fill=color)

def create_icon(name, config, size=1024):
    """Create a single icon with the given configuration."""
    bg_color, cross_color, accent_color = config

    # Create slightly lighter variant for gradient
    bg_light = tuple(min(255, c + 20) for c in bg_color)

    # Create gradient background
    img = create_gradient_background(size, bg_color, bg_light)
    draw = ImageDraw.Draw(img)

    # Draw cross
    draw_cross(draw, size, cross_color)

    # Draw stars for some icons
    if 'stars' in name or 'night' in name:
        draw_stars(draw, size, accent_color)

    return img

def generate_all_sizes(img, name, base_dir):
    """Generate all required sizes for iOS, Android, and Flutter."""
    project_dir = os.path.dirname(base_dir)

    # iOS
    ios_assets = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets')
    ios_folder = os.path.join(ios_assets, f'AppIcon-{name}.appiconset')
    os.makedirs(ios_folder, exist_ok=True)

    ios_sizes = [(40, 'Icon-40.png'), (58, 'Icon-58.png'), (60, 'Icon-60.png'),
                 (80, 'Icon-80.png'), (87, 'Icon-87.png'), (120, 'Icon-120.png'),
                 (180, 'Icon-180.png')]

    for size, filename in ios_sizes:
        resized = img.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(ios_folder, filename), 'PNG')

    # Android
    android_res = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')
    android_sizes = [(48, 'mipmap-mdpi'), (72, 'mipmap-hdpi'), (96, 'mipmap-xhdpi'),
                     (144, 'mipmap-xxhdpi'), (192, 'mipmap-xxxhdpi')]

    for size, folder in android_sizes:
        output_dir = os.path.join(android_res, folder)
        os.makedirs(output_dir, exist_ok=True)
        resized = img.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(output_dir, f'ic_launcher_{name}.png'), 'PNG')

    # Flutter preview
    flutter_icons = os.path.join(project_dir, 'assets', 'icons')
    os.makedirs(flutter_icons, exist_ok=True)
    preview = img.resize((120, 120), Image.Resampling.LANCZOS)
    preview.save(os.path.join(flutter_icons, f'icon_{name}.png'), 'PNG')

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    output_dir = os.path.join(base_dir, 'simple_icons')
    os.makedirs(output_dir, exist_ok=True)

    for name, config in ICON_CONFIGS.items():
        print(f"Creating {name}...")
        img = create_icon(name, config)

        # Save full size
        img.save(os.path.join(output_dir, f'{name}_1024.png'), 'PNG')

        # Generate all sizes
        generate_all_sizes(img, name, base_dir)

        print(f"  ✓ Generated all sizes for {name}")

    print("\n✓ All icons created!")

if __name__ == '__main__':
    main()
