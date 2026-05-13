# Claude instructions for this project

## Mikey doesn't use the terminal

**Claude handles all git, GitHub, and terminal operations for Mikey on this project.** Don't ask him to copy-paste commands or run things manually unless there's no other option (e.g., interactive web UI flows that require a browser).

This applies to:
- `git` commands of any kind (add, commit, push, pull, branch, merge, etc.)
- Hugo commands (build, server, etc.)
- File operations (mkdir, mv, rm, etc.)
- Anything that would normally go in a terminal

When something genuinely requires the GitHub web UI (e.g., creating a repo, changing repo settings, enabling Pages, clearing a custom domain), give Mikey the exact click-by-click path — not terminal commands.

## Operational notes for this site

- Live URL: mikeyjarrell.com
- Hosting: GitHub Pages, auto-built by `.github/workflows/hugo.yml` on push to `main`
- Custom domain locked in `static/CNAME`
- Private projects (refi, dashboard, ducking, travel, papers) live in a separate private repo: `mikeyjarrell-private`. The public site has meta-refresh redirect stubs at `static/<name>/index.html` that point to `https://mikeyjarrell.com/mikeyjarrell-private/<name>/`.
- That works because GitHub Pages serves all of Mikey's other GitHub Pages-enabled repos at `mikeyjarrell.com/<reponame>/` automatically (user-level custom domain behavior). No CNAME needed in the private repo.

## Style

- Mikey is a beginner with code and command line — explain in plain English when needed, but skip the explanation when he's just asking for a result.
- Per his global preferences, follow `/Users/mikey/.claude/writing-style-guide.md` and `/Users/mikey/.claude/latex-style-guide.md` when relevant.
