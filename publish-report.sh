#!/usr/bin/env bash
# 報告を cardbot-reports へ置いて push する。
#
# 使い方（cardbot の作業ディレクトリなど、どこからでも可）:
#   bash /d/cardbot-reports/publish-report.sh 2026-09-04-gate-audit.md < 報告本文
#   bash /d/cardbot-reports/publish-report.sh 2026-09-04-gate-audit.md /path/to/report.md
#
# 第2引数を省いた場合は標準入力を読む。
# 置き場が /d/cardbot-reports でないときは REPORTS_REPO で渡す。
#
# 根拠データ（reports/data/*.json）は、この実行より前に置き場へ書いておく。
# 一緒に commit・push する（決まり7）。
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

# **索引の「報告ファイル」列は絶対URLであること**（決まり5・2026-09-04 追加）。
#
# それまでの関門は決まり5を文章でしか持っていなかった。実際に相対パスの行
# （`[2026-09-04-x-intake-capture-rate.md](2026-09-04-x-intake-capture-rate.md)`）が
# 素通りして push され、レビュー担当が報告本文へ辿れなかった。レビュー担当は
# INDEX を **raw URL** で読む。raw は Markdown を描かず素の文字列を返すので、
# 相対パスはリンクにならない。ここで機械で止める。
#
# 検査は**この報告の行だけでなく索引の全行**を見る。別セッションが足した行が
# 崩れていても、次に誰かが報告を出したところで止まって直せる。
INDEX_URL_PREFIX="https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/"
bad_rows=$(awk -v prefix="$INDEX_URL_PREFIX" '
  # 本表は6列（先頭と末尾が空になるので | で分けると 8 個）。
  # 「列の意味」の表（2列）や README の例（3列）は対象外。
  BEGIN { FS = "|" }
  NF != 8 { next }
  {
    cell = $5
    sub(/^[ \t]+/, "", cell)
    sub(/[ \t]+$/, "", cell)
    if (cell == "報告ファイル") next               # 見出し行
    if (cell ~ /^-+$/) next                        # 区切り行
    if (cell == "本文なし（チャットのみ）") next   # 置き場を作る前の報告（例外）
    # [表示名](絶対URL) の形か
    if (cell ~ /^\[[^]]+\]\(.+\)$/) {
      url = cell
      sub(/^\[[^]]+\]\(/, "", url)
      sub(/\)$/, "", url)
      if (index(url, prefix) == 1 && length(url) > length(prefix)) next
    }
    printf "  %d行目: %s\n", NR, $0
  }
' "$REPO/reports/INDEX.md")
if [ -n "$bad_rows" ]; then
  echo "reports/INDEX.md の「報告ファイル」列が絶対URLでない行がある（決まり5）:" >&2
  printf '%s' "$bad_rows" >&2
  echo "  前置きは $INDEX_URL_PREFIX で固定する。" >&2
  echo "  本文がまだ無い報告だけ「本文なし（チャットのみ）」を書ける。" >&2
  exit 1
fi

# **追記のときは、索引の行も直っていること**（決まり6・2026-09-04 追加）。
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

# **本文が指している根拠データが実在すること**（決まり7・2026-09-04 追加）。
# リンクだけ張って JSON を置き忘れると、レビュー担当の側では 404 になり、
# 「どのファイルを見て数えたか」が結局たどれない。ここで止める。
missing=""
while read -r ref; do
  [ -n "$ref" ] || continue
  [ -f "$REPO/$ref" ] || missing="$missing  $ref"$'\n'
done <<< "$(grep -oE 'reports/data/[^)"[:space:]]+\.json' "$DEST" | sort -u || true)"
if [ -n "$missing" ]; then
  echo "本文が指している根拠データが置き場に無い:" >&2
  printf '%s' "$missing" >&2
  echo "  $REPO/reports/data/ へ置いてから実行する（決まり7）。" >&2
  exit 1
fi

git -C "$REPO" add "reports/$NAME" "reports/INDEX.md"
if [ -d "$REPO/reports/data" ]; then git -C "$REPO" add "reports/data"; fi
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
