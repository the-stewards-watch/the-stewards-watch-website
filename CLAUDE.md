# CLAUDE.md — The Steward's Watch Website

## Project Overview

Business website for **The Steward's Watch**, a local home-sitting service run by Matthew Bestard. Small, simple site — don't over-engineer.

## Tech Stack

- **Backend:** Common Lisp (SBCL), Woo web server, Djula templates
- **Frontend:** Plain HTML/CSS/JS — no frameworks
- **Contact form:** Resend API
- **Deployment:** Docker / docker-compose, reverse proxy (Caddy/Traefik) for SSL

## Directory Structure

```
src/            Common Lisp source
  routes.lisp     URL routing
  views.lisp      HTML generation helpers
templates/      Djula HTML templates (layout + pages)
static/         CSS, JS, images
  style.css       All styles
  effects.js      Parallax, fade-in animations, UI effects
```

## Git Workflow (Git Flow)

This project uses **git flow** strictly:

### Branches

| Branch | Purpose |
|--------|---------|
| `main` | Production releases only — never commit directly |
| `develop` | Integration branch — all features merge here first |
| `feature/*` | New features — branch from `develop`, PR back to `develop` |
| `release/*` | Release prep — branch from `develop`, merge to `main` and `develop` |
| `hotfix/*` | Urgent production fixes — branch from `main`, merge to `main` and `develop` |

### Rules

- **Never push directly to `main` or `develop`**
- All changes go through feature branches and PRs
- Feature branches: `feature/<short-description>` (e.g., `feature/mobile-nav-fix`)
- Claude Code sessions: use `feature/` branches, not `claude/*`
- PRs require review before merging to `develop`
- Only `release/*` and `hotfix/*` branches merge to `main`

## Coding Conventions

- Keep HTML in `templates/`, CSS in `static/style.css`, JS in `static/effects.js`
- Responsive design, mobile-first
- No frontend frameworks — plain HTML/CSS/JS only
- Don't over-engineer; this is a small business site
- Avoid unnecessary abstractions or premature optimization

## Running Locally

```bash
cp .env.example .env   # fill in Resend API key and email addresses
export $(grep -v '^#' .env | xargs)
```

Then in SBCL:

```lisp
(ql:quickload :the-steward-website)
(the-steward-website:start-app :debug t)
```

App listens on `http://localhost:8080`.

## Environment Variables

| Variable         | Description                                |
|------------------|--------------------------------------------|
| `RESEND_API_KEY` | Resend API key                             |
| `CONTACT_FROM`   | Verified sender address in Resend          |
| `CONTACT_TO`     | Inbox for contact form submissions         |
| `HOST`           | Bind address (default `0.0.0.0`)           |
| `PORT`           | Listen port (default `8080`)               |
