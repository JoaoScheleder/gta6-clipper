# Quick Install Prompt: GTA 6 Clipper for Windows (GitHub Copilot)

**1. Open PowerShell in this repository and run:**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

Wait until it says `READY` (first time takes 5 to 10 minutes as it downloads ~800 MB).

**2. Or paste this directly into GitHub Copilot Chat (Agent mode):**

```text
Set up the GTA 6 Clipper for Windows in this repository.
Run: powershell -NoProfile -ExecutionPolicy Bypass -File "skills/gta6-clipper/scripts/setup.ps1"
(use a 10 minute timeout, the first run downloads about 800 MB).
Tell me what it installed and whether it says READY.
```

**3. Then say one of these in GitHub Copilot Chat or Copilot CLI:**

- `clip this stream [paste link]` (or `/clip [paste link]`)
- `find me today's biggest GTA 6 streams and clip them` (or `/discover-and-clip`)
- `live clip [paste link of a stream that's live right now]` (or `/live-clip [paste link]`)

Your clips land in `C:\Users\<you>\GTA6-Clips`, each with a caption and hashtags ready to post.

