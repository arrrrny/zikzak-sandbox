#!/bin/bash
# ─────────────────────────────────────────────────────────────────────
# ZikZak InAppWebView — Sandbox Setup Script
#
# Run this inside the sandbox to clone the repo, install dependencies,
# and verify everything works.
#
# Usage:  bash /workspace/setup.sh
# ─────────────────────────────────────────────────────────────────────
set -euo pipefail

REPO_URL="${1:-https://github.com/arrrrny/zikzak_inappwebview.git}"
REPO_DIR="/workspace/zikzak_inappwebview"

echo ""
echo "🔧 Setting up zikzak_inappwebview development environment..."
echo ""

# ── Clone ──────────────────────────────────────────────────────────
if [ -d "$REPO_DIR" ]; then
    echo "📦 Repo already exists at $REPO_DIR, pulling latest..."
    cd "$REPO_DIR"
    git pull --ff-only || true
else
    echo "📦 Cloning $REPO_URL ..."
    git clone "$REPO_URL" "$REPO_DIR"
    cd "$REPO_DIR"
fi

echo ""

# ── Flutter pub get (main plugin resolves all path dependencies) ────
echo "📥 Running flutter pub get for each package..."
cd "$REPO_DIR/zikzak_inappwebview"
flutter pub get

echo ""
echo "✅ Dependencies installed."

# ── Verify ──────────────────────────────────────────────────────────
echo ""
echo "🔍 Running flutter analyze..."
flutter analyze || echo "⚠️  Analyze found issues (check output above)"

echo ""
echo "🧪 Running flutter test..."
flutter test --reporter expanded 2>&1 || echo "⚠️  Some tests failed (check output above)"

echo ""
echo "═══════════════════════════════════════════════════"
echo "  ZikZak InAppWebView sandbox is ready!"
echo "  Code is at: $REPO_DIR"
echo "═══════════════════════════════════════════════════"
