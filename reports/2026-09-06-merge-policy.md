# マージ運用の明文化: `gh pr merge` の許可と CLAUDE.md「マージの条件」（PR #1342）

日付: 2026-09-06（JST）
区切り/依頼名: マージ運用（設定と CLAUDE.md）

## 受けた指示（原文）

> docs（または動いているセッションのどれか）:
>
> .claude/settings.local.json に `gh pr merge` を許可する設定を足してください。
> あわせて CLAUDE.md の「開発の進め方」に、マージの条件を追記:
>
> ---
> ## マージの条件
> 以下をすべて満たすときだけ、実装セッションが自分でマージしてよい。
> 1. CI で PR 固有の赤が0件（main の基準と diff して確認）
> 2. Vercel のデプロイ（プレビュー）が成功
> 3. レビュー担当の承認が報告に記録されている
> 4. マージ後、報告に merge commit を追記する
>
> いずれかを満たさない場合は、本人の操作を待つ。
> ---
>
> 設定の変更は git 管理下（#1267 で管理下に入れた）なので PR で。

## 指示と過去の報告の食い違い

2 点。

1. **#1267 はマージされていない。** 2026-09-06 時点で OPEN（head 6ce5153b・main から 283 コミット遅れ）。
   INDEX の 2026-09-04「報告置き場の運用」行にも「PR #1267 はマージ待ち」とある。
2. **#1267 が管理下に入れたのは `.claude/CLAUDE.md` だけ。** `settings.local.json` は
   #1267 本文で「無視のまま」と明記されている（`.claude/*` のあとに `!.claude/CLAUDE.md` の 1 行だけ）。
   つまり「設定の変更は git 管理下」は、この指示の時点では成り立っていなかった。

対応: #1267 の枝の上に積む PR にし、その中で `settings.local.json` も再包含した。
`settings.local.json` は #1267 本文の確認どおり `token|secret|password|api_key` の一致 0 件で、
今回足した 2 行にも秘密は無い。

## 報告

### PR

- **PR #1342** https://github.com/shinonomeheta-ai/cardbot/pull/1342
- 枝 `chore/merge-policy`（head **36923a05**）。base は `chore/track-claude-md`（#1267 の枝）。
  #1267 がマージされると base は自動で `main` に切り替わる。順番は **#1267 → #1342**。

### 変更（3 ファイル・追加のみ 104 行）

| ファイル | 変更 |
|---|---|
| `.gitignore` | `!.claude/settings.local.json` を追加（`.claude/*` は据え置き）。元が CRLF なので CRLF のまま 2 行だけの差分 |
| `.claude/settings.local.json` | **新規追跡**。`D:\cardbot` の現物 81 件に `Bash(gh pr merge *)` と `PowerShell(gh pr merge *)` を足して 83 件 |
| `.claude/CLAUDE.md` | 「Development order」の直後に「## マージの条件」を追加（413 → 426 行）。指示文をそのまま転記 |

`Bash(gh pr *)` は既に入っていたので Bash 側は元から通っていた。届いていなかったのは
PowerShell 側と、**worktree で開いたセッション**（worktree には `.claude/` が無いので許可が一切効かない）。
追跡に入れることで、新しく切った worktree すべてに同じ許可が配られる。

### 確認したこと

- `git status --short` は上の 3 パスだけ。
- `git check-ignore -v` の実測: `.claude/worktrees/*`・`.claude/locks/*`・`.claude/review-artifacts/*`・
  `.claude/settings.json` は引き続き除外。`.claude/CLAUDE.md` と `.claude/settings.local.json` だけ追跡。
- `settings.local.json` は `json.load` で読める（83 件）。CLAUDE.md・settings は LF。
- CI・Vercel はこの報告の時点では未確認（PR 作成直後）。**「マージの条件」1〜3 を満たす前なので、
  この PR 自身も本人の操作かレビュー担当の承認を待つ。**

### マージ後に必要なこと（未完了）

- `D:\cardbot` の現物 `.claude/settings.local.json`・`.claude/CLAUDE.md` はこの PR とは別物。
  マージ後に `origin/main` から取り直す必要がある。`D:\cardbot` の作業ツリーは HEAD が古く
  staged 変更が 2,000 件超あるため、この PR では触っていない（触る判断は本人）。
- `sync-docs.sh` の `UNTRACKED` は #1267 の予定どおり空にできる。

### 採用した仮定

- 「開発の進め方」= CLAUDE.md の「## Development order」節と読み、その直後に置いた。
- 「マージの条件」の本文は指示文を一字も変えずに転記した。

## 根拠データ

なし（集計を伴わない設定変更。差分は PR #1342 の Files changed がそのまま根拠）。
