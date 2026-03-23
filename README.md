# The Steward's Watch

A small business website built with Common Lisp for a local home and pet sitting service in the Hudson Valley, NY.

## Overview

The Steward's Watch is a web application that provides an online presence for a trusted home and pet sitting business. It features service descriptions, testimonials, and a contact form.

Built using Common Lisp with a focus on simplicity, speed, and maintainability.

## Features

- Responsive, mobile-first design
- Service overview with pricing
- Contact form (powered by Resend)
- About and testimonials pages
- Privacy policy

## Local Development

### Requirements

- SBCL
- Quicklisp
- libev (required by the Woo web server — `brew install libev` / `apt install libev-dev`)

### Setup

```bash
git clone https://github.com/the-stewards-watch/the-stewards-watch-website.git
cd the-stewards-watch-website
cp .env.example .env   # fill in your Resend API key and email addresses
```

The app reads configuration from **OS environment variables** (via `uiop:getenv`), not
directly from the `.env` file. When running locally without Docker you need to export
those variables into your shell before starting SBCL:

```bash
export $(grep -v '^#' .env | xargs)
```

Then load in SBCL:

```lisp
(ql:quickload :the-steward-website)
(the-steward-website:start-app :debug t)
```

The app listens on `http://localhost:8080` by default.

> **Tip:** [direnv](https://direnv.net/) can load `.env` automatically whenever you enter
> the project directory, so you don't need to run the export command manually each time.

## Environment Variables

The app reads these variables from the OS environment at startup. Copy `.env.example`
to `.env` and fill in your values — how those values reach the process depends on how
you're running the app (see Local Development and Deployment sections above).

| Variable        | Description                                          |
|-----------------|------------------------------------------------------|
| `RESEND_API_KEY`| Resend API key (get one free at resend.com)          |
| `CONTACT_FROM`  | Verified sender address in your Resend account       |
| `CONTACT_TO`    | Inbox where contact form submissions are delivered   |
| `HOST`          | Bind address (default: `0.0.0.0`)                   |
| `PORT`          | Listen port (default: `8080`)                        |

## Deployment (Docker)

### CI/CD: Automated Builds

On every push to `main`, GitHub Actions automatically:
1. Builds the Docker image
2. Pushes to GitHub Container Registry

**Pull the latest image:**
```bash
docker pull ghcr.io/the-stewards-watch/the-stewards-watch-website:latest
```

**Run it:**
```bash
docker run -p 8080:8080 --env-file .env ghcr.io/the-stewards-watch/the-stewards-watch-website:latest
```

### Build locally (optional)

```bash
# Build the image
docker build -t the-steward-website .

# Run (pass env vars from your .env file)
docker run -p 8080:8080 --env-file .env the-steward-website
```

### With docker-compose

```bash
docker-compose up -d
```

`docker-compose.yml` is configured with `env_file: .env`, so Docker Compose reads the
`.env` file automatically and injects the variables into the container — no manual
export step needed.

The app will restart automatically on crash or system reboot.

### Reverse proxy

In production, put Caddy, Nginx, or Traefik in front of the container to handle SSL/TLS.

**Example Caddyfile:**

```
thestewardswatch.com {
    reverse_proxy localhost:8080
}
```

Caddy obtains and renews Let's Encrypt certificates automatically.

**Example Traefik labels (docker-compose):**

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.steward.rule=Host(`thestewardswatch.com`)"
  - "traefik.http.routers.steward.entrypoints=websecure"
  - "traefik.http.routers.steward.tls.certresolver=letsencrypt"
```

Traefik is a good choice if you're already running multiple containerised services and want a single entry point that handles routing and TLS for all of them.
