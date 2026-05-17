# Repository Guidelines

## Project Structure & Module Organization

This repository is a static one-page website for a hand-drawn car repair landing page. The main entry point is `index.html`, which contains the HTML, CSS, and small panel-switching JavaScript. Original desktop artwork lives in `title.jpg`, `img1.jpg`, `img2.jpg`, `img13.jpg`, and `img14.jpg`. Mobile-specific artwork uses `mobile-title.jpg` and `mobile-img*.png`. Planning notes for mobile artwork are in `mobile-content-plan.md` and `mobile-image-prompts.md`. `make-mobile-images.ps1` is a helper script for regenerating earlier mobile image assets.

## Build, Test, and Development Commands

No build system is required. Open `index.html` directly in a browser to run the site locally.

Useful checks:

```powershell
Select-String -LiteralPath .\index.html -Pattern 'srcset=|src='
Get-ChildItem .\mobile-img*.png
```

Use the first command to verify image references and the second to confirm mobile assets exist. If regenerating scripted mobile images, run:

```powershell
.\make-mobile-images.ps1
```

## Coding Style & Naming Conventions

Keep this project dependency-free: plain HTML, CSS, and vanilla JavaScript only. Use two-space indentation in `index.html`. Prefer descriptive class names such as `nav-hit`, `panel`, and `promo-link`. Name desktop assets with the existing `img*.jpg` pattern and mobile assets with `mobile-*.png` or `mobile-*.jpg`.

## Testing Guidelines

There is no automated test suite. Manually test in desktop and mobile viewport widths. Verify that clicking the hand-drawn title navigation switches between panels, that `#img1` through `#img4` load correctly, and that mobile view uses the `mobile-*` assets. Check that external links still point to the intended pages.

## Commit & Pull Request Guidelines

This folder is not currently a Git repository, so no project history conventions exist. If Git is introduced, use short imperative commit messages, for example `Update mobile artwork` or Conventional Commits such as `fix: correct mobile image reference`. Pull requests should include a short summary, screenshots for desktop and mobile, and notes on any changed image assets.

## Agent-Specific Instructions

Do not replace original desktop artwork unless explicitly requested. Keep generated or edited images in the project folder before referencing them from `index.html`. When changing mobile artwork, preserve readable Traditional Chinese text and verify `srcset` paths afterward.
