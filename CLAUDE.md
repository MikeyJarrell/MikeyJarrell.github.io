# Claude instructions for this project

## Operating principles

**Claude handles all git, GitHub, and terminal operations for Mikey on this project.** Don't ask him to copy-paste commands or run anything in a terminal unless there's literally no other option (e.g., interactive web UI flows that require a browser logged into github.com).

This applies to: `git` (add, commit, push, pull, branch, force-push, anything), Hugo (`hugo server`, `hugo` build), file operations (`mkdir`, `mv`, `rm`), and anything else CLI-shaped. When something genuinely requires the GitHub web UI (creating a repo, enabling Pages, clearing a custom domain), give Mikey the exact click-by-click path, not terminal commands.

**Mikey is a beginner with code and CLI.** Explain in plain English when introducing something new, but skip the explanation when he's just asking for a result. Prefer doing over teaching.

## Repo identity

- **Live URL:** mikeyjarrell.com
- **Repo name on GitHub:** `MikeyJarrell/MikeyJarrell.github.io` (this IS the user-level GitHub Pages repo — note that despite the local folder being called `Website`, the remote is `*.github.io`).
- **Hosting:** GitHub Pages, auto-built by `.github/workflows/hugo.yml` on push to `main`. Hugo version pinned in the workflow file.
- **Custom domain:** `mikeyjarrell.com`, locked in `static/CNAME` (committed) and confirmed in repo Settings → Pages.

## Private projects (refi, dashboard, ducking, travel, papers)

These live in a **separate private repo: `MikeyJarrell/mikeyjarrell-private`** (cloned at `~/Documents/GitHub/mikeyjarrell-private`). It has its own GitHub Pages enabled (deploy from `main`, root). Its content is publicly *accessible by URL* but not visible in the public repo source.

### How the redirect works

1. Visitor goes to `mikeyjarrell.com/refi` (or `/dashboard`, `/ducking`, `/travel`, `/papers`).
2. The public Website doesn't have that path → GitHub serves Hugo's 404 page.
3. The 404 page is **`layouts/404.html`** in this repo — it contains JS that detects whether the requested path is one of the "passthroughs" and, if so, `location.replace`s to `/mikeyjarrell-private/<path>/`.
4. `mikeyjarrell.com/mikeyjarrell-private/<path>/` is served by the **private repo's** GitHub Pages, surfaced under the user-level domain.

### Why `mikeyjarrell.com/mikeyjarrell-private/...` works without any extra setup

When a user has a custom domain on a user-level GitHub Pages repo (`<username>.github.io`), **GitHub automatically routes `customdomain.com/<other-reponame>/` to that other repo's Pages site**. No CNAME needed in the private repo — in fact, **the private repo's "Custom domain" field in Settings → Pages should be left BLANK**. Setting it explicitly there will cause weird redirect loops.

### Caveat

The 404-redirect approach means the HTTP status for `mikeyjarrell.com/refi` is technically **404** before the JS fires. Invisible to users (the redirect is instant) but it shows up in SEO crawls / analytics. Doesn't matter for unlinked private content.

### Adding a new private project

1. Create the folder under `~/Documents/GitHub/mikeyjarrell-private/<new-name>/`, populate with `index.html` and other static files.
2. Commit and push the private repo.
3. In **this** repo, edit the `passthroughs` array in [layouts/404.html](layouts/404.html) to add `"<new-name>"`.
4. Commit and push.
5. `mikeyjarrell.com/<new-name>` will now work.

### Travel wishlist sub-project

The travel wishlist at `mikeyjarrell.com/travel` is hand-built static HTML (no Hugo) living in `~/Documents/GitHub/mikeyjarrell-private/travel/`. **Before adding or modifying a destination, read `~/Documents/GitHub/mikeyjarrell-private/travel/CLAUDE.md`** — it documents the page structure, the per-destination YAML format, the Pexels photo fetcher (`_scripts/fetch_photos.py`), and the alphabetical card-insertion convention on the index. Don't reverse-engineer the format from existing pages each time; the recipe is written down.

## Repo conventions

- **Don't edit `themes/academimal/`** directly. Override via files in `layouts/` at the repo root — Hugo's lookup prefers root over theme.
- **Don't commit `public/` or `resources/`** — gitignored. GitHub Actions rebuilds `public/` fresh on every push.
- **Don't put private content in `static/`** — the whole point is keeping it out of the public repo. Put it in `~/Documents/GitHub/mikeyjarrell-private/`.
- **Hugo data files**: `data/<category>/list.yaml`. Categories: `publications`, `working_papers`, `work_in_progress`, `in_progress`, `merely_ideas`. The "in_progress" and "work_in_progress" YAMLs both reference the "Who's in Charge" paper — keep them in sync.

## Commit message hygiene

Mikey's CV-page-style audience can see public commit messages. Don't mention:
- The private repo by name
- "Private folders moved to..."
- Specific file moves that imply hidden content

Prefer generic messages like "Site refresh", "Content update", "Style cleanup". The diff itself reveals what changed, but the *summary line* doesn't need to advertise sensitive splits.

If a commit message slips through, **squash + force-push** to clean it up — `git reset --soft HEAD~N` then re-commit, then `git push --force-with-lease`. This is OK because Mikey is the only one pushing.

## Favicon

- `static/favicon.svg`, `static/favicon.png` (180×180 for Apple touch icon), `static/favicon.ico` (multi-size: 16, 32, 48 — for legacy browsers).
- Design: **"MJ" in Helvetica Bold, light gray `#f0f0f0` on dark gray `#393939`**, rounded square (rx=10) on a 64-unit viewBox. Helvetica is deliberately NOT the site body font (Noto Sans) — this was a conscious choice because Helvetica's J has a flatter, cleaner descender at favicon size.
- **Don't use Noto Sans in the favicon SVG** — it's a web font, not a system font; viewers without it fall back to weird metrics, and embedding the TTF as base64 bloats the file to 40 KB.
- Theme override for the `<link rel="icon">` tags lives at [layouts/partials/header.html](layouts/partials/header.html).
- To regenerate: use Pillow + the system Helvetica.ttc (Bold face is usually index 1). Render at proportional SVG positions (anchor middle-baseline). Verify against `qlmanage -t -s 512 -o /tmp out.svg` to make sure SVG and PNG render the same way.

## Reproducing the favicon rendering pipeline

When tweaking favicon (different letters, colors, etc.):

1. Update the SVG at `static/favicon.svg` — keep it as a small (~300 byte) file using a system font stack like `Helvetica, Arial, sans-serif`. No embedded fonts.
2. Render PNG/ICO via a one-off `uv run` script using Pillow that:
   - Reads the SVG's text position parameters
   - Loads matching font from `/System/Library/Fonts/Helvetica.ttc` (index 1 for Bold)
   - Calls `d.text((x*scale, y*scale), "MJ", anchor="ms")` to mirror SVG semantics
3. Sanity check: rasterize the SVG via `qlmanage -t -s 512 -o /tmp/ql-out static/favicon.svg` and compare to the Pillow PNG. They should match.

## External resources Mikey uses

- `/Users/mikey/.claude/CLAUDE.md` — global Claude context (his role, projects, tools, style)
- `/Users/mikey/.claude/writing-style-guide.md` — writing style for all prose he writes
- `/Users/mikey/.claude/latex-style-guide.md` — for LaTeX

## When something goes wrong

- **`mikeyjarrell.com/refi` returns plain "Page not found"** instead of redirecting → the `passthroughs` array in `layouts/404.html` doesn't include `refi`, or the build hasn't redeployed yet (wait 60s for GitHub Actions).
- **`mikeyjarrell.com/mikeyjarrell-private/refi/` 404s** → check the private repo on github.com: is GitHub Pages enabled? Is the source set to `main` branch root? Has it built (check Actions tab)?
- **`mikeyjarrell.github.io/mikeyjarrell-private/refi/` 301s to `mikeyjarrell.com/...`** → that's normal and expected. GitHub redirects github.io URLs to the custom domain. Working as intended.
- **Custom domain not resolving** → check `static/CNAME` matches `mikeyjarrell.com` AND the repo Settings → Pages has it set.
- **Theme appears to revert favicon to UCSD** → the override at `layouts/partials/header.html` got lost or has the wrong path; Hugo falls back to the theme's `themes/academimal/layouts/partials/header.html` which still references `/ucsd_favicon.ico`.
