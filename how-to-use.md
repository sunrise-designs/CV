# How to use

[`readme.md`](readme.md) is the CV. [`render/build-cv.sh`](render/build-cv.sh)
turns it into a PDF:

The source is never modified — it is copied into `render/.build/` first.

## Install the tools

Two binaries, ~60 MB total. No TeX distribution needed.

**Windows**

```powershell
winget install --id JohnMacFarlane.Pandoc -e
winget install --id Typst.Typst -e
```

Then open a **new** terminal, so it picks up the updated `PATH`.

**Linux (Debian/Ubuntu)**

Distro packages are usually too old — pandoc must be ≥ 3.0 for the typst
writer. Grab the releases directly, as
[the workflow](.github/workflows/build-cv.yml) does:

```bash
curl -fsSLo /tmp/pandoc.deb https://github.com/jgm/pandoc/releases/download/3.10/pandoc-3.10-1-amd64.deb
sudo dpkg -i /tmp/pandoc.deb

curl -fsSL https://github.com/typst/typst/releases/download/v0.15.1/typst-x86_64-unknown-linux-musl.tar.xz | tar -xJ -C /tmp
sudo install /tmp/typst-x86_64-unknown-linux-musl/typst /usr/local/bin/typst
```

## Build it

```bash
./render/build-cv.sh
```

Output lands in `render/out/` as `Dmitry Ignatyev CV YYYY-MM-DD.pdf` — the name
comes from the CV's own first heading, the date from the build. Pass a path to
override: `./render/build-cv.sh /tmp/draft.pdf`.

The script can be run from any working directory.

### On Windows, run it from Git Bash

Bare `bash build-cv.sh` from PowerShell or cmd will *not* work — `bash` there
resolves to the WSL stub (or, inside VS Code, to a bundled build that isn't
really bash). Either open Git Bash from the Start menu:

```bash
cd /c/Repos/CV
./render/build-cv.sh
```

or call it explicitly from PowerShell:

```powershell
& 'C:\Program Files\Git\bin\bash.exe' render/build-cv.sh
```

macOS is not supported as-is: the script uses GNU `sed -i`, which BSD `sed`
spells differently.

## In CI

[`.github/workflows/build-cv.yml`](.github/workflows/build-cv.yml) runs the
same script on every push to `main`, on PRs, and on demand via the Actions tab.
The PDF is uploaded as a build artifact named after the file. Both tool
versions are pinned there so CI renders exactly what you get locally.

### Releases

Pushes to `main` also refresh a release tagged `latest`, whose asset has the
date stripped off so the link is stable — this is the URL to hand out:

<https://github.com/sunrise-designs/CV/releases/download/latest/Dmitry-Ignatyev-CV.pdf>

Use that tag-explicit form rather than `/releases/latest/download/...`: the
latter resolves to whatever GitHub *considers* newest, which is a versioned
release, not this one.

Pushing a `v*` tag additionally cuts a permanent release, keeping the dated
filename and generating notes from the commits since the previous tag:

```bash
git tag v2026.08
git push origin v2026.08
```

The rolling release is a prerelease, so the versioned ones keep the "Latest
release" badge. Until the first `v*` tag exists, `/releases/latest` therefore
404s — only the link above works. Its tag is deleted and recreated on each
push, because GitHub pins an existing tag to the commit that first created it.

## Editing

- **Content** — edit `readme.md`. Ordinary markdown; `[text](url)` links work
  in both GitHub's view and the PDF.
- **`A | B | C` rows** — the `|` separators become horizontal spacing: the
  first is elastic, so `A` stays left and the rest are pushed right together.
  Avoid a literal ` | ` inside link text.
- **Styling** — `render/header.typ` (fonts, headings, colours, spacing) and
  `render/meta.yaml` (paper size, margins, base font size).
- **Debugging** — the generated typst source is left in `render/.build/cv.typ`.
