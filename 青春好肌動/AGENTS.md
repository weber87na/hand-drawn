# Repository Guidelines

## Project Structure & Module Organization

This repository is a static single-page site for `青春好肌動`.

- `index.html` contains the page structure, responsive image sources, navigation hit areas, and section IDs.
- `css/style.css` contains all layout, responsive behavior, and visual styling.
- `js/main.js` controls section switching and URL hash updates.
- `img/` contains production-ready desktop and mobile images referenced by the site.
- `素材/` stores source/reference materials such as presentation files and original brand or social assets. Do not link directly to these files from `index.html` unless they are intentionally prepared for web use.
- `.vscode/` contains editor-local settings.

## Build, Test, and Development Commands

There is no build pipeline or package manager configured. The site can be viewed directly by opening `index.html` in a browser.

Useful local checks:

```powershell
Get-ChildItem
rg --files
```

Use `Get-ChildItem` to inspect the root layout and `rg --files` to verify asset paths before committing changes.

## Coding Style & Naming Conventions

Use 2-space indentation in HTML, CSS, and JavaScript. Keep markup semantic and preserve accessibility attributes such as `alt` and `aria-label`.

CSS class names use lowercase kebab-case, for example `title-frame`, `nav-hit`, and `nav-philosophy`. JavaScript uses `const` by default, camelCase function names such as `showPanel`, and small DOM-focused functions.

When adding new sections, keep IDs, `data-target` values, CSS class names, image filenames, and hash behavior aligned.

## Testing Guidelines

No automated tests are currently configured. Validate changes manually in a browser:

- Confirm each navigation button displays the expected panel.
- Confirm URL hashes update correctly, for example `#pricing`.
- Check both desktop and mobile layouts, especially the `720px` breakpoint.
- Verify all images load and keep meaningful `alt` text.

## Commit & Pull Request Guidelines

This directory does not currently include Git history, so use clear, conventional commit messages going forward, such as:

```text
Update mobile pricing image
Adjust navigation hit areas
Add ingredients section
```

Pull requests should include a short description, affected files, manual test notes, and screenshots when changing layout, images, or responsive behavior. Link related issues or design notes when available.

## Asset & Configuration Tips

Optimize new web images before placing them in `img/`. Keep large editable source files in `素材/`. Avoid committing machine-specific editor settings unless they improve shared development.
