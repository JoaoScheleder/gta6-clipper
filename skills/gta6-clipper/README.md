# GTA 6 Clipper (GitHub Copilot skill - Windows Edition)

An AI skill for GitHub Copilot (VS Code & Copilot CLI) that clips GTA 6 streams for you on Windows. Give it a stream link from YouTube, Twitch or Kick (or nothing,
and it finds today's biggest GTA 6 streams) and you get ready-to-post vertical clips: facecam on top,
gameplay below, a hook title, word-by-word captions, and a post caption with hashtags.

## What it does, in 4 steps

1. **Downloads only the audio.** A 4-hour stream is a couple hundred MB, not a giant video file.
2. **Listens to the whole stream on your PC:** a transcript via `faster-whisper`, where the streamer got loud, and (on YouTube
   replays) where chat suddenly sped up.
3. **GitHub Copilot reads the transcript 12 minutes at a time** and picks what people share: first reactions,
   crazy discoveries, freakouts, funny fails, hot takes. Every moment gets a score, and anything that
   needs context gets thrown out.
4. **Downloads only the minutes it needs,** finds the facecam by itself and makes the clips, plus a
   caption and hashtags for each one.

3 clips per stream by default. Several streams run at once.

## How to use with GitHub Copilot

1. Open this repository in **VS Code** (with GitHub Copilot Chat) or **GitHub Copilot CLI**, or run `install.ps1` to install the skills globally into `%USERPROFILE%\.copilot\skills\`.
2. Ask Copilot: **set up the GTA 6 clipper** (or run `/setup`). It checks what your Windows PC needs, installs what's
   missing and tells you when it's ready.
3. Say: **clip this stream** and paste the link (or `/clip <link>`). Or: **find me today's biggest GTA 6 streams and clip them** (`/discover-and-clip`).

## Good to know

- Designed for Windows 10/11 (64-bit) with `faster-whisper` (CPU `int8` by default, optional CUDA via `GTA6_WHISPER_DEVICE=cuda`).
- Age-restricted YouTube streams (common with GTA) and Kick need your browser login: tell Copilot to use
  `--cookies firefox` (or a `cookies.txt` file path).
- YouTube streams that are still live can be clipped once the replay is up. Twitch archives work while live.
- Twitch in "find me streams" is optional: create a free app at dev.twitch.tv/console and put
  `TWITCH_CLIENT_ID=` and `TWITCH_CLIENT_SECRET=` in `skills/gta6-clipper/.env`. Without it, discovery uses YouTube
  and you can still paste any Twitch link.
- Clip streamers who are fine with clipping, and watch every clip before you post it.
- YouTube ad money needs the Partner Program, and YouTube can refuse it for reposted, mass-made content.
  Add something of your own.

## Files

```
SKILL.md                 instructions GitHub Copilot follows
references/picking.md    how the AI picks and scores moments
scripts/setup.ps1        installs everything on Windows (ffmpeg, deno, uv, yt-dlp, faster-whisper, OpenCV...)
scripts/setup.sh         cross-platform wrapper (delegates to setup.ps1 on Windows)
scripts/gta6clip.py      discover / prep / status / render
~/GTA6-Clips/<run>/      transcript, chunks, picks, clips/ (live runs in ~/GTA6-Clips/live/)
```
