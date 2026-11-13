#!/usr/bin/env bash
# Before the AI Project: installer / updater
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/TapasDas1982/before_the_Ai_Project/main/install.sh | bash
#   bash install.sh [TARGET_DIR]
# Env:
#   BTAP_BRANCH  branch or tag to install (default: main)
#   BTAP_SOURCE  use a local copy of this repo instead of downloading
set -euo pipefail

REPO_SLUG="TapasDas1982/before_the_Ai_Project"
BRANCH="${BTAP_BRANCH:-main}"
START_MARK="<!-- BEFORE-AI:START (managed by the Before the AI Project installer; edits inside this block are overwritten on update) -->"
END_MARK="<!-- BEFORE-AI:END -->"

case "${1:-}" in
  -h|--help)
    sed -n '2,9p' "${BASH_SOURCE[0]:-/dev/null}" 2>/dev/null || true
    echo "Installs the rule pack into TARGET_DIR (default: current directory)."
    exit 0 ;;
esac

TARGET="${1:-$PWD}"
[ -d "$TARGET" ] || { echo "error: target directory '$TARGET' does not exist" >&2; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"

say() { printf '  %s\n' "$*"; }

# ---- locate source -----------------------------------------------------------
SRC=""
TMP=""
cleanup() { if [ -n "$TMP" ]; then rm -rf "$TMP"; fi; }
trap cleanup EXIT

if [ -n "${BTAP_SOURCE:-}" ]; then
  SRC="$BTAP_SOURCE"
else
  SCRIPT_PATH="${BASH_SOURCE[0]:-}"
  if [ -n "$SCRIPT_PATH" ] && [ -f "$SCRIPT_PATH" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
    [ -f "$SCRIPT_DIR/rules/00-core.md" ] && SRC="$SCRIPT_DIR"
  fi
fi

if [ -z "$SRC" ]; then
  TMP="$(mktemp -d)"
  echo "Downloading rule pack ($REPO_SLUG@$BRANCH)…"
  if command -v git >/dev/null 2>&1; then
    git clone --quiet --depth 1 --branch "$BRANCH" "https://github.com/$REPO_SLUG.git" "$TMP/src"
  else
    mkdir -p "$TMP/src"
    curl -fsSL "https://codeload.github.com/$REPO_SLUG/tar.gz/$BRANCH" | tar xz -C "$TMP/src" --strip-components=1
  fi
  SRC="$TMP/src"
fi

[ -f "$SRC/rules/00-core.md" ] || { echo "error: '$SRC' does not look like the rule pack" >&2; exit 1; }
if [ "$(cd "$SRC" && pwd)" = "$TARGET" ]; then
  echo "error: target is the rule pack repo itself; run this inside your project" >&2; exit 1
fi

VERSION="$(tr -d '[:space:]' < "$SRC/VERSION" 2>/dev/null || echo unknown)"
echo "Installing Before the AI Project v$VERSION into $TARGET"

# ---- helpers -----------------------------------------------------------------
# upsert_block FILE BLOCK_FILE HEADER
#   creates FILE (with HEADER) if missing, replaces an existing managed block,
#   or appends the managed block to the end of an existing file.
upsert_block() {
  local file="$1" block="$2" header="$3"
  mkdir -p "$(dirname "$file")"
  if [ ! -f "$file" ]; then
    {
      [ -n "$header" ] && printf '%s\n\n' "$header"
      printf '%s\n' "$START_MARK"
      cat "$block"
      printf '%s\n' "$END_MARK"
    } > "$file"
    say "created  ${file#$TARGET/}"
  elif grep -q "BEFORE-AI:START" "$file"; then
    awk -v blk="$block" -v sm="$START_MARK" -v em="$END_MARK" '
      index($0, "BEFORE-AI:START") { print sm; while ((getline l < blk) > 0) print l; close(blk); skip=1; next }
      skip && index($0, "BEFORE-AI:END") { print em; skip=0; next }
      !skip { print }
    ' "$file" > "$file.btap.tmp" && mv "$file.btap.tmp" "$file"
    say "updated  ${file#$TARGET/} (managed block)"
  else
    {
      printf '\n%s\n' "$START_MARK"
      cat "$block"
      printf '%s\n' "$END_MARK"
    } >> "$file"
    say "appended ${file#$TARGET/} (your content kept, block added at end)"
  fi
}

copy_if_missing() {
  local src="$1" dst="$2"
  if [ -e "$dst" ]; then
    say "kept     ${dst#$TARGET/} (yours)"
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    say "created  ${dst#$TARGET/}"
  fi
}

# ---- upstream-owned files (replaced on every run) ----------------------------
mkdir -p "$TARGET/.ai-rules"
rm -rf "$TARGET/.ai-rules/rules"
cp -R "$SRC/rules" "$TARGET/.ai-rules/rules"
printf '%s\n' "$VERSION" > "$TARGET/.ai-rules/VERSION"
say "synced   .ai-rules/rules/ ($(ls "$TARGET/.ai-rules/rules" | wc -l | tr -d ' ') files)"

mkdir -p "$TARGET/.cursor/rules"
cp "$SRC/templates/cursor-rule.mdc" "$TARGET/.cursor/rules/before-ai.mdc"
say "synced   .cursor/rules/before-ai.mdc"

# ---- user-owned files (created once, never overwritten) ----------------------
for f in "$SRC"/templates/project/*.md; do
  copy_if_missing "$f" "$TARGET/.ai-rules/project/$(basename "$f")"
done

# ---- agent entry points (managed block only) ---------------------------------
upsert_block "$TARGET/AGENTS.md"                       "$SRC/templates/agents-block.md"  "# AGENTS.md"
upsert_block "$TARGET/CLAUDE.md"                       "$SRC/templates/claude-block.md"  "# CLAUDE.md"
upsert_block "$TARGET/.github/copilot-instructions.md" "$SRC/templates/copilot-block.md" ""

echo
echo "Done. Next steps:"
echo "  1. Fill in .ai-rules/project/PROJECT_MAP.md"
echo "  2. Record your models/SDKs in .ai-rules/project/FRESHNESS.md (with verified dates)"
echo "  3. Write 10-20 golden cases in .ai-rules/project/EVALS.md"
echo "  Update anytime by re-running the installer."
