# Mikey Jarrell's Website

A personal academic website built with [Hugo](https://gohugo.io) (a static site generator) using a modified version of the [academimal](https://github.com/UnamedOrange/academimal) theme. It's deployed to [mikeyjarrell.com](https://mikeyjarrell.com) via GitHub Pages.

If you like the look and want to copy it for your own site, you're welcome to. The rest of this README is a beginner-friendly guide that should get you (or a coding assistant like Claude) all the way from "I have no idea what Hugo is" to "my site is live."

---

## Quickstart

```bash
git clone https://github.com/MikeyJarrell/Website.git my-website
cd my-website
brew install hugo                 # macOS — see hugo.io/installation for other systems
hugo server                       # build the site and serve at localhost:1313
# edit files, see changes live, then commit + push to deploy
```

---

## How this site works (for humans and LLMs)

Hugo is a **static site generator**. You write content in Markdown and YAML; Hugo turns it into plain HTML pages. The HTML is served by GitHub Pages — no database, no backend server, just files.

A **theme** is a bundle of HTML templates and CSS that decides how your content is laid out. This site uses `academimal` (in `themes/academimal/`) with a few overrides in the repo root.

### Directory map

| Path | What lives here |
|------|------|
| `config.toml` | Site-wide settings: title, sidebar bio, profile-picture filename |
| `content/sections/*.md` | The text for each home-page section (About Me, Contact, CV, etc.) |
| `content/_index.md` | Front-page intro text |
| `data/publications/list.yaml` | Published papers |
| `data/working_papers/list.yaml` | Working papers |
| `data/work_in_progress/list.yaml` | Work-in-progress papers |
| `data/in_progress/list.yaml` | (Subset used for a specific section — see `content/sections/`) |
| `data/merely_ideas/list.yaml` | Idea-stage work |
| `static/` | Files served as-is: profile picture, CV PDF, favicon, `CNAME` |
| `static/pdf/` | PDFs linked from the publications lists |
| `themes/academimal/` | The theme (HTML templates + CSS). **Don't edit directly.** |
| `layouts/` | Overrides for theme templates — Hugo prefers these over the theme |
| `public/` | Generated HTML output. **Gitignored. Don't edit.** |
| `.github/workflows/hugo.yml` | GitHub Actions config that auto-builds and deploys on every push to `main` |

---

## Setting it up from scratch

1. **Fork or copy this repo.** Click "Use this template" on GitHub, or fork it.

2. **Install Hugo.** On macOS: `brew install hugo`. Other systems: see [Hugo's install docs](https://gohugo.io/installation/). You want the **extended** version (matches what the GitHub Actions workflow uses).

3. **Run it locally.** From the repo root:

   ```bash
   hugo server
   ```

   Open `http://localhost:1313` in a browser. Edits to any file update the page in real time.

4. **Make it yours.**

   - Edit `config.toml` — change `title`, `shortbio`, `logo` (the profile picture's filename).
   - Replace `static/profile.png` with your own profile picture (or update the `logo` filename in `config.toml`).
   - Replace `static/pdf/cv.pdf` with your CV.
   - Edit the section files in `content/sections/*.md` to change the home-page text.
   - Edit YAML files in `data/*/list.yaml` to list your publications, working papers, etc.
   - Generate a new favicon (see "Common tasks" below) and replace the files in `static/`.

5. **Set up your custom domain (optional).** Edit `static/CNAME` to contain your domain (e.g., `yourname.com`). Delete the file if you're just using `username.github.io`.

6. **Push to GitHub.** Commit your changes and push to `main`.

7. **Turn on GitHub Pages.** In your repo's Settings → Pages → Build and deployment → Source: **"GitHub Actions"**. The workflow at `.github/workflows/hugo.yml` will run and deploy the site.

8. **Wait ~1 minute, then visit your site.** It'll be at `https://<your-username>.github.io/<repo-name>/` or your custom domain if you set one up.

---

## Common tasks

### Edit a section's text

Each home-page section is a Markdown file at `content/sections/<name>.md`. Open it, edit the text, save. Hugo reloads automatically while `hugo server` is running.

### Add a new home-page section

Create a new `.md` file in `content/sections/`. Hugo treats every file there as a section, ordered by the `weight:` field in the front matter (the YAML block at the top). Add a `weight: 5` (or whatever number) line in the new file to control where it appears.

### Add a publication, working paper, or work-in-progress

Edit the corresponding YAML file under `data/`. For example, to add a working paper, open `data/working_papers/list.yaml` and add a new entry:

```yaml
- title: "Title of your paper"
  pdflink: "/pdf/your-paper.pdf"
  book:
  coauthors: "Coauthor A and Coauthor B"
  links:
    - url: "https://example.com/link"
      text: "Link label"
  abstract: >
    Abstract goes here. Don't forget the ">" above (it preserves multi-line text).
```

Put the actual PDF in `static/pdf/`. The `pdflink:` path is relative to `static/`.

### Update your CV PDF

Replace `static/pdf/cv.pdf` with your new file (keep the filename the same).

### Change the favicon

The favicon is the little icon in the browser tab. To make a new one:

1. Generate three files in `static/`: `favicon.svg`, `favicon.png` (180×180), and `favicon.ico` (multi-size).
2. Easiest way: copy the Python script that generated the current one (it lives in this README's git history — search for `gen_favicon.py`), edit the colors and letters, and run `uv run gen_favicon.py` (requires [uv](https://docs.astral.sh/uv/)).
3. The `<link rel="icon">` tags live in `layouts/partials/header.html`. Edit them if you want to add/remove favicon formats.

### Develop locally

```bash
hugo server               # serve at localhost:1313, live-reload
hugo server -D            # also show draft posts
hugo                      # one-time build into public/ (don't commit it)
```

---

## Customization tips

### Changing colors

The theme's color palette is in `themes/academimal/static/css/style.css`. Search for the hex code you want to change (e.g., `#393939` for `h2` headings, `#f0f0f0` for light backgrounds).

If you want to override the theme's CSS without editing the theme directly: copy `themes/academimal/static/css/style.css` to `static/css/style.css` at the repo root. Hugo will serve your copy instead.

### Overriding theme templates

Hugo's file lookup prefers `layouts/` at the repo root over `themes/<name>/layouts/`. So to override a theme template:

```bash
# Example: override the page header
mkdir -p layouts/partials
cp themes/academimal/layouts/partials/header.html layouts/partials/header.html
# Now edit layouts/partials/header.html — your version wins.
```

This is how the custom favicon is wired in — see `layouts/partials/header.html`.

---

## For Claude or other LLMs

If you're an AI assistant helping someone set up this site, here's the context you need:

- **Site type:** Hugo static site, extended version, ≥0.120.x.
- **Theme:** `academimal` at `themes/academimal/`. Vendored as plain files (not a git submodule). Don't edit it directly.
- **Theme overrides:** Place files at `layouts/<same path as theme>` in the repo root. Hugo prefers these. The favicon override is the existing example.
- **Editable content:**
  - Section text → `content/sections/*.md` (Markdown front matter + body).
  - Publication-style lists → `data/<category>/list.yaml` (YAML, fields: `title`, `pdflink`, `book`, `coauthors`, `links[]`, `abstract`).
  - Static assets → `static/`.
- **Config:** `config.toml`. `relativeURLs = true` is set. No `baseURL` — the GitHub Actions workflow injects it at build time via `--baseURL`.
- **Custom domain:** `static/CNAME` contains the apex domain. GitHub Pages reads it on deploy.
- **Deploy:** Push to `main` triggers `.github/workflows/hugo.yml`. The workflow installs Hugo, builds the site, and publishes `public/` to GitHub Pages. Don't commit `public/` — it's gitignored.
- **Private content:** Some directories that appear at `mikeyjarrell.com/<name>` (e.g. `/refi`, `/dashboard`) live in a separate **private** repo and are served via meta-refresh redirects from `static/<name>/index.html`. Don't be confused if you see those redirect stubs — they're intentional.

When helping with edits, prefer editing existing files over creating new ones. The repo conventions are simple: Markdown for text, YAML for structured lists, the `static/` directory for everything that should be served as-is.
