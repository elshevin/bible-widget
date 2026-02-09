#!/usr/bin/env python3
"""
Create proper square app icons that fill the entire canvas.
No rounded corners - iOS will apply its own rounding.
"""

from PIL import Image, ImageDraw, ImageFilter, ImageFont
import os
import math

# Icon configurations
ICONS = {
    'navy_stars': {
        'bg_colors': [(26, 39, 68), (15, 25, 45)],  # Navy gradient
        'cross_color': (212, 165, 116),  # Gold
        'accent_color': (212, 165, 116),
        'style': 'stars',
    },
    'cream_olive': {
        'bg_colors': [(245, 237, 228), (235, 220, 200)],  # Cream
        'cross_color': (120, 90, 60),  # Brown
        'accent_color': (160, 140, 100),
        'style': 'leaves',
    },
    'gold_luxe': {
        'bg_colors': [(220, 180, 120), (180, 140, 80)],  # Gold gradient
        'cross_color': (100, 70, 40),  # Dark brown
        'accent_color': (255, 220, 160),
        'style': 'shine',
    },
    'white_wave': {
        'bg_colors': [(255, 255, 255), (248, 248, 252)],  # White
        'cross_color': (212, 165, 116),  # Gold
        'accent_color': (200, 210, 220),
        'style': 'waves',
    },
    'teal_pink': {
        'bg_colors': [(91, 191, 186), (255, 182, 193)],  # Teal to pink
        'cross_color': (255, 255, 255),  # White
        'accent_color': None,
        'style': 'gradient',
    },
    'ocean_clouds': {
        'bg_colors': [(135, 180, 220), (100, 150, 200)],  # Sky blue
        'cross_color': (255, 255, 255),  # White
        'accent_color': (255, 255, 255),
        'style': 'clouds',
    },
    'night_gold': {
        'bg_colors': [(45, 27, 78), (25, 15, 50)],  # Deep purple
        'cross_color': (232, 196, 124),  # Gold
        'accent_color': (232, 196, 124),
        'style': 'stars',
    },
    'sunset_coral': {
        'bg_colors': [(255, 140, 105), (255, 180, 150)],  # Coral
        'cross_color': (255, 255, 255),  # White
        'accent_color': (255, 200, 180),
        'style': 'gradient',
    },
    'royal_purple': {
        'bg_colors': [(107, 76, 138), (80, 50, 110)],  # Purple
        'cross_color': (212, 165, 116),  # Gold
        'accent_color': (180, 150, 200),
        'style': 'simple',
    },
}

def create_gradient(size, color1, color2, direction='vertical'):
    """Create a smooth gradient background."""
    img = Image.new('RGB', (size, size))

    for y in range(size):
        for x in range(size):
            if direction == 'vertical':
                ratio = y / size
            elif direction == 'diagonal':
                ratio = (x + y) / (2 * size)
            else:
                ratio = x / size

            r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
            g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
            b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
            img.putpixel((x, y), (r, g, b))

    return img


def draw_cross(draw, cx, cy, size, color, thickness_ratio=0.08, shadow=False):
    """Draw a beautiful Latin cross with optional shadow."""
    thickness = int(size * thickness_ratio)

    # Cross dimensions
    v_height = int(size * 0.55)
    h_width = int(size * 0.35)
    h_y_offset = int(v_height * 0.3)  # Horizontal bar position from top

    # Calculate positions
    v_top = cy - v_height // 2
    v_bottom = cy + v_height // 2
    h_left = cx - h_width // 2
    h_right = cx + h_width // 2
    h_y = v_top + h_y_offset

    # Draw shadow first if enabled
    if shadow:
        shadow_offset = 3
        shadow_color = tuple(max(0, c - 50) for c in color)
        # Vertical bar shadow
        draw.rectangle([
            cx - thickness // 2 + shadow_offset, v_top + shadow_offset,
            cx + thickness // 2 + shadow_offset, v_bottom + shadow_offset
        ], fill=shadow_color)
        # Horizontal bar shadow
        draw.rectangle([
            h_left + shadow_offset, h_y - thickness // 2 + shadow_offset,
            h_right + shadow_offset, h_y + thickness // 2 + shadow_offset
        ], fill=shadow_color)

    # Draw cross
    # Vertical bar
    draw.rectangle([
        cx - thickness // 2, v_top,
        cx + thickness // 2, v_bottom
    ], fill=color)

    # Horizontal bar
    draw.rectangle([
        h_left, h_y - thickness // 2,
        h_right, h_y + thickness // 2
    ], fill=color)


def add_stars(draw, size, color, count=5):
    """Add decorative stars."""
    positions = [
        (0.18, 0.18), (0.82, 0.15), (0.15, 0.75),
        (0.85, 0.78), (0.5, 0.12),
    ]

    for i, (px, py) in enumerate(positions[:count]):
        x, y = int(size * px), int(size * py)
        star_size = 4 + (i % 2) * 2

        # Four-pointed star
        points = [
            (x, y - star_size),
            (x + star_size * 0.3, y),
            (x, y + star_size),
            (x - star_size * 0.3, y),
        ]
        draw.polygon(points, fill=color)

        points = [
            (x - star_size, y),
            (x, y - star_size * 0.3),
            (x + star_size, y),
            (x, y + star_size * 0.3),
        ]
        draw.polygon(points, fill=color)


def add_leaves(draw, size, color):
    """Add decorative olive leaves on sides."""
    leaf_positions = [
        # Left side leaves
        (0.12, 0.35, -20), (0.14, 0.45, -15), (0.12, 0.55, -10),
        (0.14, 0.65, -5),
        # Right side leaves
        (0.88, 0.35, 20), (0.86, 0.45, 15), (0.88, 0.55, 10),
        (0.86, 0.65, 5),
    ]

    for px, py, angle in leaf_positions:
        x, y = int(size * px), int(size * py)
        # Simple ellipse for leaf
        w, h = 12, 5
        draw.ellipse([x - w, y - h, x + w, y + h], fill=color)


def add_waves(draw, size, color):
    """Add wave pattern at bottom."""
    for i in range(2):
        y_base = size - int(size * 0.22) + i * int(size * 0.08)
        wave_color = tuple(int(c * (0.85 + i * 0.1)) for c in color)

        points = []
        for x in range(0, size + 1, 2):
            y = y_base + int(math.sin(x / (size * 0.12) + i) * size * 0.04)
            points.append((x, y))
        points.append((size, size))
        points.append((0, size))

        draw.polygon(points, fill=wave_color)


def add_clouds(draw, size, color):
    """Add simple cloud shapes in corners."""
    cloud_data = [
        (0.15, 0.18, 18),
        (0.85, 0.15, 15),
        (0.12, 0.82, 16),
        (0.88, 0.85, 14),
    ]

    for px, py, r in cloud_data:
        cx, cy = int(size * px), int(size * py)
        # Cloud as overlapping circles
        for dx, dy, dr in [(-r*0.4, 0, r*0.6), (r*0.4, 0, r*0.6), (0, -r*0.2, r*0.5)]:
            x, y = cx + dx, cy + dy
            draw.ellipse([x - dr, y - dr, x + dr, y + dr], fill=color)


def create_icon(name, config, size):
    """Create a single app icon."""
    # Create gradient background
    if config['style'] == 'gradient' and name == 'teal_pink':
        img = create_gradient(size, config['bg_colors'][0], config['bg_colors'][1], 'diagonal')
    else:
        img = create_gradient(size, config['bg_colors'][0], config['bg_colors'][1], 'vertical')

    draw = ImageDraw.Draw(img)
    cx, cy = size // 2, size // 2

    # Add style-specific decorations BEFORE cross
    style = config['style']
    accent = config.get('accent_color')

    if style == 'stars' and accent:
        add_stars(draw, size, accent)
    elif style == 'leaves' and accent:
        add_leaves(draw, size, accent)
    elif style == 'waves' and accent:
        add_waves(draw, size, accent)
    elif style == 'clouds' and accent:
        add_clouds(draw, size, accent)

    # Draw the cross
    draw_cross(draw, cx, cy, size, config['cross_color'], shadow=(style != 'simple'))

    return img


def generate_all_icons():
    """Generate all icon sizes for iOS, Android, and Flutter."""
    base_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(base_dir)

    ios_assets = os.path.join(project_dir, 'ios', 'Runner', 'Assets.xcassets')
    android_res = os.path.join(project_dir, 'android', 'app', 'src', 'main', 'res')
    flutter_icons = os.path.join(project_dir, 'assets', 'icons')

    # iOS sizes
    ios_sizes = [(40, 'Icon-40.png'), (58, 'Icon-58.png'), (60, 'Icon-60.png'),
                 (80, 'Icon-80.png'), (87, 'Icon-87.png'), (120, 'Icon-120.png'),
                 (180, 'Icon-180.png')]

    # Android sizes
    android_sizes = [(48, 'mipmap-mdpi'), (72, 'mipmap-hdpi'), (96, 'mipmap-xhdpi'),
                     (144, 'mipmap-xxhdpi'), (192, 'mipmap-xxxhdpi')]

    for name, config in ICONS.items():
        print(f"Generating {name}...")

        # Create high-res version (512px) and scale down for quality
        icon = create_icon(name, config, 512)

        # iOS icons
        ios_folder = os.path.join(ios_assets, f'AppIcon-{name}.appiconset')
        os.makedirs(ios_folder, exist_ok=True)
        for size, filename in ios_sizes:
            resized = icon.resize((size, size), Image.Resampling.LANCZOS)
            resized.save(os.path.join(ios_folder, filename), 'PNG')

        # Android icons
        for size, folder in android_sizes:
            output_dir = os.path.join(android_res, folder)
            os.makedirs(output_dir, exist_ok=True)
            resized = icon.resize((size, size), Image.Resampling.LANCZOS)
            resized.save(os.path.join(output_dir, f'ic_launcher_{name}.png'), 'PNG')

        # Flutter preview (120px)
        preview = icon.resize((120, 120), Image.Resampling.LANCZOS)
        preview.save(os.path.join(flutter_icons, f'icon_{name}.png'), 'PNG')

        print(f"  ✓ {name} complete")

    print("\n✓ All icons generated successfully!")


if __name__ == '__main__':
    generate_all_icons()
