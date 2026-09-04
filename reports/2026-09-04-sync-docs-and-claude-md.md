# 写しの取得元を origin/main へ／CLAUDE.md を git 管理下に置く

日付: 2026-09-04（JST）
区切り/依頼名: 報告置き場の運用（sync-docs.sh・CLAUDE.md）

関連: PR [#1267](https://github.com/shinonomeheta-ai/cardbot/pull/1267)（本体・private・**マージ待ち**）／
cardbot-reports `72bf555`（sync-docs.sh の修正・push 済み）

## 受けた指示（原文）

> # 2点の対処
>
> ## 1. sync-docs.sh を origin/main から写すように直す
> 作業ツリーが1,875コミット遅れているため、そこから写すと古い版で上書きされます。
> 今回は気づいて止まりましたが、次に誰かが何も考えずに走らせたら
> 写しが巻き戻ります。しかも写しが公開されている唯一の版なので気づきにくい。
>
> sync-docs.sh を、作業ツリーではなく origin/main から取るように直してください。
> git show origin/main:<path> を使う形にすれば、作業ツリーの状態に依存しません。
>
> CLAUDE.md は git 管理外なので、そこだけは作業ツリーから写す必要があります。
> その場合、写す前後で md5 を表示し、内容が減っていないか（行数が減っていないか）を
> 確認する仕組みを入れてください。
>
> ## 2. CLAUDE.md が git 管理外である件
> .gitignore に .claude/ があるため、本体側の CLAUDE.md は履歴が残りません。
> 誰かが壊しても戻せない状態です。
>
> 対処を提案してください。選択肢としては:
> - .gitignore から .claude/CLAUDE.md だけ除外する（管理下に置く）
> - cardbot-reports 側の写しを正本とし、本体側はそこから取る
> - 現状維持（写しが唯一の版であることを明記する）
>
> それぞれのリスクを添えて提案してください。実装は判断後。

そのあと、提案に対して次の判断を受けた（原文）。

> # 判断: 案1で実装してください
>
> ## 実施
> 1. .gitignore の .claude/ を .claude/* に変え、!.claude/CLAUDE.md を足す
> 2. git status --porcelain で CLAUDE.md と .gitignore だけが出ることを確認
>    （83個の worktree が出ないこと）
> 3. PR を立てる。マージは報告後に指示します
> 4. マージ後、sync-docs.sh の UNTRACKED を空にし、
>    CLAUDE.md も origin/main から取るようにする（行数チェックの分岐は削除）
>
> ## 理由
> 提案の3点に同意します。特に3ファイルすべてを origin/main から取れるようになり、
> 作業ツリーへの依存が完全に消える点が大きい。今日の事故の原因がそこでした。
>
> ## 注意
> 2の確認は必ず実施してください。書き方を間違えると83個の worktree が
> 追跡対象になります。確認結果を報告に含めること。

## 指示と過去の報告の食い違い

指示文には**なし**。ただし、こちらの前回の説明に不正確な点が1つあったので訂正する。

前回「本体側の CLAUDE.md は履歴が残らず、誰かが壊しても戻せない」と述べたが、
**まったく戻せないわけではなかった**。cardbot-reports 側の写しは git 管理下なので、
`docs/CLAUDE.md` に2版の履歴がある（`5e33f2f` / `e45d972`）。正確には
「**最後に sync した時点までしか戻せない**。sync 前に壊れたら失われる」。
案1を選ぶ理由は変わらない。

## 報告

### 1. sync-docs.sh を直した（cardbot-reports `72bf555`）

git 管理下の2ファイルを **`git show origin/main:<path>`** から取るようにした。
走る前に `origin/main` を fetch し、**使った SHA を表示する**。作業ツリーの状態に
一切依存しない。

```
本体の参照: origin/main = f3f18226

md5（本体 / 写し）:
  docs/target-architecture.md        f2c5ce5c… f2c5ce5c… 一致  (origin/main)
  docs/target-architecture-v12.png   31d68a34… 31d68a34… 一致  (origin/main)
  docs/CLAUDE.md                     e24e2b6a… e24e2b6a… 一致  (作業ツリー・git管理外)
```

`.claude/CLAUDE.md` だけは git に無いので作業ツリーから写す。**そこだけ**は
写す前後の md5 と行数を表示し、**行数が減っていたら写さずに止める**。
意図した削除は `--allow-shrink` で通す。

3パターンを実際に走らせて確認した。

| 状況 | 結果 |
| --- | --- |
| 5行 → 2行（減る） | **止まる**（終了コード1）。**写しは5行のまま無傷** |
| 同上＋`--allow-shrink` | 警告を出して写す（終了コード0） |
| 5行 → 6行（増える） | 黙って通る |

### 2. CLAUDE.md を git 管理下に置く（PR #1267・マージ待ち）

```diff
-.claude/
+.claude/*
+# CLAUDE.md だけは管理下に置く（履歴を残す・2026-09-04）。
+# 親ディレクトリを除外したままでは再包含できないので `.claude/*` にしてある。
+!.claude/CLAUDE.md
```

**`.claude/` のままでは `!.claude/CLAUDE.md` が効かない。** 親ディレクトリを除外
していると、その中のファイルを再包含できないという git の仕様。空のリポジトリを
作って両方の書き方を試し、実際に効かないことを確認した。

```
パターンA  .claude/ + !.claude/CLAUDE.md    → CLAUDE.md は追加されない（効かない）
パターンB  .claude/* + !.claude/CLAUDE.md   → CLAUDE.md だけ追加される（効く）
```

#### 確認結果（指示 2・83個の worktree が出ないこと）

`.claude/` に実体があるのは `D:\cardbot` だけなので、そちらでパターンを当てて実測した
（`.gitignore` はバックアップを取り、確認後に md5 一致を確かめて元へ戻した）。

```
$ git status --porcelain -uall -- .claude
?? .claude/CLAUDE.md          ← 1件だけ

$ git status --porcelain -uall -- .claude | grep -c worktrees
0                              ← 83個の worktree は出ない
```

`.claude/*` は直下にしか当たらないので、サブディレクトリは引き続き除外される。

| パス | 件数 | 状態 |
| --- | --- | --- |
| `.claude/settings.local.json` | 1 | 無視のまま |
| `.claude/locks` | 7 | 無視のまま |
| `.claude/review-artifacts` | 2 | 無視のまま |
| `.claude/worktrees` | **83** | 無視のまま |

PR 側の worktree でも `git status --porcelain -uall` は
`M .gitignore` と `?? .claude/CLAUDE.md` の2つだけだった。

`.claude/CLAUDE.md` は `D:\cardbot` の現物をそのまま入れている（413行・LF・
md5 `e24e2b6a`）。内容の変更は無い。

#### 秘密の面

写しは public リポジトリに全文が載っているので、管理下に置いても新しい露出は無い。
`settings.local.json` は permissions が81件で、`token|secret|password|api_key` の
一致は0件（そもそも引き続き除外される）。

### 3. マージ後にやること（未実施）

`sync-docs.sh` の `UNTRACKED` を空にし、CLAUDE.md も `origin/main` から取るように
する（行数チェックの分岐は不要になる）。3ファイルすべてが `origin/main` 由来になり、
**作業ツリーへの依存が消える**。

## 今日の事故（次に同じ道を通る人へ）

### 事故1: 古い作業ツリーから写して、公開されている唯一の版を巻き戻しかけた

`sync-docs.sh` は `D:\cardbot` の**作業ツリー**から `cp` していた。あの作業ツリーは
HEAD が **1,875コミット遅れ**で、`docs/target-architecture.md` が §11 分割前の
古い版のままだった。

```
作業ツリー = 87d3812b   ← §11 の分割前（PR #1263 の前）
origin/main = 9cb6a0d0   ← 正しい版
```

走らせる直前に md5 を比べて気づき、`git show origin/main:<path> > <path>` で
作業ツリーを揃えてから実行した。**写しは公開されている唯一の版**なので、
巻き戻っても誰も気づかない。これが今回 `sync-docs.sh` を直した動機。

### 事故2: 別セッションが §8-1 を修正前に戻していた

同じ日に、別のセッションが `sync-docs.sh` を走らせて写しを更新していた
（`a40b108`）。その時点の作業ツリーがどの版だったかで、写しの内容が変わる。
**同じスクリプトを別々のセッションが走らせると、後から走ったほうの作業ツリーの
状態が勝つ。** 取得元を `origin/main` に固定すれば、誰が走らせても同じ結果になる。

（今回確認した限り、最終的な写しは `origin/main` と一致しており、§8-1 の
「締切が未来である」の削除も反映済みだった。）

### 実装上の知見: bash の変数名に日本語は使えない

`sync-docs.sh` を書き直したとき、`名="${pair##*:}"` のような日本語の変数名を使って
失敗した。bash の変数名は `[a-zA-Z_][a-zA-Z0-9_]*` に限られるので、`名=…` は
**代入ではなくコマンド**として解釈される。

```
sync-docs.sh: line 61: 名=docs/CLAUDE.md: No such file or directory
```

Python 側では日本語の識別子が普通に使えるので（このリポジトリでは実際に多用している）、
同じ感覚で bash を書くと踏む。**bash では ASCII の変数名にする。**

## 状態

- cardbot-reports `72bf555`（sync-docs.sh の修正・push 済み・origin/main と一致）
- 本体 PR #1267（`.gitignore` ＋ `.claude/CLAUDE.md`）— **マージしていない**（指示待ち）
- マージ後に `sync-docs.sh` の後片付け（`UNTRACKED` を空に）を行う
- 計測用 worktree 2つ（`scratchpad/gate` / `scratchpad/mainref`）は差分0で保持
- 第2区切りには進まない。「引きの別名対応（正規化の正本の選定）」の報告待ち
