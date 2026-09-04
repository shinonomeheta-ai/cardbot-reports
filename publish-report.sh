#!/usr/bin/env bash
# 報告を cardbot-reports へ置いて push する。
#
# 使い方（cardbot の作業ディレクトリなど、どこからでも可）:
#   bash /d/cardbot-reports/publish-report.sh 2026-09-04-gate-audit.md < 報告本文
#   bash /d/cardbot-reports/publish-report.sh 2026-09-04-gate-audit.md /path/to/report.md
#
# 第2引数を省いた場合は標準入力を読む。
# 置き場が /d/cardbot-reports でないときは REPORTS_REPO で渡す。
set -euo pipefail

REPO=${REPORTS_REPO:-/d/cardbot-reports}
NAME=${1:?ファイル名を指定する（例: 2026-09-04-gate-audit.md）}
SRC=${2:-}

case "$NAME" in
  [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-*.md) ;;
  *) echo "ファイル名は YYYY-MM-DD-内容.md 形式にする: $NAME" >&2; exit 1 ;;
esac
[ -d "$REPO/.git" ] || { echo "置き場が無い: $REPO（REPORTS_REPO で指定する）" >&2; exit 1; }

git -C "$REPO" pull --ff-only --quiet

# **本文を置く前に**、この報告が既にあるか（＝追記か）を覚えておく。
# 置いたあとでは新規と追記の区別が付かない。
is_append=no
git -C "$REPO" cat-file -e "HEAD:reports/$NAME" 2>/dev/null && is_append=yes

DEST="$REPO/reports/$NAME"
if [ -n "$SRC" ]; then cp "$SRC" "$DEST"; else cat > "$DEST"; fi

# 索引に載っていない報告は push しない（INDEX.md への追記漏れを防ぐ）
if ! grep -qF "$NAME" "$REPO/reports/INDEX.md"; then
  echo "reports/INDEX.md に $NAME の行が無い。1行足してから実行する。" >&2
  exit 1
fi

# **追記のときは、索引の行も直っていること**（決まり5・2026-09-04 追加）。
#
# それまでの関門は「索引にその名前の行があるか」だけを見ていた。新規のときは
# 行が無いので止まるが、**追記のときは行が既にあるので素通り**する。本文だけ
# 直して索引が `判断待ち・確認中` のまま残る道があり、実際に「INDEX が実態と
# ずれている」と指摘を受けた。索引を起点に状況を見る運用なので、ここで止める。
if [ "$is_append" = yes ] && ! git -C "$REPO" diff --quiet HEAD -- "reports/$NAME"; then
  old_row=$(git -C "$REPO" show "HEAD:reports/INDEX.md" | grep -F "$NAME" || true)
  new_row=$(grep -F "$NAME" "$REPO/reports/INDEX.md" || true)
  if [ "$old_row" = "$new_row" ]; then
    echo "本文を直したのに reports/INDEX.md の $NAME の行が変わっていない。" >&2
    echo "  状態（判断待ち→完了 など）・判断結果・追記日を直してから実行する。" >&2
    echo "  いまの行: $new_row" >&2
    exit 1
  fi
fi

git -C "$REPO" add "reports/$NAME" "reports/INDEX.md"
if git -C "$REPO" diff --cached --quiet; then
  echo "変更なし: $NAME"; exit 0
fi
if [ "$is_append" = yes ]; then
  git -C "$REPO" commit --quiet -m "report: $NAME に追記"
else
  git -C "$REPO" commit --quiet -m "report: $NAME"
fi
git -C "$REPO" push --quiet
echo "https://raw.githubusercontent.com/shinonomeheta-ai/cardbot-reports/main/reports/$NAME"
