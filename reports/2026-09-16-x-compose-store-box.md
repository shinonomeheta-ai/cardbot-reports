# 投稿を作る：支店ごとに／ボックス別まとめ（#1590 マージ＋デプロイ）

## 指示文

> 他のブランチで作業しようとして失敗してるので同じ作業場所でマージとデプロイをして

直前までの指示（この画面に対するもの）:

- 視点ごとに、は誤字。支店ごとに作成する（支店＝本社／支社の店）
- その隣に、ボックス別まとめも「投稿を作る」のテンプレートとして入れる
- 下書きは X 向け。Discord 送信はしない。ナビの BOX別まとめは残す
- 本社はゴールデンデータの完全一致だけ。それ以外は支社。名前のヒューリスティックは足さない
- 「本社＝ゴールデンデータ」などの説明文は出さない
- 本社／支社／両方のボタンで、載せる店と集計を分ける
- 絞ったやつの下書きだけ。全店自動選択や「次弾をすべて載せる」は出さない
- この画面から X へは出さない

作業ツリー `D:\cardbot` は別件で汚れていた。別ブランチ／別 worktree へ移そうとして失敗したので、**同じ場所のまま** この機能だけを main へ載せ、デプロイした。

根拠データ: https://raw.githubusercontent.com/shinonomeheta-ai/cardbot-reports/main/reports/data/2026-09-16-x-compose-store-box.json

---

## 結論

- PR https://github.com/shinonomeheta-ai/cardbot/pull/1590 を **squash マージした**
- merge commit: `ab99b00767adcd0d49c924ebb4826485eb8b9802`（2026-09-16T06:56:03Z）
- 本番デプロイ: `gh workflow run deploy --ref main` → run [35066054678](https://github.com/shinonomeheta-ai/cardbot/actions/runs/35066054678) **success**（headSha は上の merge commit）
- 手元の checkout は動かしていない。今も `fix-x-next-always-assemble`（`9d244689f`）＋汚れた作業ツリーのまま
- 空の失敗枝 `feat/x-compose-branch-box` は使っていない
- X への実投稿・Discord 実送信・本番DB・有料AIはしていない

---

## 何が入ったか

管理画面「投稿を作る」（X の下書き）:

1. **本社／支社／両方** で店の母数と集計を分ける。本社は `isGoldenHqStore` の完全一致だけ。それ以外は支社
2. テンプレート **支店ごとに作成する**（誤字「視点」を直した）
3. その隣のテンプレート **ボックス別まとめ**。本文は既存 `buildBoxDigest` を `split: false` で1通にしたもの。Discord の 2000 字分割は使わない
4. 下書きは絞った選択だけ。全選択の「16点」「店舗全て載せる」「次弾をすべて載せる」は出さない
5. 左がテンプレート下書き、右が X プレビュー。画像は最大4枚・ボックスを先・表示は小さく
6. 朝夜の組み立て済みまとめは、この画面の自由文キューには出さない（`onNextPanel`）
7. 本社下書きと支社下書きは `record.hqKind` で共存できる（同じ日付・同じ弾でも上書きしない）

画面から投稿はしない。キューへ入れるだけ。巡回は後段。

---

## 隔離のやり方

汚れた作業ツリーを commit せず、git の配管だけ使った。

- `GIT_INDEX_FILE` に別インデックス
- `read-tree origin/main`
- この機能のファイルだけ `hash-object` → インデックスへ
- `commit-tree` で `feat/x-compose-store-box` を切る

入れたファイルは 17:

- `docs/assumptions.md`
- `test_product_master_single_place.py`
- `web/app/admin/nav-cleanup.test.mjs`
- `web/app/admin/page.js`
- `web/app/admin/x-next-panel.js`
- `web/app/admin/x-queue-panel.js`
- `web/app/api/admin/x-next/route.js`
- `web/app/api/admin/x-queue/route.js`
- `web/app/globals.css`（`.xn-modes` / `.xn-mode` だけ）
- `web/app/lib/box-digest.mjs`
- `web/app/lib/box-digest.test.mjs`
- `web/app/lib/x-digest-text.mjs`
- `web/app/lib/x-digest-text.test.mjs`
- `web/app/lib/x-next-slots.mjs`
- `web/app/lib/x-next-slots.test.mjs`
- `web/app/lib/x-preview-images.mjs`
- `web/app/x-next.test.mjs`

入れていない: `build_data.py`、商品マスタ、公開 `page.js`、Pro モーダル用 CSS、その他の dirty ファイル。

---

## 採用した設計

- 本社判定はゴールデンデータの完全一致だけ。接頭辞や店名の推測は足さない
- 画面に「ゴールデンデータ」という説明は出さない。ボタンは本社／支社／両方
- ボックス別まとめは既存 Discord 用組み立てを再利用し、X 用は分割しない
- 弾の判定は正本（`set-names.mjs` の `setsForProduct` / `setMatch`）を呼ぶだけ
- ラチェット `test_product_master_single_place.py` に呼び出し側を ALLOWED_JS / CALLERS_JS として書いた（2本目の commit）

仮定: `docs/assumptions.md`「投稿を作る・支店とボックス別（2026-09-16）」

---

## CI（PR 固有の赤）

Vercel Preview: **pass**

Node（build run 35064361123）: 3993 件 / 3957 緑 / **fail 36**。merged #1588 は 3989/3953/fail 36。増えた 4 件は緑。**fail 集合は同じ → 枝固有 0**

Python:

| | tests | fail |
| --- | --- | --- |
| main 基準 run 35039004075 | 8688 | 9 |
| PR 1回目 | 8702 | 11（うち `test_JSで弾を判定する場所が増えていない` が枝固有） |
| PR 2回目 run 35064361140（allowlist 後） | 8702 | 10 |

2回目の FAIL 名（ユニーク）は main と **同じ 10 名前**。件数 +1 は `test_official_site_watch` の subTest（エディオン／ポケモンカードストア）で、実データの揺れ。x-compose のファイル由来ではない。

ラチェットは allowlist 後に消えた。**PR 固有の赤は 0**。

---

## デプロイ

```
gh workflow run deploy --ref main
```

run 35066054678 / job trigger **success** / headSha `ab99b00767adcd0d49c924ebb4826485eb8b9802`

Vercel Deploy Hook へ POST しただけ。ログに URL は出していない。

---

## 手元で動かしていないもの

- dirty 作業ツリーの commit / checkout
- `feat/x-compose-branch-box` への作業
- X 実投稿
- Discord 実送信
- 本番 DB
- 有料 AI
- 次のプロダクトフェーズ

---

## 未完了

- 本番 admin の画面をブラウザで踏んで「支店ごとに／ボックス別まとめ」が出ることの目視は、この報告の時点では未実施（Deploy Hook 成功まで）
- dirty ツリー側の別作業はそのまま残っている

---

## 次

指定された「投稿を作る」の完了点。次フェーズは自動では始めない。
