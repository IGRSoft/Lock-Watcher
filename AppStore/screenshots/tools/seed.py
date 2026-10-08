"""Builds neutral sample "captures" and writes the app's history file (EasyStash JSON) for a screenshot-only container."""
import base64, io, json, sys, time
from PIL import Image, ImageDraw, ImageFont, ImageFilter

out_path = sys.argv[1]
APPLE_REF = 978307200  # JSONEncoder default: seconds since 2001-01-01

def scene(emoji, tone, shirt, seed):
    w, h = 1280, 720
    img = Image.new("RGB", (w, h))
    px = ImageDraw.Draw(img)
    for y in range(h):
        k = y / h
        px.line([(0, y), (w, y)], fill=(int(tone[0] - 28 * k), int(tone[1] - 26 * k), int(tone[2] - 22 * k)))
    # soft window light and a plain shelf for depth; no identifiable content
    d = ImageDraw.Draw(img, "RGBA")
    d.rectangle([90 + seed * 40, 70, 380 + seed * 40, 360], fill=(255, 255, 255, 70))
    d.rectangle([0, 520, w, 540], fill=(0, 0, 0, 25))
    img = img.filter(ImageFilter.GaussianBlur(3))
    d = ImageDraw.Draw(img, "RGBA")
    # shoulders and neck
    d.ellipse([310, 470, 970, 1050], fill=shirt)
    d.rectangle([575, 390, 705, 540], fill=(214, 170, 140))
    font = ImageFont.truetype("/System/Library/Fonts/Apple Color Emoji.ttc", 160)
    glyph = Image.new("RGBA", (200, 200), (0, 0, 0, 0))
    ImageDraw.Draw(glyph).text((0, 0), emoji, font=font, embedded_color=True)
    bbox = glyph.getbbox()
    glyph = glyph.crop(bbox).resize((440, 440), Image.LANCZOS)
    img.paste(glyph, (640 - 220, 140), glyph)
    return img

samples = [
    ("\U0001F60E", (210, 205, 198), (38, 42, 52), 0, 0),
    ("\U0001F978", (196, 202, 208), (70, 62, 58), 1, 26),
    ("\U0001F600", (214, 208, 196), (52, 66, 84), 2, 75),
    ("\U0001F914", (200, 198, 206), (44, 44, 48), 3, 140),
]
now = time.time()
dtos = []
for emoji, tone, shirt, seed, minutes_ago in samples:
    buf = io.BytesIO()
    scene(emoji, tone, shirt, seed).save(buf, "JPEG", quality=80)
    dtos.append({
        "date": now - minutes_ago * 60 - APPLE_REF,
        "data": base64.b64encode(buf.getvalue()).decode(),
    })
with open(out_path, "w") as f:
    json.dump({"dtos": dtos}, f)
