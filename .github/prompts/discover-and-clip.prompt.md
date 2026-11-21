---
description: Find today's biggest GTA 6 streams on YouTube and Twitch and clip the best moments into vertical shorts.
agent: agent
---

Discover today's biggest GTA 6 streams and clip them following [SKILL.md](../../skills/gta6-clipper/SKILL.md) and [picking.md](../../skills/gta6-clipper/references/picking.md):

1. Verify `skills/gta6-clipper/.ready` exists (if not, run `skills/gta6-clipper/scripts/setup.ps1` first).
2. Run `skills/gta6-clipper/.venv/Scripts/python.exe skills/gta6-clipper/scripts/gta6clip.py discover`.
3. Show the discovered streams to the user, then run `prep` on the clippable URLs.
4. Read [picking.md](../../skills/gta6-clipper/references/picking.md), evaluate all `chunks/chunk_NN.md` files for each run folder, and write `picks/chunk_NN.json`.
5. Run `render <run>` for each stream and report the generated clips.
