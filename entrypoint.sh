#!/bin/bash
set -e

echo ""
echo "═══════════════════════════════════════════════════"
echo "  ZikZak InAppWebView — Development Sandbox"
echo "═══════════════════════════════════════════════════"
echo ""
echo "  Flutter: $(flutter --version 2>/dev/null | head -1)"
echo "  Dart:    $(dart --version 2>/dev/null)"
echo "  Node.js: $(node --version 2>/dev/null)"
echo ""

# Always run Flutter doctor once to verify toolchain health
flutter doctor -v 2>&1 | head -40

echo ""
echo "  Ready."
echo ""

exec "$@"
