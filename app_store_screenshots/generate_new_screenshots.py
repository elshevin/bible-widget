#!/usr/bin/env python3
"""Generate App Store screenshots at correct dimensions (1284x2778)
with large, bold headline text and phone mockups."""

from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os

# App Store screenshot size for iPhone 6.5"
W, H = 1284, 2778

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
BG_DIR = os.path.join(os.path.dirname(SCRIPT_DIR), "assets/images/backgrounds")
ICON_PATH = os.path.join(os.path.dirname(SCRIPT_DIR), "assets/icon/app_icon.png")

# Fonts
FONT_BOLD = "/System/Library/Fonts/Supplemental/Georgia Bold.ttf"
FONT_REG = "/System/Library/Fonts/Supplemental/Georgia.ttf"
FONT_SANS = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"


def gradient_bg(w, h, colors):
    """Create a vertical gradient background."""
    img = Image.new('RGB', (w, h))
    draw = ImageDraw.Draw(img)
    r1, g1, b1 = colors[0]
    r2, g2, b2 = colors[1]
    for y in range(h):
        t = y / h
        r = int(r1 + (r2 - r1) * t)
        g = int(g1 + (g2 - g1) * t)
        b = int(b1 + (b2 - b1) * t)
        draw.line([(0, y), (w, y)], fill=(r, g, b))
    return img


def draw_text_centered(draw, text, y, font, fill=(40, 30, 20), max_width=None):
    """Draw centered text, return bottom y position."""
    if max_width is None:
        max_width = W - 120

    # Word wrap
    words = text.split()
    lines = []
    current = ""
    for word in words:
        test = f"{current} {word}".strip()
        bbox = draw.textbbox((0, 0), test, font=font)
        if bbox[2] - bbox[0] > max_width:
            if current:
                lines.append(current)
            current = word
        else:
            current = test
    if current:
        lines.append(current)

    for line in lines:
        bbox = draw.textbbox((0, 0), line, font=font)
        tw = bbox[2] - bbox[0]
        th = bbox[3] - bbox[1]
        x = (W - tw) // 2
        draw.text((x, y), line, font=font, fill=fill)
        y += th + 15

    return y


def create_phone_frame(screen_img, phone_w=580):
    """Create a simple phone mockup with the given screen image."""
    # Phone dimensions
    bezel = 16
    corner_r = 45
    phone_h = int(phone_w * 2.17)  # iPhone aspect ratio

    # Create phone body (dark)
    phone = Image.new('RGBA', (phone_w, phone_h), (0, 0, 0, 0))
    phone_draw = ImageDraw.Draw(phone)

    # Phone body
    phone_draw.rounded_rectangle(
        [0, 0, phone_w - 1, phone_h - 1],
        radius=corner_r, fill=(30, 30, 30), outline=(60, 60, 60), width=2
    )

    # Screen area
    screen_x = bezel
    screen_y = bezel + 30  # top notch area
    screen_w = phone_w - 2 * bezel
    screen_h = phone_h - 2 * bezel - 50

    phone_draw.rounded_rectangle(
        [screen_x, screen_y, screen_x + screen_w, screen_y + screen_h],
        radius=20, fill=(0, 0, 0)
    )

    # Resize and paste screen content
    screen_resized = screen_img.resize((screen_w, screen_h), Image.LANCZOS)
    phone.paste(screen_resized, (screen_x, screen_y))

    # Dynamic island
    island_w = 120
    island_h = 35
    island_x = (phone_w - island_w) // 2
    island_y = screen_y + 8
    phone_draw.rounded_rectangle(
        [island_x, island_y, island_x + island_w, island_y + island_h],
        radius=17, fill=(0, 0, 0)
    )

    return phone


def load_bg_as_screen(bg_name, verse_text, verse_ref):
    """Load a background image and overlay verse text to simulate app screen."""
    bg_path = os.path.join(BG_DIR, bg_name)
    if not os.path.exists(bg_path):
        # Fallback gradient
        bg = gradient_bg(400, 867, [(80, 60, 120), (40, 30, 80)])
    else:
        bg = Image.open(bg_path).convert('RGB')
        bg = bg.resize((400, 867), Image.LANCZOS)

    draw = ImageDraw.Draw(bg)

    # Semi-transparent overlay for readability
    overlay = Image.new('RGBA', bg.size, (0, 0, 0, 60))
    bg = Image.alpha_composite(bg.convert('RGBA'), overlay).convert('RGB')
    draw = ImageDraw.Draw(bg)

    # Verse text
    try:
        verse_font = ImageFont.truetype(FONT_REG, 28)
        ref_font = ImageFont.truetype(FONT_REG, 22)
    except:
        verse_font = ImageFont.load_default()
        ref_font = verse_font

    # Center verse
    words = verse_text.split()
    lines = []
    current = ""
    for word in words:
        test = f"{current} {word}".strip()
        bbox = draw.textbbox((0, 0), test, font=verse_font)
        if bbox[2] - bbox[0] > 340:
            if current:
                lines.append(current)
            current = word
        else:
            current = test
    if current:
        lines.append(current)

    total_h = len(lines) * 38 + 30
    start_y = (bg.height - total_h) // 2

    for line in lines:
        bbox = draw.textbbox((0, 0), line, font=verse_font)
        tw = bbox[2] - bbox[0]
        x = (bg.width - tw) // 2
        # Shadow
        draw.text((x + 1, start_y + 1), line, font=verse_font, fill=(0, 0, 0, 120))
        draw.text((x, start_y), line, font=verse_font, fill=(255, 255, 255))
        start_y += 38

    # Reference
    bbox = draw.textbbox((0, 0), verse_ref, font=ref_font)
    tw = bbox[2] - bbox[0]
    draw.text(((bg.width - tw) // 2, start_y + 10), verse_ref, font=ref_font, fill=(255, 220, 180))

    return bg


def screenshot_01_homescreen():
    """Screenshot 1: Bible Verse on Your Home Screen"""
    print("Generating screenshot 1: Home Screen Widget...")

    bg = gradient_bg(W, H, [(245, 238, 228), (235, 225, 210)])
    draw = ImageDraw.Draw(bg)

    # Large headline
    title_font = ImageFont.truetype(FONT_BOLD, 105)
    sub_font = ImageFont.truetype(FONT_REG, 42)

    y = 180
    y = draw_text_centered(draw, "A Bible Verse", y, title_font)
    y = draw_text_centered(draw, "On Your", y + 10, title_font)
    y = draw_text_centered(draw, "Home Screen", y + 10, title_font)

    draw_text_centered(draw, "See it every time you pick up your phone", y + 30, sub_font, fill=(100, 80, 60))

    # Phone mockup with widget screen
    # Create a simulated home screen
    home = Image.new('RGB', (400, 867), (20, 15, 35))
    home_draw = ImageDraw.Draw(home)

    # Status bar area
    try:
        time_font = ImageFont.truetype(FONT_SANS, 20)
    except:
        time_font = ImageFont.load_default()
    home_draw.text((20, 15), "9:41", font=time_font, fill=(255, 255, 255))

    # Widget area - load a real background
    widget_bg_path = os.path.join(BG_DIR, "mountain_sunrise.png")
    if os.path.exists(widget_bg_path):
        widget_bg = Image.open(widget_bg_path).convert('RGB').resize((370, 180), Image.LANCZOS)
    else:
        widget_bg = Image.new('RGB', (370, 180), (160, 100, 60))

    # Round corners on widget
    widget_mask = Image.new('L', (370, 180), 0)
    mask_draw = ImageDraw.Draw(widget_mask)
    mask_draw.rounded_rectangle([0, 0, 369, 179], radius=22, fill=255)

    widget_final = Image.new('RGB', (370, 180), (20, 15, 35))
    widget_final.paste(widget_bg, (0, 0), widget_mask)

    # Add verse text on widget
    widget_draw = ImageDraw.Draw(widget_final)
    try:
        w_font = ImageFont.truetype(FONT_REG, 20)
        w_ref_font = ImageFont.truetype(FONT_REG, 16)
    except:
        w_font = ImageFont.load_default()
        w_ref_font = w_font

    verse = "The LORD is my shepherd;\nI shall lack nothing."
    for i, line in enumerate(verse.split('\n')):
        bbox = widget_draw.textbbox((0, 0), line, font=w_font)
        tw = bbox[2] - bbox[0]
        widget_draw.text(((370 - tw) // 2, 55 + i * 28), line, font=w_font, fill=(255, 255, 255))

    widget_draw.text((140, 130), "Psalm 23:1", font=w_ref_font, fill=(255, 220, 180))

    home.paste(widget_final, (15, 60))

    # "Bible Widget" label
    try:
        label_font = ImageFont.truetype(FONT_REG, 14)
    except:
        label_font = ImageFont.load_default()
    home_draw.text((150, 248), "Bible Widget", font=label_font, fill=(200, 200, 200))

    # Simulated app icons (colored squares)
    icon_colors = [
        (52, 199, 89), (255, 59, 48), (0, 122, 255), (255, 149, 0),
        (175, 82, 222), (255, 45, 85), (90, 200, 250), (255, 204, 0),
        (88, 86, 214), (255, 69, 58), (48, 209, 88), (0, 199, 190),
    ]
    icon_size = 65
    icon_gap = 20
    start_x = 25
    start_y = 290

    for i, color in enumerate(icon_colors):
        row = i // 4
        col = i % 4
        x = start_x + col * (icon_size + icon_gap)
        y_pos = start_y + row * (icon_size + icon_gap + 10)
        home_draw.rounded_rectangle(
            [x, y_pos, x + icon_size, y_pos + icon_size],
            radius=15, fill=color
        )

    phone = create_phone_frame(home, phone_w=620)

    # Center phone
    px = (W - phone.width) // 2
    py = H - phone.height - 80
    bg.paste(phone, (px, py), phone)

    bg.save(os.path.join(SCRIPT_DIR, "new_01_homescreen.png"), quality=95)
    print("  Done!")


def screenshot_02_themes():
    """Screenshot 2: 69 Beautiful Themes"""
    print("Generating screenshot 2: 69 Themes...")

    bg = gradient_bg(W, H, [(245, 238, 228), (240, 232, 218)])
    draw = ImageDraw.Draw(bg)

    # Huge headline
    title_font = ImageFont.truetype(FONT_BOLD, 120)
    sub_font = ImageFont.truetype(FONT_REG, 44)

    y = 180
    y = draw_text_centered(draw, "69 Beautiful", y, title_font)
    y = draw_text_centered(draw, "Themes", y + 10, title_font)
    y = draw_text_centered(draw, "Find one that feels like yours", y + 40, sub_font, fill=(100, 80, 60))

    # Grid of theme previews (3x3)
    theme_bgs = [
        "sunset_sky.png", "navy_stars.png", "cherry_blossom.png",
        "mountain_sunrise.png", "ocean_calm.png", "autumn_forest.png",
        "lavender_dream.png", "midnight.png", "coral_peach.png",
    ]

    card_w = 350
    card_h = 220
    gap = 25
    grid_w = 3 * card_w + 2 * gap
    start_x = (W - grid_w) // 2
    start_y = y + 60

    verses = [
        ("Be still, and know", "that I am God.", "Psalm 46:10"),
        ("The Lord is my", "shepherd.", "Psalm 23:1"),
        ("I can do all things", "through Christ.", "Phil 4:13"),
        ("For God so loved", "the world.", "John 3:16"),
        ("Trust in the Lord", "with all your heart.", "Prov 3:5"),
        ("The joy of the Lord", "is your strength.", "Neh 8:10"),
        ("God is love.", "", "1 John 4:8"),
        ("Fear not, for I", "am with you.", "Isaiah 41:10"),
        ("His mercy endures", "forever.", "Psalm 136:1"),
    ]

    for i, bg_name in enumerate(theme_bgs):
        row = i // 3
        col = i % 3
        x = start_x + col * (card_w + gap)
        cy = start_y + row * (card_h + gap)

        bg_path = os.path.join(BG_DIR, bg_name)
        if os.path.exists(bg_path):
            card = Image.open(bg_path).convert('RGB').resize((card_w, card_h), Image.LANCZOS)
        else:
            card = Image.new('RGB', (card_w, card_h), (100, 80, 120))

        # Darken slightly for text readability
        dark = Image.new('RGBA', (card_w, card_h), (0, 0, 0, 50))
        card = Image.alpha_composite(card.convert('RGBA'), dark).convert('RGB')

        # Add verse text
        card_draw = ImageDraw.Draw(card)
        try:
            cf = ImageFont.truetype(FONT_REG, 22)
            rf = ImageFont.truetype(FONT_REG, 16)
        except:
            cf = ImageFont.load_default()
            rf = cf

        v1, v2, ref = verses[i]
        # Center verse
        bbox1 = card_draw.textbbox((0, 0), v1, font=cf)
        tw1 = bbox1[2] - bbox1[0]
        vy = 65 if v2 else 80
        card_draw.text(((card_w - tw1) // 2, vy), v1, font=cf, fill=(255, 255, 255))
        if v2:
            bbox2 = card_draw.textbbox((0, 0), v2, font=cf)
            tw2 = bbox2[2] - bbox2[0]
            card_draw.text(((card_w - tw2) // 2, vy + 30), v2, font=cf, fill=(255, 255, 255))

        bbox_r = card_draw.textbbox((0, 0), ref, font=rf)
        twr = bbox_r[2] - bbox_r[0]
        card_draw.text(((card_w - twr) // 2, card_h - 40), ref, font=rf, fill=(255, 220, 180))

        # Round corners
        mask = Image.new('L', (card_w, card_h), 0)
        mask_draw = ImageDraw.Draw(mask)
        mask_draw.rounded_rectangle([0, 0, card_w - 1, card_h - 1], radius=20, fill=255)

        bg_region = bg.crop((x, cy, x + card_w, cy + card_h))
        bg_region.paste(card, (0, 0), mask)
        bg.paste(bg_region, (x, cy))

    bg.save(os.path.join(SCRIPT_DIR, "new_02_themes.png"), quality=95)
    print("  Done!")


def screenshot_03_daily():
    """Screenshot 3: Daily Verses, Quotes & Prayers"""
    print("Generating screenshot 3: Daily Verses...")

    bg = gradient_bg(W, H, [(25, 20, 40), (45, 35, 65)])
    draw = ImageDraw.Draw(bg)

    # Large white headline
    title_font = ImageFont.truetype(FONT_BOLD, 105)
    sub_font = ImageFont.truetype(FONT_REG, 42)

    y = 180
    y = draw_text_centered(draw, "Daily Verses,", y, title_font, fill=(255, 248, 235))
    y = draw_text_centered(draw, "Quotes &", y + 10, title_font, fill=(255, 248, 235))
    y = draw_text_centered(draw, "Prayers", y + 10, title_font, fill=(255, 248, 235))

    draw_text_centered(draw, "Start each morning with God's Word", y + 30, sub_font, fill=(180, 165, 145))

    # Phone with verse card
    screen = load_bg_as_screen(
        "sunset_sky.png",
        "I can do all things through Christ who strengthens me.",
        "- Philippians 4:13"
    )

    phone = create_phone_frame(screen, phone_w=580)
    px = (W - phone.width) // 2
    py = H - phone.height - 100
    bg.paste(phone, (px, py), phone)

    bg.save(os.path.join(SCRIPT_DIR, "new_03_daily.png"), quality=95)
    print("  Done!")


def screenshot_04_topics():
    """Screenshot 4: Browse by Topic"""
    print("Generating screenshot 4: Browse by Topic...")

    bg = gradient_bg(W, H, [(235, 240, 230), (220, 228, 215)])
    draw = ImageDraw.Draw(bg)

    # Large headline
    title_font = ImageFont.truetype(FONT_BOLD, 115)
    sub_font = ImageFont.truetype(FONT_REG, 42)

    y = 180
    y = draw_text_centered(draw, "Browse", y, title_font, fill=(40, 50, 35))
    y = draw_text_centered(draw, "by Topic", y + 10, title_font, fill=(40, 50, 35))

    draw_text_centered(draw, "Faith · Hope · Love · Peace & more", y + 40, sub_font, fill=(80, 90, 70))

    # Topic cards
    topics = [
        ("Faith", "✝", (180, 140, 100)),
        ("Hope", "☀", (200, 160, 80)),
        ("Love", "♥", (200, 100, 100)),
        ("Peace", "☮", (100, 160, 140)),
        ("Strength", "⛰", (140, 120, 100)),
        ("Gratitude", "🙏", (160, 140, 120)),
        ("Comfort", "🕊", (140, 140, 180)),
        ("Wisdom", "📖", (120, 140, 160)),
    ]

    card_w = 1000
    card_h = 110
    start_x = (W - card_w) // 2
    start_y = y + 100

    try:
        topic_font = ImageFont.truetype(FONT_BOLD, 38)
    except:
        topic_font = ImageFont.load_default()

    for i, (name, icon, color) in enumerate(topics):
        cy = start_y + i * (card_h + 20)

        # Card background
        card = Image.new('RGBA', (card_w, card_h), (255, 255, 255, 220))
        card_draw = ImageDraw.Draw(card)

        # Colored accent bar on left
        card_draw.rounded_rectangle([0, 0, card_w - 1, card_h - 1], radius=20, fill=(255, 255, 255, 220))
        card_draw.rectangle([0, 20, 8, card_h - 20], fill=color)

        # Topic name
        card_draw.text((40, 30), name, font=topic_font, fill=(50, 45, 40))

        # Arrow on right
        card_draw.text((card_w - 60, 30), "›", font=topic_font, fill=(150, 140, 130))

        # Paste with rounded corners
        mask = Image.new('L', (card_w, card_h), 0)
        mask_draw = ImageDraw.Draw(mask)
        mask_draw.rounded_rectangle([0, 0, card_w - 1, card_h - 1], radius=20, fill=255)

        bg.paste(card, (start_x, cy), mask)

    bg.save(os.path.join(SCRIPT_DIR, "new_04_topics.png"), quality=95)
    print("  Done!")


def screenshot_05_share():
    """Screenshot 5: Share Your Faith"""
    print("Generating screenshot 5: Share Your Faith...")

    bg = gradient_bg(W, H, [(248, 235, 225), (245, 225, 215)])
    draw = ImageDraw.Draw(bg)

    # Large headline
    title_font = ImageFont.truetype(FONT_BOLD, 110)
    sub_font = ImageFont.truetype(FONT_REG, 42)

    y = 180
    y = draw_text_centered(draw, "Share", y, title_font, fill=(80, 50, 40))
    y = draw_text_centered(draw, "Your Faith", y + 10, title_font, fill=(80, 50, 40))

    draw_text_centered(draw, "Beautiful verse cards for friends & family", y + 40, sub_font, fill=(120, 90, 70))

    # Show a beautiful share card
    share_card = load_bg_as_screen(
        "ocean_calm.png",
        "For God so loved the world, that he gave his only Son.",
        "- John 3:16"
    )

    phone = create_phone_frame(share_card, phone_w=580)
    px = (W - phone.width) // 2
    py = H - phone.height - 100
    bg.paste(phone, (px, py), phone)

    bg.save(os.path.join(SCRIPT_DIR, "new_05_share.png"), quality=95)
    print("  Done!")


if __name__ == "__main__":
    print(f"Generating App Store screenshots at {W}x{H}...")
    print(f"Output directory: {SCRIPT_DIR}")
    print()

    screenshot_01_homescreen()
    screenshot_02_themes()
    screenshot_03_daily()
    screenshot_04_topics()
    screenshot_05_share()

    print()
    print("All 5 screenshots generated!")
    print("Files: new_01_homescreen.png through new_05_share.png")
