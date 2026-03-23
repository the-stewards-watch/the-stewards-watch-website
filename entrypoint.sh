#!/bin/sh
# Production entry point for the Steward Website.
# Environment variables (set via Docker -e, --env-file, or docker-compose):
#   RESEND_API_KEY, CONTACT_FROM, CONTACT_TO, HOST, PORT
#
# Uses a file-based signal mechanism since SBCL signal handling is blocked
# by Woo/libev's event loop.

set -e

SHUTDOWN_FILE="/tmp/.shutdown-requested"
rm -f "$SHUTDOWN_FILE"
export SHUTDOWN_FILE

# Start SBCL in the background
sbcl --noinform \
  --load /root/quicklisp/setup.lisp \
  --eval "(push #p\"/app/\" asdf:*central-registry*)" \
  --eval "(ql:quickload :the-steward-website :silent t)" \
  --eval "(the-steward-website:main)" &

SBCL_PID=$!

# On SIGTERM, create shutdown file and wait for SBCL to exit
shutdown() {
  echo "Received SIGTERM, signaling shutdown..."
  touch "$SHUTDOWN_FILE"
  wait $SBCL_PID 2>/dev/null
  exit 0
}
trap shutdown TERM INT

# Wait for SBCL to exit
wait $SBCL_PID
