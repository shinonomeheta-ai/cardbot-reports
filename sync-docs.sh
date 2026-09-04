#!/usr/bin/env bash
# cardbot 本体の「写して置く3ファイル」を cardbot-reports へ取り込んで push する。
#
#   bash /d/cardbot-reports/sync-docs.sh
#
# cardbot 側でこの3ファイルを更新したら、必ずこれを実行して写しを合わせる。
# 差分が無ければ何もしない。
set -euo pipefail

SRC=/d/cardbot
REPO=/d/cardbot-reports

# 本体のパス:写し先のパス
FILES=(
  "docs/target-architecture.md:docs/target-architecture.md"
  "docs/target-architecture-v12.png:docs/target-architecture-v12.png"
  ".claude/CLAUDE.md:docs/CLAUDE.md"
)

git -C "$REPO" pull --ff-only --quiet

for pair in "${FILES[@]}"; do
  from="$SRC/${pair%%:*}"
  to="$REPO/${pair##*:}"
  if [ ! -f "$from" ]; then echo "本体に無い: $from" >&2; exit 1; fi
  cp "$from" "$to"
done

git -C "$REPO" add -- docs
if git -C "$REPO" diff --cached --quiet -- docs; then
  echo "差分なし。写しは本体と一致している。"
else
  git -C "$REPO" commit --quiet -m "docs: 本体の写しを更新する"
  git -C "$REPO" push --quiet
  echo "写しを更新して push した。"
fi

echo
echo "md5（本体 / 写し）:"
for pair in "${FILES[@]}"; do
  a=$(md5sum "$SRC/${pair%%:*}" | cut -d' ' -f1)
  b=$(md5sum "$REPO/${pair##*:}" | cut -d' ' -f1)
  st=$([ "$a" = "$b" ] && echo 一致 || echo "不一致")
  printf '  %-34s %s %s %s\n' "${pair##*:}" "$a" "$b" "$st"
done
