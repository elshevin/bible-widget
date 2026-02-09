#!/usr/bin/env python3
"""
Generate alternate app icons for iOS by applying color tints to the base icon.
"""

from PIL import Image, ImageEnhance, ImageFilter
import colorsys
import os

# Source icon
SOURCE_ICON = "Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png"

# Output directory (in Runner folder, not Assets.xcassets)
OUTPUT_DIR = "."

# Alternate icon configurations
# Each icon needs 60x60@2x (120px) and 60x60@3x (180px)
ICONS = {
    "dark": {"hue_shift": 0, "saturation": 0.3, "brightness": 0.3, "bg_color": (26, 26, 26)},
    "light": {"hue_shift": 0, "saturation": 0.2, "brightness": 1.2, "bg_color": (245, 237, 228)},
    "gold": {"hue_shift": 0.08, "saturation": 1.2, "brightness": 1.0, "bg_color": (212, 175, 55)},
    "rose": {"hue_shift": -0.05, "saturation": 0.8, "brightness": 1.0, "bg_color": (232, 180, 184)},
    "ocean": {"hue_shift": 0.55, "saturation": 1.0, "brightness": 1.0, "bg_color": (79, 172, 254)},
    "forest": {"hue_shift": 0.35, "saturation": 0.9, "brightness": 0.9, "bg_color": (113, 178, 128)},
    "sunset": {"hue_shift": 0.02, "saturation": 1.2, "brightness": 1.0, "bg_color": (255, 126, 95)},
}

SIZES = [
    (120, "60x60@2x"),
    (180, "60x60@3x"),
]

def shift_hue(img, hue_shift, saturation_mult=1.0, brightness_mult=1.0):
    """Shift the hue of an image while preserving alpha."""
    if img.mode != 'RGBA':
        img = img.convert('RGBA')

    # Split into channels
    r, g, b, a = img.split()

    # Convert to HSV and adjust
    pixels = img.load()
    width, height = img.size

    new_img = Image.new('RGBA', (width, height))
    new_pixels = new_img.load()

    for y in range(height):
        for x in range(width):
            r_val, g_val, b_val, a_val = pixels[x, y]

            if a_val > 0:  # Only process non-transparent pixels
                # Convert to HSV
                h, s, v = colorsys.rgb_to_hsv(r_val/255, g_val/255, b_val/255)

                # Adjust values
                h = (h + hue_shift) % 1.0
                s = min(1.0, max(0.0, s * saturation_mult))
                v = min(1.0, max(0.0, v * brightness_mult))

                # Convert back to RGB
                r_new, g_new, b_new = colorsys.hsv_to_rgb(h, s, v)
                new_pixels[x, y] = (int(r_new*255), int(g_new*255), int(b_new*255), a_val)
            else:
                new_pixels[x, y] = (0, 0, 0, 0)

    return new_img

def create_icon_with_background(source_img, bg_color, size):
    """Create an icon with a solid background color."""
    # Create background
    bg = Image.new('RGBA', (size, size), bg_color + (255,))

    # Resize source to fit (with padding)
    source_resized = source_img.resize((size, size), Image.Resampling.LANCZOS)

    # Composite
    bg.paste(source_resized, (0, 0), source_resized)

    return bg

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    source_path = os.path.join(script_dir, SOURCE_ICON)

    if not os.path.exists(source_path):
        print(f"Error: Source icon not found at {source_path}")
        return

    # Load source icon
    source = Image.open(source_path).convert('RGBA')
    print(f"Loaded source icon: {source.size}")

    for icon_name, config in ICONS.items():
        print(f"\nGenerating {icon_name} icon...")

        # Apply color transformation
        transformed = shift_hue(
            source,
            config["hue_shift"],
            config["saturation"],
            config["brightness"]
        )

        # Generate each size
        for size, suffix in SIZES:
            # Resize
            resized = transformed.resize((size, size), Image.Resampling.LANCZOS)

            # Output filename (iOS alternate icons use this naming convention)
            output_name = f"AppIcon-{icon_name}-{suffix}.png"
            output_path = os.path.join(script_dir, output_name)

            # Save
            resized.save(output_path, "PNG")
            print(f"  Created: {output_name}")

    print("\nDone! Now add these to Info.plist CFBundleAlternateIcons")

if __name__ == "__main__":
    main()
