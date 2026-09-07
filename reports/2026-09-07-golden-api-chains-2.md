# 一覧に受付中の回（open_rounds）を載せる — #1418 の続報（-2）

セッション名: api-customer
日付: 2026-09-07（JST）
区切り/依頼名: 「どのボックスが受付中か分からない」への対応
対象: `feat/golden-api`（head `d7c89cf8`・PR #1418）

前便: https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-golden-api-chains.md
（前便の末尾に同じ内容を追記してしまったが、「報告は追記禁止・続報は新ファイル」のルールに従い、ここに切り出す）

## 本人指摘「どのボックスが受付中か分からない」→ 一覧に受付中の回を載せた

> ゴールデンデータ受付中出してくれてるの嬉しいんだけど、ボックスごとにかわかんないから、どのボックスが受付中なのかわかんなくない？これ。

一覧は `open_count`（数）しか持たず、商品名は1件の口を開かないと見えなかった。親の欄に
**`open_rounds`**（受付中の回・締切の近い順・`{id, product, apply_end, store}`）を足した（d7c89cf8）。
`id` は `/api/v1/lotteries/{id}` と同じ安定ID。本部の企画で畳んだ回は `venues[0]` から採る
（畳んだ締切で採ると個別ページと別IDになる）。Amazon（always_open）は空のまま。OpenAPI・docs・試験3件。

preview の実測（受付中 10 社・回 16 件）:

```
フルコンプ            9/8  30th CELEBRATION 1BOX ／ プレミアムデッキセット（9店）
ポケモンカードストア    9/8  30th CELEBRATION（10パックまで）／ 30th CELEBRATION
晴れる屋2 通販        9/7  30th CELEBRATION ／ プレミアムデッキセット
晴れる屋2 各店        9/12 30th CELEBRATION ／ プレミアムデッキセット
ドラゴンスター各店     9/9  30th CELEBRATION 1BOX ／ プレミアムデッキセット（モバイル会員限定）
KIDDY LAND 大阪梅田店  9/7  ストームエメラルダ
コジマ（アプリ）       9/13 プレミアムデッキセット
ファミマオンライン     9/10 30th CELEBRATION BOX
WonderGOO・新星堂・Ganryu 9/7 30th CELEBRATION
GIRAFULL 各店         9/7  30th CELEBRATION ／ プレミアムデッキセット
Amazon                常設  回は出さない
```

CI 3回目（head d7c89cf8）: build は main と同じ2件だけ赤（e2e 重複・review-grid P0）、Python は同じ5件。**PR 固有の赤 0**。
表ページ（`D:/cardbot/shots/golden-54-and-active-stores.html`）は表1に「受付中の商品（締切 / 商品 / 応募先）」列を足して作り直した。

マージは本人操作待ちのまま。
