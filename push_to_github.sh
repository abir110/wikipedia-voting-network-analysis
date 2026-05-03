#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
#  push_to_github.sh
#  Initialises a local Git repo and pushes to GitHub using the GitHub CLI (gh).
#
#  USAGE:
#    chmod +x push_to_github.sh
#    ./push_to_github.sh
#
#  REQUIREMENTS:
#    • Git      — https://git-scm.com/downloads
#    • GitHub CLI (gh) — https://cli.github.com
#      Install:  brew install gh        (macOS)
#                sudo apt install gh    (Ubuntu/Debian)
#                winget install gh      (Windows)
#      Authenticate once: gh auth login
# ─────────────────────────────────────────────────────────────────────────────

set -e   # Exit immediately on any error

# ── 1. CONFIG — edit these two lines ─────────────────────────────────────────
REPO_NAME="network-science-portfolio"
REPO_DESC="Network Science analysis of the Wikipedia Voting Network — graph theory, community detection, failure propagation, opinion dynamics and flow optimisation."
# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo "================================================="
echo "  GitHub Portfolio Push Script"
echo "================================================="
echo ""

# ── 2. Check dependencies ─────────────────────────────────────────────────────
echo "▶  Checking dependencies..."

if ! command -v git &> /dev/null; then
    echo "✗  Git not found. Install it from https://git-scm.com/downloads"
    exit 1
fi

if ! command -v gh &> /dev/null; then
    echo "✗  GitHub CLI (gh) not found."
    echo "   Install:  brew install gh   (macOS)"
    echo "             sudo apt install gh  (Ubuntu/Debian)"
    echo "             winget install gh    (Windows)"
    echo "   Docs: https://cli.github.com"
    exit 1
fi

echo "✓  Git $(git --version | cut -d' ' -f3) found"
echo "✓  gh $(gh --version | head -1 | cut -d' ' -f3) found"

# ── 3. Authenticate check ─────────────────────────────────────────────────────
echo ""
echo "▶  Checking GitHub authentication..."
if ! gh auth status &> /dev/null; then
    echo "   Not logged in. Launching GitHub login..."
    gh auth login
fi
GH_USER=$(gh api user --jq '.login')
echo "✓  Logged in as: $GH_USER"

# ── 4. Initialise Git repo if needed ─────────────────────────────────────────
echo ""
echo "▶  Initialising local Git repository..."
if [ ! -d ".git" ]; then
    git init
    echo "✓  Git repo initialised"
else
    echo "✓  Existing Git repo found"
fi

# ── 5. Set up .gitignore ──────────────────────────────────────────────────────
echo ""
echo "▶  Writing .gitignore..."
cat << 'GITIGNORE_EOF' > .gitignore
# Jupyter
.ipynb_checkpoints/
*/.ipynb_checkpoints/*

# Python
__pycache__/
*.py[cod]
*.egg-info/
.env
.venv/
env/
venv/

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Large data files (download separately — see README)
data/*.gz
data/*.zip
GITIGNORE_EOF
echo "✓  .gitignore written"

# ── 6. Create figures directory placeholder ───────────────────────────────────
mkdir -p figures data
touch figures/.gitkeep
touch data/.gitkeep
echo "✓  figures/ and data/ directories ready"

# ── 7. Stage all files ────────────────────────────────────────────────────────
echo ""
echo "▶  Staging files..."
git add .
git status --short
echo ""

# ── 8. Commit ─────────────────────────────────────────────────────────────────
echo "▶  Creating initial commit..."
git config --global user.email "${GH_USER}@users.noreply.github.com" 2>/dev/null || true
git config --global user.name  "$GH_USER" 2>/dev/null || true
git commit -m "Initial commit: Network Science portfolio — Wikipedia Voting Network analysis

Covers:
- Structural analysis (SCC/WCC, degree distributions, centrality)
- Random graph phase transitions G(N,p) vs G(N,L)
- Biased random walk subgraph sampling
- Girvan-Newman community detection
- Failure propagation cascade model
- 3-opinion voter model
- Min-cost max-flow optimisation"
echo "✓  Commit created"

# ── 9. Create GitHub repo & push ─────────────────────────────────────────────
echo ""
echo "▶  Creating GitHub repository '$REPO_NAME'..."

# Check if repo already exists
if gh repo view "$GH_USER/$REPO_NAME" &> /dev/null; then
    echo "   Repo already exists — skipping creation, adding remote..."
    git remote remove origin 2>/dev/null || true
    git remote add origin "https://github.com/$GH_USER/$REPO_NAME.git"
else
    gh repo create "$REPO_NAME" \
        --public \
        --description "$REPO_DESC" \
        --source=. \
        --remote=origin
    echo "✓  GitHub repository created: https://github.com/$GH_USER/$REPO_NAME"
fi

# ── 10. Push ──────────────────────────────────────────────────────────────────
echo ""
echo "▶  Pushing to GitHub..."
git branch -M main
git push -u origin main --force
echo ""
echo "================================================="
echo "  ✅  Done! Your portfolio is live at:"
echo "  https://github.com/$GH_USER/$REPO_NAME"
echo "================================================="
echo ""
echo "  Next steps:"
echo "  1. Go to the link above and check everything looks right"
echo "  2. Add a profile picture / bio to your GitHub profile"
echo "  3. Pin this repo on your GitHub profile page"
echo "  4. Copy the repo URL into your CV / LinkedIn"
echo ""
