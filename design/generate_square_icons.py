#!/usr/bin/env python3
"""
Generate beautiful square app icons without rounded corners.
iOS will apply its own rounded corners automatically.
"""

from PIL import Image, ImageDraw, ImageFilter
import os
import math

# Icon configurations with gradient colors and design elements
ICONS = {
    'navy_stars': {
        'bg_gradient': [(26, 39, 68), (15, 25, 50)],  # Navy blue gradient
        'cross_color': (212, 165, 116),  # Gold
        'decorations': 'stars',
    },
    'cream_olive': {
        'bg_gradient': [(245, 240, 232), (235, 225, 210)],  # Cream
        'cross_color': (139, 115, 85),  # Brown
        'decorations': 'olive',
    },
    'gold_luxe': {
        'bg_gradient': [(212, 165, 116), (180, 140, 80)],  # Gold gradient
        'cross_color': (100, 70, 30),  # Dark gold/brown
        'decorations': 'shine',
    },
    'white_wave': {
        'bg_gradient': [(255, 255, 255), (245, 245, 250)],  # White
        'cross_color': (212, 165, 116),  # Gold
        'decorations': 'waves',
    },
    'teal_pink': {
        'bg_gradient': [(91, 191, 186), (255, 182, 193)],  # Teal to pink
        'cross_color': (255, 255, 255),  # White
        'decorations': None,
    },
    'ocean_clouds': {
        'bg_gradient': [(74, 144, 184), (100, 170, 210)],  # Ocean blue
        'cross_color': (255, 255, 255),  # White
        'decorations': 'clouds',
    },
    'night_gold': {
        'bg_gradient': [(26, 39, 68), (40, 30, 70)],  # Night purple/navy
        'cross_color': (232, 196, 124),  # Gold
        'decorations': 'stars',
    },
    'sunset_coral': {
        'bg_gradient': [(255, 140, 105), (255, 180, 140)],  # Coral/orange
        'cross_color': (255, 255, 255),  # White
        'decorations': None,
    },
    'royal_purple': {
        'bg_gradient': [(107, 76, 138), (80, 50, 110)],  # Purple
        'cross_color': (212, 165, 116),  # Gold
        'decorations': 'shine',
    },
}


def create_gradient(size, color1, color2, direction='vertical'):
    """Create a gradient image."""
    img = Image.new('RGB', (size, size), color1)
    draw = ImageDraw.Draw(img)

    for y in range(size):
        ratio = y / size
        r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
        g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
        b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
        draw.line([(0, y), (size, y)], fill=(r, g, b))

    return img


def draw_cross(draw, cx, cy, size, color, thickness_ratio=0.12):
    """Draw a centered Latin cross."""
    thickness = int(size * thickness_ratio)
    arm_length = int(size * 0.35)

    # Vertical bar (full height)
    v_top = cy - arm_length
    v_bottom = cy + arm_length
    draw.rectangle([
        cx - thickness // 2, v_top,
        cx + thickness // 2, v_bottom
    ], fill=color)

    # Horizontal bar (positioned 1/3 from top)
    h_y = cy - arm_length // 3
    h_half = int(arm_length * 0.7)
    draw.rectangle([
        cx - h_half, h_y - thickness // 2,
        cx + h_half, h_y + thickness // 2
    ], fill=color)


def add_stars(draw, size, color, count=5):
    """Add small star decorations."""
    import random
    random.seed(42)  # Consistent positioning

    star_positions = [
        (size * 0.15, size * 0.2),
        (size * 0.85, size * 0.15),
        (size * 0.1, size * 0.7),
        (size * 0.9, size * 0.75),
        (size * 0.75, size * 0.85),
    ]

    for i, (x, y) in enumerate(star_positions[:count]):
        star_size = 3 + (i % 3) * 2
        # Simple 4-point star
        draw.polygon([
            (x, y - star_size),
            (x + star_size * 0.3, y),
            (x, y + star_size),
            (x - star_size * 0.3, y),
        ], fill=color)
        draw.polygon([
            (x - star_size, y),
            (x, y - star_size * 0.3),
            (x + star_size, y),
            (x, y + star_size * 0.3),
        ], fill=color)


def add_waves(draw, size, color):
    """Add wave pattern at bottom."""
    # Draw gentle curved waves at the bottom
    wave_colors = [
        (*color[:3],),  # Main color
        (int(color[0]*0.9), int(color[1]*0.9), int(color[2]*0.9)),  # Slightly darker
    ]

    for i, wave_color in enumerate(wave_colors):
        y_base = size - size * 0.25 + i * size * 0.08
        points = []
        for x in range(0, size + 5, 3):
            y = y_base + math.sin(x / (size * 0.15) + i * 1.5) * (size * 0.05)
            points.append((x, y))
        points.append((size, size))
        points.append((0, size))
        draw.polygon(points, fill=wave_color)


def add_clouds(draw, size, color):
    """Add simple cloud shapes in corners only (not covering cross)."""
    # Cloud positions - only in corners, away from center cross
    clouds = [
        (size * 0.12, size * 0.15, 15),  # Top-left
        (size * 0.88, size * 0.12, 12),  # Top-right
        (size * 0.1, size * 0.85, 14),   # Bottom-left
        (size * 0.9, size * 0.88, 13),   # Bottom-right
    ]

    for cx, cy, r in clouds:
        # Draw overlapping circles for cloud effect
        for dx, dy, dr in [(-r*0.5, 0, r*0.7), (r*0.5, 0, r*0.7), (0, -r*0.2, r*0.5)]:
            x, y = cx + dx, cy + dy
            draw.ellipse([x - dr, y - dr, x + dr, y + dr], fill=(255, 255, 255))


def add_olive(draw, size, color):
    """Add olive branch decoration."""
    # Simple leaf shapes on sides
    leaf_color = (139, 115, 85, 150)

    # Left branch
    for i in range(4):
        y = size * 0.3 + i * size * 0.12
        x = size * 0.12
        # Leaf shape
        draw.ellipse([x - 8, y - 3, x + 8, y + 3], fill=color)

    # Right branch
    for i in range(4):
        y = size * 0.35 + i * size * 0.12
        x = size * 0.88
        draw.ellipse([x - 8, y - 3, x + 8, y + 3], fill=color)


def create_icon(name, config, size):
    """Create a single icon."""
    # Create gradient background
    img = create_gradient(size, config['bg_gradient'][0], config['bg_gradient'][1])
    draw = ImageDraw.Draw(img)

    cx, cy = size // 2, size // 2

    # Add decorations before cross
    decorations = config.get('decorations')
    if decorations == 'stars':
        add_stars(draw, size, config['cross_color'], count=5)
    elif decorations == 'waves':
        add_waves(draw, size, config['cross_color'])
    elif decorations == 'clouds':
        add_clouds(draw, size, (255, 255, 255))
    elif decorations == 'olive':
        add_olive(draw, size, config['cross_color'])

    # Draw the cross
    draw_cross(draw, cx, cy, size, config['cross_color'])

    # Add subtle shine effect for some icons
    if decorations == 'shine':
        # Light reflection on top-left
        for i in range(20):
            alpha = 255 - i * 10
            r = size // 3 - i * 2
            if r > 0:
                # This is simplified - just brighten the area slightly
                pass

    return img


def main():
    sizes = {
        'ios': [(60, ''), (120, '@2x'), (180, '@3x')],
        'android': [
            (48, 'mipmap-mdpi'),
            (72, 'mipmap-hdpi'),
            (96, 'mipmap-xhdpi'),
            (144, 'mipmap-xxhdpi'),
            (192, 'mipmap-xxxhdpi'),
        ],
        'preview': [(120, '')],  # For Flutter asset preview
    }

    base_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(base_dir)

    # iOS output directories
    ios_assets_dir = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets')

    # Android output directories
    android_res_dir = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')

    # Flutter assets for preview
    flutter_icons_dir = os.path.join(project_dir, 'assets', 'icons')
    os.makedirs(flutter_icons_dir, exist_ok=True)

    for name, config in ICONS.items():
        print(f"Generating {name}...")

        # iOS icons
        ios_folder = os.path.join(ios_assets_dir, f'AppIcon-{name}.appiconset')
        os.makedirs(ios_folder, exist_ok=True)

        for size, suffix in sizes['ios']:
            img = create_icon(name, config, size)
            img.save(os.path.join(ios_folder, f'icon_{size}.png'), 'PNG')

        # Android icons
        for size, folder in sizes['android']:
            output_dir = os.path.join(android_res_dir, folder)
            os.makedirs(output_dir, exist_ok=True)
            img = create_icon(name, config, size)
            img.save(os.path.join(output_dir, f'ic_launcher_{name}.png'), 'PNG')

        # Flutter preview
        img = create_icon(name, config, 120)
        img.save(os.path.join(flutter_icons_dir, f'icon_{name}.png'), 'PNG')

    print("\n✓ All icons generated!")
    print("  - iOS icons in Assets.xcassets")
    print("  - Android icons in res/mipmap-*")
    print("  - Flutter preview icons in assets/icons")


if __name__ == '__main__':
    main()
