# 同じ回の【Aグループ】【Bグループ】を別の鍵にする

## 指示

health-watch の「同じ鍵に別表記の商品が同居しています（要確認）11組」（https://github.com/shinonomeheta-ai/cardbot/actions/runs/36222793706）を見て、11組を1つずつ確かめた。

- 10組は同じ商品の書き方違い（遊戯王 ORIGINAL ARTWORK COLLECTION 7組・30th プレミアムデッキセット・Heroines Edition・まどか☆マギカ）。問題なし
- 1組（イエローサブマリン 30th CELEBRATION【Aグループ】／【Bグループ】）は商品も締切（8/30 20:00）も同じで、当選発表の日（9/15・9/21）だけ違う別の抽選。同じ鍵なので、片方の応募済み・当落がもう片方にも付く

本人 2026-09-26:

> AとB分けた方がいいと思うけど、普通に。

## PR

https://github.com/shinonomeheta-ai/cardbot/pull/1686 （ブランチ `lot-key-group`）

- `lot_key.py` の `group_suffix`・`web/app/lib/lot-key.mjs` の `groupSuffix`: 商品名の「◯グループ」（◯は英数字1〜2文字で、前が英数字でない）を拾い、鍵の末尾に `~g:◯` を足す。括弧を落とす前の名前で探す（落とすと「CELEBRATION【A」が続いて「celebrationa」になる。1回目はこれで外した）
- グループの書いていない商品は鍵が変わらない。実データで鍵が変わるのは A・B の2行だけ。警告は 11組 → 10組
- グループの前の鍵（`pre_group_lot_key`・`preGroupLotKey`）も読む
  - 既読（新着の判定）: `seen_before`・`notify_new_lotteries.legacy_keys`。既読台帳に前の鍵（`…~本体`）があるので、A・B が新着として流れない
  - 応募済み・当落・メモ（画面）: `allKeysOf`・`materializeLegacy(Map)`。今日までの印は A・B の両方に付いて見え（直す前の見え方のまま。どちらのつもりだったかは分からない）、押すとそれぞれの鍵へ移る
  - `v2_intake` の別名の鍵・`current_records` の直し
- 収集 v2（card-crolling）はこの鍵を使っていない

## 確かめたこと（手元）
- `python -m unittest test_lot_key`: 41件 OK（新規3件。実データで Python と画面の鍵が1文字も食い違わない試験を含む）
- `node --test web/app/lib/lot-key.test.mjs`: 28件 OK（新規2件）
- `node --test app`: 失敗 40件（main と同じ）
