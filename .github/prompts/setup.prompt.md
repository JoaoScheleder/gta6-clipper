---
description: Set up the GTA 6 Clipper environment on Windows (FFmpeg, Deno, uv, Python venv, faster-whisper, YuNet face detector).
agent: agent
---

Set up the GTA 6 Clipper on this PC by following [SKILL.md](../../skills/gta6-clipper/SKILL.md):

1. Run the Windows setup script:
   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File "skills/gta6-clipper/scripts/setup.ps1"
   ```
   (Use a 10-minute timeout since the first run downloads ~800 MB.)
2. Tell the user in plain words what was installed or verified (`[ok]` / `[install]`) and whether it printed `READY`.
