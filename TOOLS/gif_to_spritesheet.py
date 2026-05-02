#!/usr/bin/env python3
"""Convert a GIF or video animation into a sprite sheet."""

import argparse
import math
import os
import random
import subprocess
import sys
import tempfile
from pathlib import Path

from PIL import Image, ImageEnhance, ImageFilter


def extract_frames_from_video(video_path: str, temp_dir: str, fps: int) -> list[Image.Image]:
    """Extract frames from a video file using ffmpeg."""
    cmd = [
        "ffmpeg",
        "-i", video_path,
        "-vf", f"fps={fps}",
        os.path.join(temp_dir, "frame_%04d.png"),
        "-y",
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error running ffmpeg: {result.stderr}", file=sys.stderr)
        sys.exit(1)

    frames = []
    for f in sorted(Path(temp_dir).glob("frame_*.png")):
        frames.append(Image.open(f).convert("RGBA"))
    return frames


def extract_frames_from_gif(gif_path: str) -> list[Image.Image]:
    """Extract frames from a GIF file."""
    with Image.open(gif_path) as gif:
        frames = []
        try:
            while True:
                frames.append(gif.copy().convert("RGBA"))
                gif.seek(gif.tell() + 1)
        except EOFError:
            pass
    return frames


def apply_vhs_effect(frame: Image.Image, noise_intensity: float = 0.008, vignette_strength: float = 0.15) -> Image.Image:
    """Apply very subtle VHS camera effect to a frame."""
    w, h = frame.size
    frame = frame.convert("RGBA")

    # --- Chromatic aberration (RGB shift) ---
    r, g, b, a = frame.split()
    shift = 1

    r_shifted = Image.new("L", (w, h), 0)
    g_shifted = Image.new("L", (w, h), 0)
    b_shifted = Image.new("L", (w, h), 0)

    for y in range(h):
        for x in range(w):
            rx = max(0, min(w - 1, x - shift))
            bx = max(0, min(w - 1, x + shift))
            gy = max(0, min(h - 1, y))
            gx = x
            r_shifted.putpixel((x, y), r.getpixel((rx, gy)))
            g_shifted.putpixel((x, y), g.getpixel((gx, gy)))
            b_shifted.putpixel((x, y), b.getpixel((bx, gy)))

    rgb = Image.merge("RGB", [r_shifted, g_shifted, b_shifted])

    # --- Subtle blur ---
    rgb = rgb.filter(ImageFilter.GaussianBlur(radius=0.2))

    # --- Scanlines ---
    line_spacing = max(1, h // 100)
    scanlines = Image.new("RGB", (w, h), (0, 0, 0))
    for y in range(0, h, line_spacing):
        for x in range(w):
            pixel = rgb.getpixel((x, y))
            scanlines.putpixel((x, y), (
                int(pixel[0] * 0.95),
                int(pixel[1] * 0.95),
                int(pixel[2] * 0.95),
            ))

    # --- Color grading: minimal desaturation + very subtle cyan tint ---
    enhancer = ImageEnhance.Color(scanlines)
    scanlines = enhancer.enhance(0.97)

    tint = Image.new("RGB", (w, h), (10, 230, 255))
    scanlines = Image.blend(scanlines, tint, 0.015)

    # --- Noise / static ---
    noise = Image.new("RGB", (w, h))
    for y in range(h):
        for x in range(w):
            if random.random() < noise_intensity:
                v = random.randint(0, 255)
                noise.putpixel((x, y), (v, v, v))
            else:
                noise.putpixel((x, y), scanlines.getpixel((x, y)))

    # --- Tracking distortion (horizontal jitter) ---
    offset = random.randint(-1, 1)
    jittered = Image.new("RGB", (w, h))
    for y in range(h):
        for x in range(w):
            src_x = max(0, min(w - 1, x + offset))
            jittered.putpixel((x, y), noise.getpixel((src_x, y)))

    # --- Vignette (very subtle darkening at edges) ---
    vignette = Image.new("RGB", (w, h))
    cx, cy = w / 2, h / 2
    max_dist = math.sqrt(cx ** 2 + cy ** 2)
    for y in range(h):
        for x in range(w):
            dist = math.sqrt((x - cx) ** 2 + (y - cy) ** 2)
            factor = 1.0 - (dist / max_dist) * vignette_strength
            pixel = jittered.getpixel((x, y))
            vignette.putpixel((x, y), (
                int(pixel[0] * factor),
                int(pixel[1] * factor),
                int(pixel[2] * factor),
            ))

    return vignette


def make_spritesheet(
    frames: list[Image.Image],
    columns: int | None = None,
    padding: int = 0,
) -> tuple[Image.Image, int, int]:
    """Place frames into a sprite sheet grid. Returns (sprite_sheet, columns, rows)."""
    if not frames:
        return None, 0, 0

    frame_width, frame_height = frames[0].size
    num_frames = len(frames)
    cols = columns or min(num_frames, 8)
    rows = (num_frames + cols - 1) // cols

    sheet_width = cols * frame_width + (cols - 1) * padding
    sheet_height = rows * frame_height + (rows - 1) * padding

    sprite_sheet = Image.new("RGBA", (sheet_width, sheet_height), (0, 0, 0, 0))

    for i, frame in enumerate(frames):
        col = i % cols
        row = i // cols
        x = col * (frame_width + padding)
        y = row * (frame_height + padding)
        sprite_sheet.paste(frame, (x, y))

    return sprite_sheet, cols, rows


def gif_to_spritesheet(
    input_path: str,
    output_path: str | None = None,
    columns: int | None = None,
    padding: int = 0,
    fps: int = 10,
    vhs: bool = False,
    noise: float = 0.03,
    vignette: float = 0.55,
) -> None:
    """Convert a GIF or video to a sprite sheet."""
    input_file = Path(input_path)
    if not input_file.exists():
        print(f"Error: File not found: {input_path}", file=sys.stderr)
        sys.exit(1)

    if output_path is None:
        suffix = "_vhs_spritesheet.png" if vhs else "_spritesheet.png"
        output_path = input_file.with_name(f"{input_file.stem}{suffix}")
    else:
        output_path = Path(output_path)

    suffix = input_file.suffix.lower()
    is_video = suffix in {".mp4", ".mov", ".avi", ".mkv", ".webm", ".m4v", ".wmv"}

    if is_video:
        print(f"Extracting frames from video: {input_path}")
        with tempfile.TemporaryDirectory() as temp_dir:
            frames = extract_frames_from_video(input_path, temp_dir, fps)
    else:
        print(f"Extracting frames from GIF: {input_path}")
        frames = extract_frames_from_gif(input_path)

    if not frames:
        print("Error: No frames found", file=sys.stderr)
        sys.exit(1)

    print(f"Loaded {len(frames)} frames")

    if vhs:
        print("Applying VHS effect...")
        random.seed(42)  # deterministic noise per run
        frames = [apply_vhs_effect(f, noise, vignette) for f in frames]

    sprite_sheet, cols, rows = make_spritesheet(frames, columns, padding)
    sprite_sheet.save(output_path)

    frame_width, frame_height = frames[0].size
    mode = "VHS" if vhs else "clean"
    print(f"[{mode}] Sprite sheet saved to: {output_path}")
    print(f"Grid: {cols} columns x {rows} rows, frame size: {frame_width}x{frame_height}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Convert a GIF or video animation into a sprite sheet.")
    parser.add_argument("input", help="Path to the input file (GIF, MP4, MOV, AVI, etc.)")
    parser.add_argument("-o", "--output", help="Path to the output sprite sheet (default: input_spritesheet.png)")
    parser.add_argument("-c", "--columns", type=int, help="Number of columns in the sprite sheet")
    parser.add_argument("-p", "--padding", type=int, default=0, help="Padding between frames in pixels")
    parser.add_argument("--fps", type=int, default=10, help="FPS for video extraction (default: 10)")
    parser.add_argument("--vhs", action="store_true", help="Apply VHS camera effect")
    parser.add_argument("--noise", type=float, default=0.03, help="Noise intensity for VHS (default: 0.03)")
    parser.add_argument("--vignette", type=float, default=0.55, help="Vignette strength for VHS (default: 0.55)")

    args = parser.parse_args()
    gif_to_spritesheet(args.input, args.output, args.columns, args.padding, args.fps, args.vhs, args.noise, args.vignette)


if __name__ == "__main__":
    main()
