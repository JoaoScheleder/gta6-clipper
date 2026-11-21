# GTA 6 Clipper — GitHub Copilot Workspace Instructions (Windows Edition)

You are operating the **GTA 6 Clipper** system on Windows for GitHub Copilot (VS Code & Copilot CLI).
This repository provides two skills that turn GTA 6 streams (YouTube, Twitch, Kick) into ready-to-post 1080x1920 vertical clips (facecam on top, gameplay below, hook title, word-by-word captions, post caption + hashtags):

1. **VOD / Finished Stream Clipper** (`skills/gta6-clipper/SKILL.md`)
   - Script: `skills/gta6-clipper/scripts/gta6clip.py`
   - Setup: `skills/gta6-clipper/scripts/setup.ps1`
   - Picking guide: `skills/gta6-clipper/references/picking.md`
2. **Live Stream Clipper** (`skills/gta6-live-clipper/SKILL.md`)
   - Script: `skills/gta6-live-clipper/scripts/live.py`

## Python Environment & Paths

Let `S` be the `skills/gta6-clipper` directory and `L` be the `skills/gta6-live-clipper` directory.
Always run the scripts using the skill's virtual environment Python:
- **Windows**: `"$S/.venv/Scripts/python.exe"` (or `"$S\.venv\Scripts\python.exe"`)
- **WSL/Linux/macOS fallback**: `"$S/.venv/bin/python"`

If `skills/gta6-clipper/.ready` does not exist or a command outputs `"Not set up yet"`, run setup first:
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "skills/gta6-clipper/scripts/setup.ps1"
```

## Triggers & Workflows

### 1. "Set up the GTA 6 clipper" / `/setup`
Run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "skills/gta6-clipper/scripts/setup.ps1"` (wait up to 10 minutes on first run as it downloads ~800 MB of FFmpeg, Deno, uv, Python packages, and faster-whisper `small.en`). Report what was installed and confirm when it prints `READY`.

### 2. "Clip this stream `<url>`" or "Find me today's biggest GTA 6 streams and clip them" / `/clip` / `/discover-and-clip`
Follow `skills/gta6-clipper/SKILL.md`:
1. **Discover (if no URL given)**: Run `"$S/.venv/Scripts/python.exe" "$S/scripts/gta6clip.py" discover` and pass the discovered URLs to `prep`.
2. **Prep**: Run `"$S/.venv/Scripts/python.exe" "$S/scripts/gta6clip.py" prep <url> [<url> ...]`.
   - If age-restricted or Kick 403, retry with `--cookies firefox` (or a `cookies.txt` path).
3. **Pick Moments (YOU do this in Copilot)**:
   - Read `skills/gta6-clipper/references/picking.md` first.
   - Read every `chunks/chunk_NN.md` in the run folder (`~/GTA6-Clips/<run>/`) in order.
   - Write `picks/chunk_NN.json` for each chunk (use `[]` if no moment scores high enough).
   - Check `"$S/.venv/Scripts/python.exe" "$S/scripts/gta6clip.py" status <run>` until `chunks_left` is empty.
4. **Render**: Run `"$S/.venv/Scripts/python.exe" "$S/scripts/gta6clip.py" render <run>`.
5. **Report**: Summarize stream length, moments found, clips created, and open the output folder with `explorer.exe "<run>\clips"`.

### 3. "Live clip `<url>`" / `/live-clip`
Follow `skills/gta6-live-clipper/SKILL.md`:
1. **Start**: Run `"$S/.venv/Scripts/python.exe" "$L/scripts/live.py" start <url>`.
2. **Loop**:
   - Read `skills/gta6-clipper/references/picking.md` once.
   - Run `"$S/.venv/Scripts/python.exe" "$L/scripts/live.py" next <run>` (blocks up to 9 min until a 5-min window is ready).
   - Write `picks/window_NNN.json` in that run folder (`[]` if nothing qualifies).
   - If any pick has `score >= 7.5`, immediately run `"$S/.venv/Scripts/python.exe" "$L/scripts/live.py" clip <run>` and report the new clip in one line.
   - Repeat until `STREAM ENDED` or the user asks to stop (`stop <run>`).
