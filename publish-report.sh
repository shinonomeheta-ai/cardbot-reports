#!/usr/bin/env bash
# 報告を cardbot-reports へ置いて push する。
#
# 使い方（cardbot の作業ディレクトリなど、どこからでも可）:
#   bash /d/cardbot-reports/publish-report.sh 2026-09-04-gate-audit.md < 報告本文
#   bash /d/cardbot-reports/publish-report.sh 2026-09-04-gate-audit.md /path/to/report.md
#
# 第2引数を省いた場合は標準入力を読む。
set -euo pipefail

REPO=/d/cardbot-reports
NAME=${1:?ファイル名を指定する（例: 2026-09-04-gate-audit.md）}
SRC=${2:-}

case "$NAME" in
  [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-*.md) ;;
  *) echo "ファイル名は YYYY-MM-DD-内容.md 形式にする: $NAME" >&2; exit 1 ;;
esac

DEST="$REPO/reports/$NAME"
if [ -n "$SRC" ]; then cp "$SRC" "$DEST"; else cat > "$DEST"; fi

git -C "$REPO" pull --ff-only --quiet

# 索引に載っていない報告は push しない（INDEX.md への追記漏れを防ぐ）
if ! grep -qF "$NAME" "$REPO/reports/INDEX.md"; then
  echo "reports/INDEX.md に $NAME の行が無い。1行足してから実行する。" >&2
  exit 1
fi

git -C "$REPO" add "reports/$NAME" "reports/INDEX.md"
if git -C "$REPO" diff --cached --quiet; then
  echo "変更なし: $NAME"; exit 0
fi
git -C "$REPO" commit --quiet -m "report: $NAME"
git -C "$REPO" push --quiet
echo "https://raw.githubusercontent.com/shinonomeheta-ai/cardbot-reports/main/reports/$NAME"
