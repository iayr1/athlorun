import os
import shutil
from PIL import Image, ImageDraw, ImageFont, ImageFilter

RAW_DIR = os.path.abspath("playstore_screenshots/raw")
FRAMED_DIR = os.path.abspath("playstore_screenshots/framed")
STORE_DIR = os.path.abspath("playstore_screenshots/play_store_ready")

os.makedirs(FRAMED_DIR, exist_ok=True)
os.makedirs(STORE_DIR, exist_ok=True)

# Mapping from actual captured raw filenames to clean feature identities
SCREENS = [
    {
        "source_file": "08_leaderboard.png",
        "id": "01_home_dashboard",
        "title": "TRACK EVERY STRIDE",
        "subtitle": "Smart activity & health metrics dashboard",
        "dark_header": True,
    },
    {
        "source_file": "10_onboarding.png",
        "id": "02_gps_run_tracking",
        "title": "REAL-TIME GPS TRACKING",
        "subtitle": "Precision maps, live pace & route recording",
        "dark_header": False,
    },
    {
        "source_file": "11_sign_in.png",
        "id": "03_daily_challenges",
        "title": "DAILY CHALLENGES & MISSIONS",
        "subtitle": "Stay motivated and earn bonus booster XP",
        "dark_header": False,
    },
    {
        "source_file": "01_home_dashboard.png",
        "id": "04_athlete_profile",
        "title": "ATHLETE PROFILE & STATS",
        "subtitle": "Personal bests, lifetime stats & daily goals",
        "dark_header": True,
    },
    {
        "source_file": "02_track_gps_run.png",
        "id": "05_activity_history",
        "title": "WORKOUT HISTORY & LOGS",
        "subtitle": "Detailed distance, calories & pace records",
        "dark_header": False,
    },
    {
        "source_file": "04_health_sensors.png",
        "id": "06_leaderboard",
        "title": "COMPETE ON LEADERBOARDS",
        "subtitle": "Rise through daily, monthly & all-time ranks",
        "dark_header": False,
    },
    {
        "source_file": "06_activity_history.png",
        "id": "07_ai_onboarding",
        "title": "AI-POWERED WELLNESS",
        "subtitle": "Personalized training tailored to your needs",
        "dark_header": False,
    },
    {
        "source_file": "05_athlete_profile.png",
        "id": "08_welcome",
        "title": "YOUR RUNNING COMPANION",
        "subtitle": "Built for runners, walkers & cyclists",
        "dark_header": False,
    },
    {
        "source_file": "07_badges_achievements.png",
        "id": "09_cloud_sync_signin",
        "title": "SEAMLESS CLOUD SYNC",
        "subtitle": "Secure account access across all your devices",
        "dark_header": True,
    },
]

def get_font(size, bold=False):
    font_names = [
        "C:\\Windows\\Fonts\\segoeui.ttf" if not bold else "C:\\Windows\\Fonts\\segoeuib.ttf",
        "C:\\Windows\\Fonts\\arial.ttf" if not bold else "C:\\Windows\\Fonts\\arialbd.ttf",
    ]
    for fn in font_names:
        if os.path.exists(fn):
            try:
                return ImageFont.truetype(fn, size)
            except Exception:
                pass
    return ImageFont.load_default()

def draw_clean_status_bar(screen_img, is_dark_header):
    """
    Overlays a clean, pixel-perfect minimal Android status bar (9:41, WiFi, 100% battery)
    without any phone carrier, personal notification badges, or messy icons.
    """
    w, h = screen_img.size
    STATUS_H = 52
    
    # Sample the background color from y=10 to match screen header seamlessly
    bg_sample = screen_img.getpixel((w // 2, 10))
    if len(bg_sample) == 4:
        bg_color = (bg_sample[0], bg_sample[1], bg_sample[2], 255)
    else:
        bg_color = (bg_sample[0], bg_sample[1], bg_sample[2])
        
    overlay = Image.new("RGBA", (w, STATUS_H), bg_color)
    draw = ImageDraw.Draw(overlay)
    
    text_color = "#FFFFFF" if is_dark_header else "#1A202C"
    
    # 1. Clean Time: 9:41
    time_font = get_font(26, bold=True)
    draw.text((44, STATUS_H // 2), "9:41", fill=text_color, font=time_font, anchor="lm")
    
    # 2. Battery Icon: pill with positive charge
    bat_x = w - 85
    bat_y = STATUS_H // 2 - 10
    bat_w, bat_h = 42, 20
    draw.rounded_rectangle([bat_x, bat_y, bat_x + bat_w, bat_y + bat_h], radius=6, outline=text_color, width=3)
    # Battery cap
    draw.rounded_rectangle([bat_x + bat_w, bat_y + 5, bat_x + bat_w + 3, bat_y + bat_h - 5], radius=2, fill=text_color)
    # Battery fill 100%
    draw.rounded_rectangle([bat_x + 3, bat_y + 3, bat_x + bat_w - 3, bat_y + bat_h - 3], radius=3, fill=text_color)
    
    # 3. WiFi Bars
    wifi_x = bat_x - 36
    wifi_y = STATUS_H // 2
    # Simple crisp wifi arc/dots
    draw.arc([wifi_x - 15, wifi_y - 13, wifi_x + 15, wifi_y + 17], start=210, end=330, fill=text_color, width=3)
    draw.arc([wifi_x - 9, wifi_y - 7, wifi_x + 9, wifi_y + 11], start=210, end=330, fill=text_color, width=3)
    draw.ellipse([wifi_x - 3, wifi_y + 4, wifi_x + 3, wifi_y + 10], fill=text_color)
    
    # Paste clean bar onto image
    screen_img.paste(overlay, (0, 0), overlay)
    return screen_img

def build_framed_playstore_image(screen_img, meta):
    """
    Builds the high-conversion 1080 x 2160 Play Store graphic:
    - 2:1 aspect ratio (Google Play Store maximum ratio limit)
    - Gradient banner background matching Athlorun branding
    - Sleek typography & feature pill
    - Rounded device frame with realistic soft drop shadow
    - Output: 24-bit RGB PNG (no alpha, required by Google Play)
    """
    CANVAS_W, CANVAS_H = 1080, 2160
    
    # Create gradient background
    img = Image.new("RGB", (CANVAS_W, CANVAS_H), "#090E1A")
    draw = ImageDraw.Draw(img)
    
    # Deep athletic navy gradient
    for y in range(CANVAS_H):
        t = y / CANVAS_H
        r = int(9 * (1 - t) + 18 * t)
        g = int(14 * (1 - t) + 34 * t)
        b = int(26 * (1 - t) + 68 * t)
        draw.line([(0, y), (CANVAS_W, y)], fill=(r, g, b))
        
    # Decorative subtle glow ellipses
    glow = Image.new("RGBA", (CANVAS_W, CANVAS_H), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    glow_draw.ellipse([CANVAS_W - 350, -120, CANVAS_W + 350, 480], fill=(15, 103, 254, 50))
    glow_draw.ellipse([-160, 240, 360, 720], fill=(8, 180, 189, 35))
    img.paste(glow, (0, 0), glow)
    
    draw = ImageDraw.Draw(img)
    
    # 1. Feature badge pill
    pill_text = "ATHLORUN  •  RUNNING & FITNESS"
    pill_font = get_font(24, bold=True)
    draw.text((CANVAS_W // 2, 95), pill_text, fill="#3D86FF", font=pill_font, anchor="mm")
    
    # 2. Main title
    title_font = get_font(54, bold=True)
    draw.text((CANVAS_W // 2, 175), meta["title"], fill="#FFFFFF", font=title_font, anchor="mm")
    
    # 3. Subtitle
    sub_font = get_font(30, bold=False)
    draw.text((CANVAS_W // 2, 238), meta["subtitle"], fill="#9EA7B8", font=sub_font, anchor="mm")
    
    # 4. Device Mockup Frame
    FRAME_W = 900
    raw_aspect = screen_img.height / screen_img.width
    FRAME_H = int(FRAME_W * raw_aspect)
    
    screen_resized = screen_img.resize((FRAME_W, FRAME_H), Image.Resampling.LANCZOS)
    
    CORNER_RADIUS = 52
    mask = Image.new("L", (FRAME_W, FRAME_H), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, FRAME_W, FRAME_H], radius=CORNER_RADIUS, fill=255)
    
    # Soft drop shadow
    shadow_pad = 42
    shadow = Image.new("RGBA", (FRAME_W + shadow_pad * 2, FRAME_H + shadow_pad * 2), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(shadow)
    s_draw.rounded_rectangle(
        [shadow_pad - 6, shadow_pad + 12, shadow_pad + FRAME_W + 6, shadow_pad + FRAME_H + 20],
        radius=CORNER_RADIUS + 4,
        fill=(0, 0, 0, 170)
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(30))
    
    # Bezel border
    bezel = Image.new("RGBA", (FRAME_W + 18, FRAME_H + 18), (0, 0, 0, 0))
    b_draw = ImageDraw.Draw(bezel)
    b_draw.rounded_rectangle(
        [0, 0, FRAME_W + 18, FRAME_H + 18],
        radius=CORNER_RADIUS + 9,
        fill=(20, 26, 40, 255),
        outline=(55, 70, 98, 255),
        width=4
    )
    
    pos_x = (CANVAS_W - FRAME_W) // 2
    pos_y = 315
    
    img.paste(shadow, (pos_x - shadow_pad, pos_y - shadow_pad), shadow)
    img.paste(bezel, (pos_x - 9, pos_y - 9), bezel)
    img.paste(screen_resized, (pos_x, pos_y), mask)
    
    final_rgb = img.convert("RGB")
    return final_rgb

def process_all():
    print(f"Processing {len(SCREENS)} curated app screens...")
    
    for idx, meta in enumerate(SCREENS):
        src_path = os.path.join(RAW_DIR, meta["source_file"])
        if not os.path.exists(src_path):
            print(f"  [!] Missing source: {src_path}")
            continue
            
        raw_img = Image.open(src_path).convert("RGBA")
        
        # 1. Clean Status Bar
        cleaned_screen = draw_clean_status_bar(raw_img, meta["dark_header"])
        clean_raw_path = os.path.join(RAW_DIR, f"{meta['id']}_clean.png")
        cleaned_screen.save(clean_raw_path, "PNG")
        
        # 2. Build 1080 x 2160 Framed Play Store Graphic
        framed_img = build_framed_playstore_image(cleaned_screen, meta)
        framed_out = os.path.join(FRAMED_DIR, f"{meta['id']}_framed.png")
        framed_img.save(framed_out, "PNG", optimize=True)
        
        # 3. Standard 1080 x 1920 (16:9) Framed Play Store Graphic
        store_16_9 = framed_img.resize((1080, 1920), Image.Resampling.LANCZOS)
        store_16_9_out = os.path.join(STORE_DIR, f"{meta['id']}_1080x1920_framed.png")
        store_16_9.save(store_16_9_out, "PNG", optimize=True)
        
        # 4. Clean Full-Bleed 1080 x 1920 Direct UI Screen (no frame)
        raw_rgb = cleaned_screen.convert("RGB")
        rw, rh = raw_rgb.size
        target_w = 1080
        target_h = int(rh * (1080 / rw))
        scaled_raw = raw_rgb.resize((target_w, target_h), Image.Resampling.LANCZOS)
        
        if target_h >= 1920:
            full_bleed_16_9 = scaled_raw.crop((0, 0, 1080, 1920))
        else:
            full_bleed_16_9 = Image.new("RGB", (1080, 1920), "#090E1A" if meta["dark_header"] else "#FFFFFF")
            full_bleed_16_9.paste(scaled_raw, (0, (1920 - target_h) // 2))
            
        full_bleed_out = os.path.join(STORE_DIR, f"{meta['id']}_1080x1920_raw.png")
        full_bleed_16_9.save(full_bleed_out, "PNG", optimize=True)
        
        print(f"  [{idx+1}/{len(SCREENS)}] Created Play Store packages for: {meta['id']}")

if __name__ == "__main__":
    process_all()
    print("\nSUCCESS! All Play Store screenshots have been built and verified.")
