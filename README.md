# The Steward Website

A small business website built with Common Lisp to promote and manage a local home sitting service.

## Overview

The Steward Website is a web application that provides an online presence for a small, trusted home sitting business. It features service descriptions, a contact form, an availability calendar, and basic admin tools.

Built using Common Lisp with a focus on simplicity, speed, and maintainability.

## Features

- Responsive landing page
- Service overview with pricing
- Secure contact form
- Availability calendar (static or dynamic)
- Admin login for viewing inquiries (optional)

## Local Development

### Requirements

- SBCL
- Quicklisp
- libev (required by the Woo web server — `brew install libev` / `apt install libev-dev`)

### Setup

```bash
git clone https://github.com/matthew-bestard/the-steward-website.git
cd the-steward-website
cp .env.example .env   # fill in your Resend API key and email addresses
```

Load in SBCL:

```lisp
(ql:quickload :the-steward-website)
(the-steward-website:start-app :debug t)
```

The app listens on `http://localhost:8080` by default.

## Environment Variables

Copy `.env.example` to `.env` and set the following:

| Variable        | Description                                          |
|-----------------|------------------------------------------------------|
| `RESEND_API_KEY`| Resend API key (get one free at resend.com)          |
| `CONTACT_FROM`  | Verified sender address in your Resend account       |
| `CONTACT_TO`    | Inbox where contact form submissions are delivered   |
| `HOST`          | Bind address (default: `0.0.0.0`)                   |
| `PORT`          | Listen port (default: `8080`)                        |

## Deployment (Docker)

### Build and run

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

The app will restart automatically on crash or system reboot.

### Reverse proxy

In production, put Caddy or Nginx in front of the container to handle SSL/TLS.

**Example Caddyfile:**

```
thestewardswatch.com {
    reverse_proxy localhost:8080
}
```

Caddy obtains and renews Let's Encrypt certificates automatically.
