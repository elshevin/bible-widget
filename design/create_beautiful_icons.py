#!/usr/bin/env python3
"""
Create beautiful app icons that fill the entire canvas.
Inspired by Canva's designs but ensuring edge-to-edge coverage.
"""

from PIL import Image, ImageDraw, ImageFilter, ImageFont
import os
import math

def create_gradient(size, colors, direction='vertical'):
    """Create a smooth gradient between multiple colors."""
    img = Image.new('RGB', (size, size))
    draw = ImageDraw.Draw(img)

    if direction == 'vertical':
        for y in range(size):
            ratio = y / size
            # Interpolate between colors
            if len(colors) == 2:
                c1, c2 = colors
                r = int(c1[0] + (c2[0] - c1[0]) * ratio)
                g = int(c1[1] + (c2[1] - c1[1]) * ratio)
                b = int(c1[2] + (c2[2] - c1[2]) * ratio)
            else:
                # Multi-color gradient
                segment = ratio * (len(colors) - 1)
                idx = int(segment)
                if idx >= len(colors) - 1:
                    idx = len(colors) - 2
                local_ratio = segment - idx
                c1, c2 = colors[idx], colors[idx + 1]
                r = int(c1[0] + (c2[0] - c1[0]) * local_ratio)
                g = int(c1[1] + (c2[1] - c1[1]) * local_ratio)
                b = int(c1[2] + (c2[2] - c1[2]) * local_ratio)
            draw.line([(0, y), (size, y)], fill=(r, g, b))
    elif direction == 'diagonal':
        for y in range(size):
            for x in range(size):
                ratio = (x + y) / (2 * size)
                if len(colors) == 2:
                    c1, c2 = colors
                    r = int(c1[0] + (c2[0] - c1[0]) * ratio)
                    g = int(c1[1] + (c2[1] - c1[1]) * ratio)
                    b = int(c1[2] + (c2[2] - c1[2]) * ratio)
                    img.putpixel((x, y), (r, g, b))
    return img

def draw_cross(img, color, center, size, thickness, shadow=True):
    """Draw a cross with optional shadow."""
    draw = ImageDraw.Draw(img)
    cx, cy = center
    arm_v = size  # vertical arm length
    arm_h = int(size * 0.7)  # horizontal arm shorter
    crossbar_y = cy - int(size * 0.25)  # crossbar position

    if shadow:
        # Draw shadow
        shadow_offset = 4
        shadow_color = (0, 0, 0, 80)
        # Create shadow layer
        shadow_layer = Image.new('RGBA', img.size, (0, 0, 0, 0))
        shadow_draw = ImageDraw.Draw(shadow_layer)

        # Vertical bar shadow
        shadow_draw.rectangle([
            cx - thickness//2 + shadow_offset, cy - arm_v + shadow_offset,
            cx + thickness//2 + shadow_offset, cy + arm_v + shadow_offset
        ], fill=(0, 0, 0, 60))
        # Horizontal bar shadow
        shadow_draw.rectangle([
            cx - arm_h + shadow_offset, crossbar_y - thickness//2 + shadow_offset,
            cx + arm_h + shadow_offset, crossbar_y + thickness//2 + shadow_offset
        ], fill=(0, 0, 0, 60))

        shadow_layer = shadow_layer.filter(ImageFilter.GaussianBlur(8))
        img.paste(Image.alpha_composite(Image.new('RGBA', img.size, (0,0,0,0)), shadow_layer), (0, 0), shadow_layer)

    # Vertical bar
    draw.rectangle([
        cx - thickness//2, cy - arm_v,
        cx + thickness//2, cy + arm_v
    ], fill=color)

    # Horizontal bar
    draw.rectangle([
        cx - arm_h, crossbar_y - thickness//2,
        cx + arm_h, crossbar_y + thickness//2
    ], fill=color)

def draw_star(draw, center, size, color):
    """Draw a 4-point star."""
    cx, cy = center
    points = [
        (cx, cy - size),        # top
        (cx + size//3, cy),     # right
        (cx, cy + size),        # bottom
        (cx - size//3, cy),     # left
    ]
    draw.polygon(points, fill=color)

def draw_decorative_stars(img, color, count=8, radius_ratio=0.35):
    """Draw decorative stars around the center."""
    draw = ImageDraw.Draw(img)
    size = img.size[0]
    center = size // 2
    radius = size * radius_ratio

    for i in range(count):
        angle = (2 * math.pi * i / count) - math.pi / 2
        x = center + int(radius * math.cos(angle))
        y = center + int(radius * math.sin(angle))
        star_size = size // 35
        draw_star(draw, (x, y), star_size, color)

def add_wave_pattern(img, wave_color, opacity=0.3):
    """Add decorative wave pattern at the bottom."""
    size = img.size[0]
    wave = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(wave)

    # Draw wavy lines
    wave_height = size // 4
    base_y = size - wave_height

    for offset in range(0, wave_height, 20):
        points = []
        for x in range(0, size + 1, 5):
            y = base_y + offset + int(30 * math.sin(x * 0.02 + offset * 0.1))
            points.append((x, y))
        points.append((size, size))
        points.append((0, size))

        alpha = int(255 * opacity * (1 - offset / wave_height))
        draw.polygon(points, fill=(*wave_color, alpha))

    return Image.alpha_composite(img.convert('RGBA'), wave)

# Icon configurations
ICONS = {
    'navy_stars': {
        'gradient': [(15, 25, 55), (35, 55, 100)],
        'cross': (212, 175, 85),
        'stars': (255, 215, 100),
        'wave': None,
    },
    'cream_olive': {
        'gradient': [(250, 245, 235), (240, 230, 215)],
        'cross': (120, 90, 60),
        'stars': None,
        'accent': (107, 142, 35),
    },
    'gold_luxe': {
        'gradient': [(20, 20, 25), (35, 30, 40)],
        'cross': (212, 175, 55),
        'stars': (255, 200, 80),
        'wave': None,
    },
    'white_wave': {
        'gradient': [(250, 252, 255), (230, 240, 250)],
        'cross': (180, 150, 100),
        'stars': (50, 70, 120),
        'wave': (70, 100, 150),
    },
    'teal_pink': {
        'gradient': [(0, 150, 150), (0, 120, 130)],
        'cross': (220, 180, 120),
        'stars': (255, 200, 220),
        'wave': (255, 180, 200),
    },
    'ocean_clouds': {
        'gradient': [(25, 45, 80), (70, 130, 180)],
        'cross': (212, 175, 85),
        'stars': (255, 220, 120),
        'wave': (200, 220, 240),
    },
    'night_gold': {
        'gradient': [(60, 50, 80), (120, 100, 150)],
        'cross': (240, 240, 250),
        'stars': (255, 200, 80),
        'wave': None,
    },
    'sunset_coral': {
        'gradient': [(255, 150, 120), (255, 100, 80)],
        'cross': (100, 60, 50),
        'stars': None,
        'wave': (100, 180, 180),
    },
    'royal_purple': {
        'gradient': [(80, 40, 120), (120, 60, 150)],
        'cross': (255, 180, 80),
        'stars': (255, 220, 150),
        'wave': (200, 180, 220),
    },
}

def create_icon(name, config, size=1024):
    """Create a beautiful icon."""
    # Create gradient background
    img = create_gradient(size, config['gradient'])
    img = img.convert('RGBA')

    # Add wave pattern if specified
    if config.get('wave'):
        img = add_wave_pattern(img, config['wave'], opacity=0.4)

    # Draw cross with proper margins
    cross_size = int(size * 0.32)  # Cross takes about 64% of height
    thickness = int(size * 0.06)
    center = (size // 2, size // 2)

    draw_cross(img, config['cross'], center, cross_size, thickness)

    # Draw stars if specified
    if config.get('stars'):
        draw_decorative_stars(img, config['stars'], count=8, radius_ratio=0.38)

    return img.convert('RGB')

def generate_all_sizes(img, name, base_dir):
    """Generate all platform sizes."""
    project_dir = os.path.dirname(base_dir)

    # iOS
    ios_folder = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets',
                              f'AppIcon-{name}.appiconset')
    os.makedirs(ios_folder, exist_ok=True)

    for s, filename in [(40, 'Icon-40.png'), (58, 'Icon-58.png'), (60, 'Icon-60.png'),
                        (80, 'Icon-80.png'), (87, 'Icon-87.png'), (120, 'Icon-120.png'),
                        (180, 'Icon-180.png')]:
        resized = img.resize((s, s), Image.Resampling.LANCZOS)
        resized.save(os.path.join(ios_folder, filename), 'PNG')

    # Android
    android_res = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')
    for s, folder in [(48, 'mipmap-mdpi'), (72, 'mipmap-hdpi'), (96, 'mipmap-xhdpi'),
                      (144, 'mipmap-xxhdpi'), (192, 'mipmap-xxxhdpi')]:
        out_dir = os.path.join(android_res, folder)
        os.makedirs(out_dir, exist_ok=True)
        resized = img.resize((s, s), Image.Resampling.LANCZOS)
        resized.save(os.path.join(out_dir, f'ic_launcher_{name}.png'), 'PNG')

    # Flutter preview
    flutter_dir = os.path.join(project_dir, 'assets', 'icons')
    os.makedirs(flutter_dir, exist_ok=True)
    preview = img.resize((120, 120), Image.Resampling.LANCZOS)
    preview.save(os.path.join(flutter_dir, f'icon_{name}.png'), 'PNG')

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    output_dir = os.path.join(base_dir, 'beautiful_icons')
    os.makedirs(output_dir, exist_ok=True)

    for name, config in ICONS.items():
        print(f"Creating {name}...")
        img = create_icon(name, config)
        img.save(os.path.join(output_dir, f'{name}_1024.png'), 'PNG')
        generate_all_sizes(img, name, base_dir)
        print(f"  ✓ Done")

    print("\n✓ All icons created!")

if __name__ == '__main__':
    main()
