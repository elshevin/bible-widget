#!/usr/bin/env python3
"""
Compose real app screenshots into App Store marketing images.
Layout: Warm background + headline text on top + screenshot with rounded corners in center.
Output: 1290x2796 (iPhone 6.7" requirement)
"""

from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os

# === Configuration ===
OUTPUT_W, OUTPUT_H = 1284, 2778
BG_COLOR = (245, 240, 235)  # Warm cream/beige
TEXT_COLOR = (90, 75, 60)   # Warm dark brown
CORNER_RADIUS = 40
SHADOW_OFFSET = 15
SHADOW_BLUR = 30

# Screenshot source files and their configs
SCREENSHOTS = [
    {
        "file": "/Users/vincent/Desktop/04ecf0ce26e57f22bc6cb1eed02fae10.jpg",
        "headline": "Daily Inspiration",
        "subtitle": "Beautiful verses to start your day",
        "crop_top": 80,  # Remove Android status bar
        "crop_bottom": 0,
    },
    {
        "file": "/Users/vincent/Desktop/5a8e569a824764796c056f04124ba32e.jpg",
        "headline": "Explore Topics",
        "subtitle": "Faith, love, hope, prayer & more",
        "crop_top": 80,  # Remove Android status bar
        "crop_bottom": 0,
    },
    {
        "file": "/Users/vincent/Desktop/c264bcc1963f6f7b2f1111c82a800c87.jpg",
        "headline": "Beautiful Themes",
        "subtitle": "Personalize your experience",
        "crop_top": 80,  # Remove status bar
        "crop_bottom": 0,
    },
    {
        "file": "/Users/vincent/Desktop/f420960c64e93af75e24e442863ae88c.jpg",
        "headline": "Share Your Faith",
        "subtitle": "Send verses to friends & family",
        "crop_top": 80,  # Remove status bar
        "crop_bottom": 0,
    },
    {
        "file": "/Users/vincent/Desktop/IMG_0792.PNG",
        "headline": "Widget Settings",
        "subtitle": "Customize your home screen widget",
        "crop_top": 110,  # Remove iPhone status bar
        "crop_bottom": 0,
    },
]

OUTPUT_DIR = "/Users/vincent/Desktop/bible widget /code/bible_widgets/app_store_screenshots"


def round_corners(image, radius):
    """Add rounded corners to an image."""
    mask = Image.new("L", image.size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle([(0, 0), image.size], radius=radius, fill=255)
    result = image.copy()
    result.putalpha(mask)
    return result


def add_shadow(image, offset=10, blur=20, color=(0, 0, 0, 80)):
    """Add a drop shadow behind an image."""
    # Create a larger canvas for the shadow
    w, h = image.size
    shadow_canvas = Image.new("RGBA", (w + blur * 4, h + blur * 4), (0, 0, 0, 0))

    # Create shadow shape
    shadow = Image.new("RGBA", image.size, color)
    shadow.putalpha(image.split()[3])  # Use same alpha as image

    # Paste shadow offset
    shadow_canvas.paste(shadow, (blur * 2 + offset, blur * 2 + offset))

    # Blur the shadow
    shadow_canvas = shadow_canvas.filter(ImageFilter.GaussianBlur(blur))

    # Paste original on top
    shadow_canvas.paste(image, (blur * 2, blur * 2), image)

    return shadow_canvas


def get_font(size, bold=False):
    """Try to load a nice font, fallback to default."""
    font_paths = [
        "/System/Library/Fonts/SFPro-Bold.otf" if bold else "/System/Library/Fonts/SFPro-Regular.otf",
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf" if bold else "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
    ]
    for path in font_paths:
        if os.path.exists(path):
            try:
                return ImageFont.truetype(path, size)
            except Exception:
                continue
    return ImageFont.load_default()


def compose_screenshot(config, index):
    """Compose a single App Store screenshot."""
    print(f"  Processing {index + 1}/5: {config['headline']}...")

    # Load and crop screenshot
    screenshot = Image.open(config["file"]).convert("RGBA")
    w, h = screenshot.size

    crop_top = config["crop_top"]
    crop_bottom = config["crop_bottom"]
    if crop_top > 0 or crop_bottom > 0:
        screenshot = screenshot.crop((0, crop_top, w, h - crop_bottom))

    # Scale screenshot to fit in the canvas
    # Leave space: top 18% for text, bottom 5% padding, sides 8% padding
    max_w = int(OUTPUT_W * 0.84)
    max_h = int(OUTPUT_H * 0.72)

    # Scale proportionally
    sw, sh = screenshot.size
    scale = min(max_w / sw, max_h / sh)
    new_w = int(sw * scale)
    new_h = int(sh * scale)
    screenshot = screenshot.resize((new_w, new_h), Image.LANCZOS)

    # Round corners
    screenshot = round_corners(screenshot, CORNER_RADIUS)

    # Add shadow
    screenshot_with_shadow = add_shadow(screenshot, SHADOW_OFFSET, SHADOW_BLUR)

    # Create output canvas
    canvas = Image.new("RGBA", (OUTPUT_W, OUTPUT_H), BG_COLOR + (255,))

    # Add a subtle gradient overlay at top
    gradient = Image.new("RGBA", (OUTPUT_W, 400), (0, 0, 0, 0))
    draw_grad = ImageDraw.Draw(gradient)
    for y in range(400):
        alpha = int(15 * (1 - y / 400))
        draw_grad.line([(0, y), (OUTPUT_W, y)], fill=(200, 180, 160, alpha))
    canvas.paste(Image.alpha_composite(canvas.crop((0, 0, OUTPUT_W, 400)), gradient), (0, 0))

    # Draw headline text
    font_headline = get_font(96, bold=True)
    font_subtitle = get_font(52, bold=False)

    draw = ImageDraw.Draw(canvas)

    # Headline - centered
    headline = config["headline"]
    bbox = draw.textbbox((0, 0), headline, font=font_headline)
    text_w = bbox[2] - bbox[0]
    text_x = (OUTPUT_W - text_w) // 2
    text_y = 180
    draw.text((text_x, text_y), headline, fill=TEXT_COLOR, font=font_headline)

    # Subtitle - centered
    subtitle = config["subtitle"]
    bbox2 = draw.textbbox((0, 0), subtitle, font=font_subtitle)
    sub_w = bbox2[2] - bbox2[0]
    sub_x = (OUTPUT_W - sub_w) // 2
    sub_y = text_y + 120
    draw.text((sub_x, sub_y), subtitle, fill=TEXT_COLOR + (180,), font=font_subtitle)

    # Place screenshot centered below text
    sw_shadow, sh_shadow = screenshot_with_shadow.size
    x = (OUTPUT_W - sw_shadow) // 2
    y = sub_y + 120

    canvas.paste(screenshot_with_shadow, (x, y), screenshot_with_shadow)

    # Convert to RGB for saving as PNG (no alpha)
    final = Image.new("RGB", (OUTPUT_W, OUTPUT_H), BG_COLOR)
    final.paste(canvas, (0, 0), canvas)

    # Save
    output_path = os.path.join(OUTPUT_DIR, f"{index + 1:02d}_{'_'.join(config['headline'].lower().split())}.png")
    final.save(output_path, "PNG", quality=95)
    print(f"  Saved: {output_path}")
    return output_path


def main():
    print("Composing App Store screenshots...")
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    paths = []
    for i, config in enumerate(SCREENSHOTS):
        path = compose_screenshot(config, i)
        paths.append(path)

    print(f"\nDone! {len(paths)} screenshots generated in {OUTPUT_DIR}")
    for p in paths:
        print(f"  {os.path.basename(p)}")


if __name__ == "__main__":
    main()
