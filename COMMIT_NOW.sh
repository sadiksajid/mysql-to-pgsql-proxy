#!/bin/bash
# Quick commit script for the Docker build fix

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         Committing Docker Build Fix for Cargo.lock            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Show what will be committed
echo "📋 Changes to be committed:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git status --short
echo ""

# Commit
echo "💾 Creating commit..."
git commit -m "Fix: Add Cargo.lock for reproducible builds and Docker CI/CD

- Removed Cargo.lock from .gitignore
- Added Cargo.lock to repository (binary projects should commit it)
- This fixes the Docker build error: '/Cargo.lock': not found
- Ensures reproducible builds and consistent dependencies

For Rust applications (not libraries), Cargo.lock should be committed
to ensure everyone builds with the exact same dependency versions.

Fixes: Docker multi-platform build on GitHub Actions"

echo ""
echo "✅ Committed successfully!"
echo ""

# Ask to push
read -p "🚀 Push to origin/master now? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📤 Pushing to remote..."
    git push origin master
    echo ""
    echo "✅ Pushed successfully!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 Docker build will now trigger automatically!"
    echo ""
    echo "Monitor progress at:"
    echo "https://github.com/YOUR_USERNAME/mysql-to-psql-proxy/actions"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo "⏸️  Not pushed. You can push later with:"
    echo "   git push origin master"
fi

