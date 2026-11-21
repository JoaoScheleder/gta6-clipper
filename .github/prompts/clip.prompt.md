---
description: Clip a finished GTA 6 stream (YouTube, Twitch, or Kick URL) into 3 vertical 1080x1920 shorts with facecam, hook title, and captions.
agent: agent
---

Clip the provided stream link(s) using the GTA 6 Clipper workflow in [SKILL.md](../../skills/gta6-clipper/SKILL.md) and [picking.md](../../skills/gta6-clipper/references/picking.md):

1. Verify `skills/gta6-clipper/.ready` exists (if not, run `skills/gta6-clipper/scripts/setup.ps1` first).
2. Run `prep` on the stream URL(s) using `skills/gta6-clipper/.venv/Scripts/python.exe skills/gta6-clipper/scripts/gta6clip.py prep <url>`. If it fails due to age restriction or Kick auth, retry with `--cookies firefox`.
3. Read [picking.md](../../skills/gta6-clipper/references/picking.md). Read every `chunks/chunk_NN.md` in the generated run folder one at a time and write `picks/chunk_NN.json` for each chunk.
4. Run `render <run>` to produce the vertical 1080x1920 `.mp4` clips and `.txt` captions.
5. Open `<run>\clips` with `explorer.exe` and report the results.
