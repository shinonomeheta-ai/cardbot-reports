#!/usr/bin/env bash
# cardbot 本体の「写して置く3ファイル」を cardbot-reports へ取り込んで push する。
#
#   bash /d/cardbot-reports/sync-docs.sh
#   bash /d/cardbot-reports/sync-docs.sh --allow-shrink   # CLAUDE.md が短くなるのを承知で通す
#
# cardbot 側でこの3ファイルを更新したら、必ずこれを実行して写しを合わせる。
# 差分が無ければ何もしない。
#
# ## どこから写すか（2026-09-04 に直した）
#
# git 管理下のファイルは **origin/main から** 取る（`git show origin/main:<path>`）。
# 以前は作業ツリー `D:\cardbot` から `cp` していたが、あの作業ツリーは HEAD が
# 1,875 コミット遅れていて、`docs/target-architecture.md` が §11 分割前の古い版の
# ままだった。そのまま走らせると**写しを巻き戻す**（実際 2026-09-04 に直前で気づいた）。
# しかも写しは公開されている唯一の版なので、巻き戻っても気づきにくい。
#
# `.claude/CLAUDE.md` だけは `.gitignore` の `.claude/` で除外されていて git に
# 無いので、作業ツリーから写すしかない。**そこだけ**は写す前後の md5 と行数を出し、
# **行数が減っていたら止める**（壊れた版で上書きしないため）。
#
# bash の変数名に日本語は使えない（`名=…` は代入でなくコマンド扱いになる）。
set -euo pipefail

SRC=/d/cardbot
REPO=/d/cardbot-reports
REF=origin/main
ALLOW_SHRINK=0
[ "${1:-}" = "--allow-shrink" ] && ALLOW_SHRINK=1

# git 管理下：origin/main から取る（本体のパス:写し先のパス）
TRACKED=(
  "docs/target-architecture.md:docs/target-architecture.md"
  "docs/target-architecture-v12.png:docs/target-architecture-v12.png"
)
# git 管理外：作業ツリーから取る（本体のパス:写し先のパス）
UNTRACKED=(
  ".claude/CLAUDE.md:docs/CLAUDE.md"
)

git -C "$REPO" pull --ff-only --quiet

# **origin/main を取り直してから写す。** 古い ref から写すと、作業ツリーから
# 写していたときと同じ「気づかない巻き戻し」になる。
git -C "$SRC" fetch --quiet origin main
echo "本体の参照: $REF = $(git -C "$SRC" rev-parse --short "$REF")"
echo

for pair in "${TRACKED[@]}"; do
  from="${pair%%:*}"; to="$REPO/${pair##*:}"
  if ! git -C "$SRC" cat-file -e "$REF:$from" 2>/dev/null; then
    echo "$REF に無い: $from" >&2; exit 1
  fi
  git -C "$SRC" show "$REF:$from" > "$to"
done

# --- git 管理外のファイル（CLAUDE.md）---
#
# 履歴が無いので、壊れた版で上書きすると戻せない。**写す前後を必ず見せ、
# 行数が減っていたら止める。**
for pair in "${UNTRACKED[@]}"; do
  from="$SRC/${pair%%:*}"; to="$REPO/${pair##*:}"
  name="${pair##*:}"
  if [ ! -f "$from" ]; then echo "本体に無い: $from" >&2; exit 1; fi

  old_md5="（写しがまだ無い）"; old_lines=0
  if [ -f "$to" ]; then
    old_md5=$(md5sum "$to" | cut -d' ' -f1)
    old_lines=$(wc -l < "$to")
  fi
  new_md5=$(md5sum "$from" | cut -d' ' -f1)
  new_lines=$(wc -l < "$from")

  echo "git 管理外（作業ツリーから写す）: $name"
  echo "  写す前  md5=$old_md5  行数=$old_lines"
  echo "  写した後 md5=$new_md5  行数=$new_lines"

  if [ "$new_lines" -lt "$old_lines" ]; then
    gone=$((old_lines - new_lines))
    if [ "$ALLOW_SHRINK" != "1" ]; then
      echo "  ! 行数が $gone 行 減っている。**写さずに止める**" >&2
      echo "    本体側が壊れていないか確かめること（$from）。" >&2
      echo "    意図した削除なら: bash $0 --allow-shrink" >&2
      exit 1
    fi
    echo "  ! 行数が $gone 行 減っているが --allow-shrink が付いているので写す" >&2
  fi
  cp "$from" "$to"
done
echo

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
for pair in "${TRACKED[@]}"; do
  a=$(git -C "$SRC" show "$REF:${pair%%:*}" | md5sum | cut -d' ' -f1)
  b=$(md5sum "$REPO/${pair##*:}" | cut -d' ' -f1)
  st=$([ "$a" = "$b" ] && echo 一致 || echo "不一致")
  printf '  %-34s %s %s %s  (%s)\n' "${pair##*:}" "$a" "$b" "$st" "$REF"
done
for pair in "${UNTRACKED[@]}"; do
  a=$(md5sum "$SRC/${pair%%:*}" | cut -d' ' -f1)
  b=$(md5sum "$REPO/${pair##*:}" | cut -d' ' -f1)
  st=$([ "$a" = "$b" ] && echo 一致 || echo "不一致")
  printf '  %-34s %s %s %s  (作業ツリー・git管理外)\n' "${pair##*:}" "$a" "$b" "$st"
done
