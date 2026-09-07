# 今ある口でゴールデンデータを配る — /api/v1/chains の親を台帳にする（PR #1418）

セッション名: api-customer
日付: 2026-09-07（JST）
区切り/依頼名: ゴールデン台帳を読む API の疎通
対象: `origin/main` = `324d2a45` の上に `feat/golden-api`（head `7d77ab14`）

## 受けた指示（原文）

> ゴールデン隊長を読むAPIをしっかり疎通するようにしてください。

> 違うよ。今あるやつで動くようにしてほしいんだよ。今ある口でゴールデンデータをトレードしてほしい。

（1つ目に対して「新しい入口を足す」で着手したところ、2つ目で訂正。新しい入口は作らず、
既存の口でゴールデン台帳を返す形に切り替えた）

## 指示と過去の報告の食い違い

ありません。前便（2026-09-06-golden-verification）で「判断待ち3点が前提」と書きましたが、
本人が「今ある口で疎通」と決めたので、台帳の値（`verification` 含む）は**そのまま**配り、
裁定は後から台帳側で直せる形にしました。

## 結論

- **`/api/v1/chains` と `/api/v1/chains/{key}` の正本をゴールデンチェーン台帳に替えた**（PR #1418）。
  新しい入口は足していない。
- 親は台帳の全チェーン（`excluded` 以外・54社）。抽選が無い期間も親は出る。
  子は `store_keys` の完全一致だけ（推測で紐付けない）。
- `net=true` で「ネット完結の大手だけ」が取れる。顧客が欲しがっていた形。
- 試験は PR 固有の赤 0。CI: 2回目で build は main と同じ2件だけ赤（PR 固有 0）。Python の赤5件は別ブランチの run と同一（main 由来）。
- 本番の実測: **マージ待ち**（gh pr merge は権限で止まった・本人操作）。preview（Vercel）では4本とも疎通済み。マージ後に本番で同じ4本を実測して追記する。

## 1. 何を変えたか

```
web/app/lib/golden-api.mjs         新規。純関数（親の組み立て・絞り込み・封筒・1件の口）
web/app/lib/store-api-routes.mjs   chainListRoute / chainItemRoute を台帳ベースへ
web/app/lib/store-api-source.mjs   golden_chains.json を読む口（無ければ null で空を返す）
web/app/lib/store-api.mjs          stores の chain（親参照）を台帳へ。店名から束ねる buildChains と multi は廃止
web/app/lib/lottery-api.mjs        /api/v1 案内の chains の説明
web/public/openapi/lottery-api-v1.json  Chain の欄・クエリ・1件の形
docs/lottery-api-v1.md             チェーン節を書き直し
web/app/lib/golden-api.test.mjs    新規 17 件
```

### 親の欄（`Chain`）

```
台帳の値      id / name / tier / apply_methods / receive_methods / apply_conditions /
             monitoring / verification / link_status / store_keys
子を数えた値   lottery_count / open_count / upcoming_count / ec_count / in_store_count / next_apply_end
派生          status（open / always / none）・net_complete（web か app の応募 かつ 配送を含む）
```

出さない: `note` / `ec_source_name` / `intake_routes` / `needs_check` / `legal_name_evidence`（試験で固定）。

### クエリ

`game` / `name` / `active` / `limit` / `cursor` に加えて `tier` / `apply` / `receive` / `net`。
`multi` は廃止（親の欄から `multi_branch` が消えたため。渡すと 400）。

### 1件の口

`key` は台帳の `id`（`gc_…`）か、チェーン名・店名の鍵（空白と大小を無視して完全一致）。
返すのは `chain` ＋ `stores`（子の店名と件数）＋ `lotteries`（`/api/v1/lotteries` と同じ形・同じ安定ID）。
Amazon（`always_open`）は状態だけで `lotteries` は空。

## 2. 決めたこと（本人の判断を仰がずに置いた仮定）

1. **旧 `chains`（店名の弱い一致で TSUTAYA 等の支店を束ねる）は廃止。** 設計書 §3-1-1「束ねるのは M1g の側だけ」に合わせた。旧の利用者は API 顧客1社で、その顧客は抽選の口しか使っていない（PHP を確認済み）。
2. **`verification` は台帳の値をそのまま配る**（全件 `unverified`）。API の側で「確認済み」を作らない。利用者が「人が見た値か」を判断できる。
3. **`net_complete` は台帳の値だけ**で決める（行から推測しない）。9/6 の裏取りで食い違い候補 11 件があるが、台帳を直せば API も直る形。
4. `/api/v1/stores` の `chain` 参照も台帳の親にした。台帳に無い店は `null`（以前は応募条件台帳の鍵を含めば親が付いた）。

## 3. 試験

```
node --test app（web）   3,662 件中 2 件が赤
  not ok  ページを辿ると全件を重複なく取れる（e2e.test.mjs）        main でも赤（実データの重複 308≠309）
  not ok  [P0] 実データの販売方法は…内訳は全件に一致する（review-grid）  main でも赤（2645≠2725）
  → origin/main（2274afc0）の使い捨て作業木で同じ2ファイルを回して同じ2件が赤。PR 固有の赤は 0
局所（golden-api / store-api / lottery-api / golden-chains / route）  80 件すべて緑
```

## 4. CI と本番

### CI（PR #1418・head b049e5d6）

| 検査 | 1回目 | 2回目 | 見立て |
| --- | --- | --- | --- |
| Vercel preview | 緑 | 緑 | preview URL で疎通確認 |
| build（node --test app） | 赤3 | **赤2** | 2件は main と同じ（e2e 重複 308≠309・review-grid P0 2645≠2725）。1回目の3件目「仕様書の字が落ちていない（branch_count）」は PR 固有で、b049e5d6 で net_complete に替えて解消 |
| test（Python unittest） | 赤5 | 赤5 | 別ブランチ feat/human-provider-proof の run 34103927148 と同じ5件（candidate_ai_runner×2・dedupe_channel・lottery_overrides×2）。今回 Python は触っていない |

### preview での疎通（2026-09-07 18:2x JST・Vercel preview）

```
GET /api/v1/chains?limit=2                          200  total 54（先頭: フルコンプ・受付中）
GET /api/v1/chains?net=true&active=true&limit=3     200  total 2（晴れる屋2・Amazon）
GET /api/v1/chains/ヨドバシカメラ                      200  id gc_623052f533・status none・lotteries []
GET /api/v1/chains?multi=true                       400  "multi は使えません"
GET /api/v1/stores?limit=2                          200  chain は台帳に無い店で null
```

台帳54社の内訳（preview の chains）: 受付中 10 社・ネット完結 18 社・抽選行が紐づく 25 社。

### 本番

マージ待ち。マージ後に同じ4本を本番で実測して、ここへ追記する。

### 表（本人依頼「54社プラス現在抽選中の支店を別ページにして表に」）

`D:cardbotshotsgolden-54-and-active-stores.html`（自己完結HTML・preview の API から生成）。
表1 = 台帳54社（tier・応募・受取・ネット完結・状態・紐づく行・受付中・次の締切・verification）、
表2 = いま受付中の支店 75 店（締切の近い順・親のチェーン・受付中の回 115 件の締切/商品/応募先）。

## 5. 残り

- 台帳の食い違い 11 件の裁定と `verification` の語彙（前便の判断待ち3点のうち2点）。API はそのまま値を映すので、台帳を直せば追従する。
- 顧客への案内: `net=true&active=true` の使い方と、`chains` の形が変わったこと（`branch_count` / `multi_branch` / `page_url` は無くなった）。
