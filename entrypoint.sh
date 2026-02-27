#!/bin/sh
# Production entry point for the Steward Website.
# Environment variables (set via Docker -e, --env-file, or docker-compose):
#   RESEND_API_KEY, CONTACT_FROM, CONTACT_TO, HOST, PORT
set -e

exec sbcl --noinform \
  --load /root/quicklisp/setup.lisp \
  --eval "(push #p\"/app/\" asdf:*central-registry*)" \
  --eval "(ql:quickload :the-steward-website :silent t)" \
  --eval "(the-steward-website:main)"
