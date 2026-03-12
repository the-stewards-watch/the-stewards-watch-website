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

## Git Workflow

- **main** — production-ready releases only
- **develop** — integration branch; all feature work merges here first
- Feature branches off `develop`, PRs target `develop`
- Claude Code sessions use `claude/*` branches — branch from and PR back into `develop`
- Never push directly to `main`

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
