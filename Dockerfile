# ── The Steward Website ────────────────────────────────────────────────────────
#
# Build:
#   docker build -t the-steward-website .
#
# Run:
#   docker run -p 8080:8080 \
#     -e RESEND_API_KEY=re_xxx \
#     -e CONTACT_FROM="The Stewards Watch <noreply@mail.example.com>" \
#     -e CONTACT_TO=you@example.com \
#     the-steward-website

FROM clfoundation/sbcl:latest

# System packages: libev (required by Woo) and curl (Quicklisp bootstrap)
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

# Copy only the system definition first so the dependency-download layer is
# cached by Docker and only re-runs when .asd changes.
COPY the-steward-website.asd .

RUN sbcl --noinform \
         --load /root/quicklisp/setup.lisp \
         --eval '(ql:quickload (list :clack :woo :tiny-routes :djula :local-time :mito :postmodern :alexandria :cl-json :dexador) :silent t)' \
         --quit

# Copy the full project
COPY . .

EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]
