import os
import sys
import time
import subprocess
from PIL import Image, ImageDraw, ImageFont, ImageFilter

RAW_DIR = os.path.abspath("playstore_screenshots/raw")
FRAMED_DIR = os.path.abspath("playstore_screenshots/framed")
STORE_DIR = os.path.abspath("playstore_screenshots/play_store_ready")

os.makedirs(RAW_DIR, exist_ok=True)
os.makedirs(FRAMED_DIR, exist_ok=True)
os.makedirs(STORE_DIR, exist_ok=True)

SCREEN_METADATA = [
    {
        "id": "01_home_dashboard",
        "title": "TRACK EVERY STRIDE",
        "subtitle": "Smart activity & health metrics dashboard",
    },
    {
        "id": "02_track_gps_run",
        "title": "REAL-TIME GPS TRACKING",
        "subtitle": "Precision workout maps, pace & elevation",
    },
    {
        "id": "03_daily_challenges",
        "title": "DAILY CHALLENGES & MISSIONS",
        "subtitle": "Stay motivated and earn bonus boosters",
    },
    {
        "id": "04_health_sensors",
        "title": "ADVANCED SENSORS & HEALTH",
        "subtitle": "Barometer, cadence & step breakdown",
    },
    {
        "id": "05_athlete_profile",
        "title": "ATHLETE PROFILE & STATS",
        "subtitle": "Personal bests, lifetime stats & milestones",
    },
    {
        "id": "06_activity_history",
        "title": "WORKOUT HISTORY & MAPS",
        "subtitle": "Detailed route logs, calories & pace",
    },
    {
        "id": "07_badges_achievements",
        "title": "EARN BADGES & TROPHIES",
        "subtitle": "Unlock achievements as you crush your goals",
    },
    {
        "id": "08_leaderboard",
        "title": "COMPETE ON LEADERBOARDS",
        "subtitle": "Rise to the top of daily & monthly rankings",
    },
    {
        "id": "09_welcome",
        "title": "YOUR RUNNING COMPANION",
        "subtitle": "Designed for runners, walkers & cyclists",
    },
    {
        "id": "10_onboarding",
        "title": "AI-POWERED COACHING",
        "subtitle": "Personalized fitness guidance for every athlete",
    },
    {
        "id": "11_sign_in",
        "title": "SEAMLESS CLOUD SYNC",
        "subtitle": "Instant backup across all your devices",
    },
]

def run_adb(cmd):
    full_cmd = f"adb {cmd}"
    res = subprocess.run(full_cmd, shell=True, capture_output=True, text=True)
    return res.stdout.strip()

def setup_demo_mode():
    print("[1/4] Enabling Android Demo Mode for clean status bar...")
    run_adb("shell settings put global sysui_demo_allowed 1")
    run_adb("shell am broadcast -a com.android.systemui.demo -e command enter")
    run_adb("shell am broadcast -a com.android.systemui.demo -e command notifications -e visible false")
    run_adb("shell am broadcast -a com.android.systemui.demo -e command clock -e hhmm 0941")
    run_adb("shell am broadcast -a com.android.systemui.demo -e command battery -e level 100 -e plugged false")
    run_adb("shell am broadcast -a com.android.systemui.demo -e command network -e mobile show -e datatype none -e level 4")

def capture_screen(screen_id):
    device_path = f"/sdcard/ss_{screen_id}.png"
    local_path = os.path.join(RAW_DIR, f"{screen_id}.png")
    run_adb(f"shell screencap -p {device_path}")
    run_adb(f"pull {device_path} \"{local_path}\"")
    run_adb(f"shell rm {device_path}")
    print(f"  -> Captured {screen_id} ({os.path.getsize(local_path)} bytes)")
    return local_path

def get_font(size, bold=False):
    # Try system fonts on Windows
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

def create_framed_screenshot(meta, raw_path):
    """
    Creates a 1080 x 2160 (18:9, aspect ratio exactly 2.0, Play Store maximum compliant)
    promotional graphic with modern gradient background, typography, and rounded device mockup.
    """
    CANVAS_W, CANVAS_H = 1080, 2160
    
    # 1. Base gradient: Athletic dark navy (#0B111E to #14223E) with vibrant accent glow
    img = Image.new("RGB", (CANVAS_W, CANVAS_H), "#0B111E")
    draw = ImageDraw.Draw(img)
    
    # Gradient background
    for y in range(CANVAS_H):
        t = y / CANVAS_H
        r = int(11 * (1 - t) + 18 * t)
        g = int(17 * (1 - t) + 32 * t)
        b = int(30 * (1 - t) + 65 * t)
        draw.line([(0, y), (CANVAS_W, y)], fill=(r, g, b))
    
    # Soft accent glow circle at top right
    glow = Image.new("RGBA", (CANVAS_W, CANVAS_H), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    glow_draw.ellipse([CANVAS_W - 300, -100, CANVAS_W + 300, 500], fill=(15, 103, 254, 45))
    glow_draw.ellipse([-150, 200, 350, 700], fill=(8, 180, 189, 30))
    img.paste(glow, (0, 0), glow)
    
    draw = ImageDraw.Draw(img)
    
    # 2. Category badge
    badge_text = "ATHLORUN  •  RUNNING & FITNESS"
    badge_font = get_font(26, bold=True)
    draw.text((CANVAS_W // 2, 110), badge_text, fill="#3D86FF", font=badge_font, anchor="mm")
    
    # 3. Main Title
    title_text = meta["title"]
    title_font = get_font(56, bold=True)
    draw.text((CANVAS_W // 2, 195), title_text, fill="#FFFFFF", font=title_font, anchor="mm")
    
    # 4. Subtitle
    sub_text = meta["subtitle"]
    sub_font = get_font(32, bold=False)
    draw.text((CANVAS_W // 2, 260), sub_text, fill="#9EA7B8", font=sub_font, anchor="mm")
    
    # 5. Device Mockup Frame
    raw = Image.open(raw_path).convert("RGBA")
    
    # Target phone frame width and height inside the 1080 canvas
    # Keep margin on left and right (e.g. 70px on each side -> 940px wide)
    FRAME_W = 920
    # Maintain original aspect ratio of raw screenshot
    raw_aspect = raw.height / raw.width
    FRAME_H = int(FRAME_W * raw_aspect)
    
    resized_screen = raw.resize((FRAME_W, FRAME_H), Image.Resampling.LANCZOS)
    
    # Rounded corners for the screen
    CORNER_RADIUS = 54
    mask = Image.new("L", (FRAME_W, FRAME_H), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, FRAME_W, FRAME_H], radius=CORNER_RADIUS, fill=255)
    
    # Drop shadow
    shadow_pad = 40
    shadow = Image.new("RGBA", (FRAME_W + shadow_pad * 2, FRAME_H + shadow_pad * 2), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(shadow)
    s_draw.rounded_rectangle(
        [shadow_pad - 6, shadow_pad + 12, shadow_pad + FRAME_W + 6, shadow_pad + FRAME_H + 18],
        radius=CORNER_RADIUS + 4,
        fill=(0, 0, 0, 160)
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(28))
    
    # Device outer bezel / border
    bezel = Image.new("RGBA", (FRAME_W + 20, FRAME_H + 20), (0, 0, 0, 0))
    b_draw = ImageDraw.Draw(bezel)
    b_draw.rounded_rectangle(
        [0, 0, FRAME_W + 20, FRAME_H + 20],
        radius=CORNER_RADIUS + 10,
        fill=(22, 29, 44, 255),
        outline=(60, 75, 105, 255),
        width=4
    )
    
    # Positioning
    pos_x = (CANVAS_W - FRAME_W) // 2
    pos_y = 350 # Below subtitle
    
    # Composite shadow, bezel, screen
    img.paste(shadow, (pos_x - shadow_pad, pos_y - shadow_pad), shadow)
    img.paste(bezel, (pos_x - 10, pos_y - 10), bezel)
    img.paste(resized_screen, (pos_x, pos_y), mask)
    
    # Convert to pure RGB without alpha (Google Play requirement)
    final_framed = img.convert("RGB")
    framed_path = os.path.join(FRAMED_DIR, f"{meta['id']}_framed.png")
    final_framed.save(framed_path, "PNG", optimize=True)
    
    # Also save a standard 1080x1920 Play Store 16:9 version
    store_16_9 = final_framed.resize((1080, 1920), Image.Resampling.LANCZOS)
    store_path = os.path.join(STORE_DIR, f"{meta['id']}_1080x1920.png")
    store_16_9.save(store_path, "PNG", optimize=True)
    
    # Also save standard raw full-bleed cropped to 1080x1920 (play store compliant aspect ratio)
    raw_rgb = raw.convert("RGB")
    # Resize raw to 1080 width, maintain aspect, center crop to 1920 if needed
    raw_w, raw_h = raw_rgb.size
    target_raw_w = 1080
    target_raw_h = int(raw_h * (1080 / raw_w))
    raw_scaled = raw_rgb.resize((target_raw_w, target_raw_h), Image.Resampling.LANCZOS)
    if target_raw_h >= 1920:
        # crop top/bottom evenly or take top
        crop_raw = raw_scaled.crop((0, 0, 1080, 1920))
    else:
        crop_raw = Image.new("RGB", (1080, 1920), "#FFFFFF")
        crop_raw.paste(raw_scaled, (0, (1920 - target_raw_h) // 2))
    raw_ready_path = os.path.join(STORE_DIR, f"{meta['id']}_raw_1080x1920.png")
    crop_raw.save(raw_ready_path, "PNG", optimize=True)

    print(f"  -> Generated Play Store framed & full-bleed graphics for {meta['id']}")

def capture_all_screens():
    print(f"\n[2/4] Starting automated capture of {len(SCREEN_METADATA)} screens...")
    time.sleep(2) # Initial settle
    
    for idx, meta in enumerate(SCREEN_METADATA):
        screen_id = meta["id"]
        print(f"\n--- Screen {idx+1}/{len(SCREEN_METADATA)}: {screen_id} ---")
        time.sleep(1.5) # Wait for animation/data to settle
        raw_path = capture_screen(screen_id)
        
        # Advance to next screen via adb keyevent KEYCODE_N (42)
        if idx < len(SCREEN_METADATA) - 1:
            print("  -> Advancing to next screen...")
            run_adb("shell input keyevent 42")

def process_all_screens():
    print("\n[3/4] Processing and generating Play Store framed mockups & standard sizes...")
    for meta in SCREEN_METADATA:
        raw_path = os.path.join(RAW_DIR, f"{meta['id']}.png")
        if os.path.exists(raw_path):
            create_framed_screenshot(meta, raw_path)
        else:
            print(f"  [!] Missing raw file: {raw_path}")

if __name__ == "__main__":
    setup_demo_mode()
    
    # If mode is process only:
    if len(sys.argv) > 1 and sys.argv[1] == "--process-only":
        process_all_screens()
    else:
        capture_all_screens()
        process_all_screens()
        
    print("\n[4/4] COMPLETE! Play Store screenshots generated at:")
    print(f"  - Framed Mockups: {FRAMED_DIR}")
    print(f"  - Play Store Ready (1080x1920): {STORE_DIR}")
    print(f"  - Raw Clean Screens: {RAW_DIR}")
