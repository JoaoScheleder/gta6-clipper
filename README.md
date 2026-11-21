# GTA 6 Clipper — GitHub Copilot & Windows Edition

Two AI skills for **GitHub Copilot** (VS Code Copilot Chat & GitHub Copilot CLI) that turn GTA 6 streams into ready-to-post vertical clips on **Windows 10/11 (64-bit)**.

- **gta6-clipper** clips a stream that has finished. Give it a YouTube, Twitch or Kick link, or nothing and it finds today's biggest GTA 6 streams.
- **gta6-live-clipper** clips a stream while it's still live. A clip is ready about 5 to 8 minutes after the moment happens.

Every clip comes out **1080x1920**: facecam on top, gameplay below, a hook title, word-by-word captions, and a post caption with hashtags.

## Install & Setup on Windows

### Option A: Open in VS Code with GitHub Copilot (Easiest)

1. Open this repository folder in **VS Code**.
2. Open **GitHub Copilot Chat** (Agent mode) and type:
   - `/setup` or **"set up the GTA 6 clipper"**
3. Wait for **READY** (first run takes 5–10 minutes as it downloads ~800 MB: FFmpeg, Deno, uv, Python 3.12 venv, `faster-whisper` + `small.en` model, OpenCV, and YuNet face detector — no admin rights needed).

### Option B: One-Command PowerShell Install (Global Copilot Skills)

Open **PowerShell** in this repository and run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

This copies `gta6-clipper` and `gta6-live-clipper` into `%USERPROFILE%\.copilot\skills\` (for GitHub Copilot CLI/SDK across any workspace) as well as `%USERPROFILE%\.claude\skills\`, and runs `setup.ps1`.

### Option C: Paste this into GitHub Copilot

```text
Set up the GTA 6 Clipper for Windows in this repository.
Copy skills/gta6-clipper and skills/gta6-live-clipper into %USERPROFILE%\.copilot\skills\
and run: powershell -NoProfile -ExecutionPolicy Bypass -File "skills/gta6-clipper/scripts/setup.ps1"
(use a 10 minute timeout, the first run downloads about 800 MB).
Tell me what it installed and whether it says READY.
```

## Use it in GitHub Copilot

In **VS Code Copilot Chat** or **GitHub Copilot CLI**, use either natural language, slash prompt commands, or custom agents:

- **Natural Language**:
  - **clip this stream** `<link>`
  - **find me today's biggest GTA 6 streams and clip them**
  - **live clip** `<link>` (for a stream that's live right now)
- **Slash Commands (VS Code Copilot Chat)**:
  - `/setup` — Set up tools, Python venv, and Whisper/YuNet models
  - `/clip <link>` — Clip a finished YouTube, Twitch, or Kick stream
  - `/discover-and-clip` — Find today's biggest GTA 6 streams and clip them
  - `/live-clip <link>` — Clip a live stream in real time
- **Custom Agents**:
  - `@gta6-clipper` — Dedicated VOD clipping agent
  - `@gta6-live-clipper` — Dedicated live stream clipping agent

Clips land in `GTA6-Clips` in your user folder (`C:\Users\<you>\GTA6-Clips`). Each one has an `.mp4` and a `.txt` with the title, caption and hashtags.

## How it works

| Step | Finished stream | Live stream | Tools |
|---|---|---|---|
| 1. Get the stream | Downloads the audio only (4 h ≈ 220 MB) | Records 1-minute pieces, keeps the last 15 min | yt-dlp, FFmpeg |
| 2. Speech to text | Whole stream in one go | Each minute as it lands | FFmpeg, faster-whisper |
| 3. Find the hype | Loud seconds + YouTube replay chat speed | Loud seconds + live Twitch chat speed | FFmpeg, chat |
| 4. Pick the moments | Copilot reads 12-min chunks, best 3 scoring 7+ | Copilot reads each 5-min window, any 7.5+ | GitHub Copilot |
| 5. Make the clip | Downloads only those minutes | Cuts from the pieces already on your PC | OpenCV, faster-whisper, Pillow, FFmpeg |

Chat is counted, never read: 10-second buckets, a spike is 8+ messages at 2.5x the normal rate. Loud means 9 dB above the streamer's own normal. The facecam is found by looking for a face, and box edges, that stay still while the gameplay moves.

## Windows & Copilot Architecture

- **Speech-to-Text (`faster-whisper`)**: Replaces macOS-only `whisper-cpp` with `faster-whisper` (CTranslate2 `int8` on CPU by default; optional NVIDIA GPU acceleration via `GTA6_WHISPER_DEVICE=cuda GTA6_WHISPER_COMPUTE=float16`).
- **Windows Process & File Management**:
  - Uses Windows kernel `OpenProcess` / `GetExitCodeProcess` to check live recorder PIDs safely (`os.kill(pid, 0)` on Windows sends Ctrl+C).
  - Uses `taskkill /PID <pid> /T /F` and a graceful `stop` sentinel file so FFmpeg flushes the final `.ts` segment cleanly.
  - Uses `CREATE_NO_WINDOW` so background `ffmpeg` / `yt-dlp` subprocesses never pop up console windows.
  - Forces UTF-8 I/O (`PYTHONUTF8=1`) so emoji-heavy stream titles work on Windows without encoding errors.
- **GitHub Copilot Integration**:
  - `.github/copilot-instructions.md` — Automatic workspace instructions for Copilot.
  - `.github/prompts/*.prompt.md` — Slash commands (`/setup`, `/clip`, `/discover-and-clip`, `/live-clip`).
  - `.github/agents/*.agent.md` — Custom Copilot agents (`@gta6-clipper`, `@gta6-live-clipper`).
  - `skills/*/SKILL.md` — Agent Skills compatible with `.vscode/settings.json` (`chat.agentSkillsLocations`) and `%USERPROFILE%\.copilot\skills`.

## Good to know

- Age-restricted YouTube streams and Kick need your browser login. Tell Copilot to use `--cookies firefox`. Chrome and Edge lock their cookies on Windows while open, so use Firefox or an exported `cookies.txt`.
- YouTube streams that are still live can be clipped by the finished-stream skill once the replay is up. Twitch past broadcasts work while the stream is still going.
- Twitch in "find me streams" is optional: create a free app at [dev.twitch.tv/console](https://dev.twitch.tv/console) and put `TWITCH_CLIENT_ID` and `TWITCH_CLIENT_SECRET` in `skills\gta6-clipper\.env` (see `.env.example`).
- Live clipping needs the Copilot session to stay open, and run at most 2 streams at once on a 16 GB PC.
- Clip streamers who are fine with clipping, and watch every clip before you post it.

## Credits & License

Originally created by [Ashton Voss AI](https://www.youtube.com/@ashtonvossai), adapted for Windows and GitHub Copilot.
MIT licensed.
