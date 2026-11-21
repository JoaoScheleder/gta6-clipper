#!/usr/bin/env bash
# GTA 6 Clipper setup: cross-platform wrapper (delegates to setup.ps1 on Windows, or sets up via uv/faster-whisper on WSL/Linux/macOS).
set -uo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    WIN_SCRIPT="$(cygpath -w "$SKILL_DIR/scripts/setup.ps1" 2>/dev/null || echo "$SKILL_DIR/scripts/setup.ps1")"
    exec powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$WIN_SCRIPT"
    ;;
esac

VENV="$SKILL_DIR/.venv"
MODELS="$SKILL_DIR/models"
WHISPER_DIR="$MODELS/whisper"
mkdir -p "$MODELS" "$WHISPER_DIR"
ok()   { printf "  [ok]      %s\n" "$1"; }
inst() { printf "  [install] %s\n" "$1"; }
fail() { printf "  [MISSING] %s\n" "$1"; FAILED=1; }
FAILED=0

echo "GTA 6 Clipper setup (GitHub Copilot Edition)"

# 1. FFmpeg
if command -v ffmpeg >/dev/null 2>&1 && command -v ffprobe >/dev/null 2>&1; then
  ok "ffmpeg"
elif command -v brew >/dev/null 2>&1; then
  inst "ffmpeg"; brew install ffmpeg >/dev/null 2>&1 && ok "ffmpeg" || fail "ffmpeg"
else
  fail "ffmpeg (install ffmpeg via your package manager and re-run)"
fi

# 2. Deno
if command -v deno >/dev/null 2>&1 || [[ -x "$HOME/.deno/bin/deno" ]]; then
  ok "deno"
else
  inst "deno"
  curl -fsSL https://deno.land/install.sh | sh >/dev/null 2>&1 && ok "deno" || fail "deno"
fi
DENO_DIR=""
[[ -x "$HOME/.deno/bin/deno" ]] && DENO_DIR="$HOME/.deno/bin"

# 3. uv (fast Python + venv manager)
if command -v uv >/dev/null 2>&1 || [[ -x "$HOME/.local/bin/uv" ]]; then ok "uv"; else
  inst "uv"; curl -LsSf https://astral.sh/uv/install.sh | sh >/dev/null 2>&1 && ok "uv" || fail "uv"; fi
UV="$(command -v uv || echo "$HOME/.local/bin/uv")"

# 4. Python environment: yt-dlp, faster-whisper, OpenCV, Pillow, numpy
if [[ ! -x "$VENV/bin/python" ]]; then inst "Python 3.12 environment"; "$UV" venv --python 3.12 "$VENV" >/dev/null 2>&1; fi
"$UV" pip install --python "$VENV/bin/python" -q -U "yt-dlp[default]" faster-whisper opencv-python-headless pillow numpy >/dev/null 2>&1 \
  && ok "Python packages (yt-dlp, faster-whisper, opencv, pillow, numpy)" || fail "Python packages"

# 5. Whisper model (faster-whisper small.en)
if [[ -x "$VENV/bin/python" ]]; then
  inst "Whisper small.en model (skips if already downloaded)"
  "$VENV/bin/python" -c "from faster_whisper import WhisperModel; WhisperModel('small.en', device='cpu', compute_type='int8', download_root='$WHISPER_DIR')" >/dev/null 2>&1 \
    && ok "Whisper model (small.en)" || fail "Whisper model"
fi

# 6. Face detector model (YuNet, ~230 KB)
YUNET="$MODELS/face_detection_yunet_2023mar.onnx"
if [[ ! -f "$YUNET" ]]; then
  inst "YuNet face detector"
  curl -L -s -o "$YUNET" https://github.com/opencv/opencv_zoo/raw/main/models/face_detection_yunet/face_detection_yunet_2023mar.onnx || fail "YuNet model"
fi
[[ -s "$YUNET" ]] && ok "Face detector" || fail "Face detector"

cat > "$SKILL_DIR/config.json" <<EOF
{"whisper_model": "small.en", "whisper_dir": "$WHISPER_DIR", "yunet_model": "$YUNET", "path_dirs": ["$DENO_DIR"]}
EOF

if [[ $FAILED -eq 0 ]]; then
  date > "$SKILL_DIR/.ready"
  echo; echo "READY. In GitHub Copilot, say: clip this stream <link>   or   find me today's biggest GTA 6 streams and clip them"
else
  rm -f "$SKILL_DIR/.ready"; echo; echo "NOT READY: fix the [MISSING] items above and re-run setup."; exit 1
fi
