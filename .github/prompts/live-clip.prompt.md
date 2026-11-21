---
description: Live-clip a GTA 6 stream while it is broadcasting right now using a rolling local buffer.
agent: agent
---

Live-clip the stream URL(s) following [SKILL.md](../../skills/gta6-live-clipper/SKILL.md) and [picking.md](../../skills/gta6-clipper/references/picking.md):

1. Verify `skills/gta6-clipper/.ready` exists (if not, run `skills/gta6-clipper/scripts/setup.ps1` first).
2. Read [picking.md](../../skills/gta6-clipper/references/picking.md).
3. Start the background live recorder:
   `skills/gta6-clipper/.venv/Scripts/python.exe skills/gta6-live-clipper/scripts/live.py start <url>`
4. Loop until the stream ends or the user says stop:
   - Run `next <run>` (wait up to 10 minutes) to get the next 5-minute transcript window.
   - Score moments and write `picks/window_NNN.json`.
   - If any pick has `score >= 7.5`, immediately run `clip <run>` and report the new clip path + title.
