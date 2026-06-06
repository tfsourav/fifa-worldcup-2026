#!/bin/bash
# ⚽ FIFA World Cup 2026 — One-Click Deploy Script
# Usage: GITHUB_TOKEN=xxx VERCEL_TOKEN=xxx bash deploy.sh

set -e

GITHUB_USERNAME="${GITHUB_USERNAME:-}"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
VERCEL_TOKEN="${VERCEL_TOKEN:-}"
REPO_NAME="fifa-world-cup-2026"

echo "🏆 FIFA World Cup 2026 — Deploying..."
echo ""

# ── GITHUB ──
if [ -n "$GITHUB_TOKEN" ] && [ -n "$GITHUB_USERNAME" ]; then
  echo "📦 Creating GitHub repository..."
  curl -s -X POST \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/user/repos \
    -d "{\"name\":\"$REPO_NAME\",\"description\":\"⚽ FIFA World Cup 2026 Ultimate Schedule & Guide — All 104 matches, timezone converter, calendar export\",\"homepage\":\"https://$REPO_NAME.vercel.app\",\"public\":true}" \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print('✅ GitHub repo:', d.get('html_url','Already exists or error'))"

  git remote add origin "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git" 2>/dev/null || \
  git remote set-url origin "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git"

  git push -u origin main --force
  echo "✅ Code pushed to GitHub!"
fi

# ── VERCEL ──
if [ -n "$VERCEL_TOKEN" ]; then
  echo ""
  echo "🚀 Deploying to Vercel..."
  npx vercel --token "$VERCEL_TOKEN" --prod --yes --name "$REPO_NAME"
  echo "✅ Live on Vercel!"
fi

echo ""
echo "🎉 Done! Your site is live."
