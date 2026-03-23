# ── The Steward Website ────────────────────────────────────────────────────────
#
# Build:
#   docker build -t the-steward-website .
#
# Run (PORT defaults to 8080):
#   docker run -p 8080:8080 --env-file .env the-steward-website

# Pin to a specific SBCL version for reproducible builds.
# To upgrade: update the tag and rebuild from scratch.
FROM clfoundation/sbcl:2.5.10

# System packages:
#   libev-dev  — required to compile and run the Woo HTTP server
#   libssl-dev — required by Dexador (HTTPS outbound requests to Resend API)
#   curl       — used below to bootstrap Quicklisp; also used by HEALTHCHECK
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      libev-dev \
      libssl-dev \
      curl \
 && rm -rf /var/lib/apt/lists/*

# Install Quicklisp
RUN curl -fsSL https://beta.quicklisp.org/quicklisp.lisp -o /tmp/quicklisp.lisp \
 && sbcl --noinform \
         --load /tmp/quicklisp.lisp \
         --eval '(quicklisp-quickstart:install)' \
         --quit \
 && rm /tmp/quicklisp.lisp

WORKDIR /app

# Copy only the system definition first so this dependency-download layer is
# cached by Docker and only re-runs when .asd (and thus the dep list) changes.
COPY the-steward-website.asd .

RUN sbcl --noinform \
         --load /root/quicklisp/setup.lisp \
         --eval '(ql:quickload (list :clack :woo :lack/request :tiny-routes :djula :local-time :alexandria :cl-json :dexador) :silent t)' \
         --quit

# Copy the rest of the project (source, templates, static assets)
COPY . .

EXPOSE 8080

# Wait 90s on first start (Quicklisp compile time), then check every 30s.
HEALTHCHECK --interval=30s --timeout=5s --start-period=90s --retries=3 \
  CMD curl -fsS http://localhost:${PORT:-8080}/ > /dev/null || exit 1

ENTRYPOINT ["/app/entrypoint.sh"]
