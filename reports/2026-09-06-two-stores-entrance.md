# 取得の入口に立っていない2店 — Hobby Zone とイオンスタイルオンライン

セッション名: store-name-a
日付: 2026-09-06（JST）
区切り/依頼名: 入口に立っていない2店の登録
対象: `origin/main` = `5945def2`

## 受けた指示（原文）

> 正解表の20店のうち、取得の入口に立っていない2店。今すぐ。
> ## Hobby Zone
> 公式サイト（hobbyzone.jp か何か）と公式X が実在するか。
> 実在すれば store_sites / store_x_accounts に登録。本人性は公式サイトの自己言及で。
> 登録したら ci の S2b で取れるようになる。
> ## イオンスタイルオンライン
> aeonretail.com が SSL 失敗・403 で読めない。
> Vercel の関数（x-intake が作った xread と同じ経路）から読めるか試す。
> runner の IP が塞がれているなら、Vercel からなら読める可能性がある。

## 指示と過去の報告の食い違い

**2点あります。どちらも前提が実測と違いました。**

### ① Hobby Zone は**すでに入口に立っています**

```
公式サイト   https://hobby-zone.net/        登録済み
公式X       @hobby_zone_web                登録済み
EC巡回      https://www.hobby-zone.net/information/ と /news/  登録済み
```

サイトは**読めます**（トップ・お知らせ・新着とも 200／`title` は
「HobbyZone - ホビーゾーン」）。`linked_page_cache.json` にも
`https://www.hobby-zone.net/information/page/2/` が **`fetch_status: "ok"`**（2026-08-31）で
残っていました。**登録するものはありません。**

**ただし1点、気になることがあります。** 公式サイト（トップ・`/information/`・`/news/`）を
読んでも、**X へのリンクが1件もありません**。登録済みの `@hobby_zone_web` は、
私の基準（＝店の公式サイトが張っているか）では**本人性の根拠が取れていません**。
誰がどう入れたかは追っていません。**触っていません**が、報告します。

### ② イオンスタイルオンラインは **Vercel を使わずに開きました**

原因は IP ではなく、**登録してある URL のホストが違う**ことでした。

---

## イオンスタイルオンライン — 何が起きていたか

```
www.aeonretail.com   TLS のハンドシェイクで落ちる（curl も Python も
                     sslv3 alert handshake failure）           → URLError
aeonretail.com       403                                        → Cloudflare のボット検査
```

`store_sites.json` に登録してあったのは **www 付き**のほうでした。

`url_quality` の「国外から届かないので東京から取り直す」フォールバックは
**`timed_out` のときだけ**発火します。`URLError` は timeout ではないので**発火しません**。
`linked_page_cache.json` にも `fetch_status: error / last_error: URLError` が残っていました。

### www 無しなら、ブラウザ経路で開きます

403 は `url_quality` の「HTTP {code} なのでブラウザで開いて読む」分岐に入り、
`render_text`（本物のブラウザ）へ進みます。**実測で通りました。**

```
https://aeonretail.com/                     render_text 7,942字  「イオンスタイルオンライン …」
https://aeonretail.com/Page/News/List.aspx   render_text 7,930字  「お知らせ一覧 | …」
```

403 の中身は Cloudflare のボット検査でした（`window._cf_chl_opt`・「アクセス確認」・
"Enable JavaScript and cookies to continue"）。**素の GET では絶対に通りません**が、
**ブラウザ経路なら通ります**。

### なので Vercel は使いませんでした

ご提案の経路（`/api/fetch-jp`。Vercel の東京リージョンに固定された取得の口）は
既にあります。ただし今回は**その手前で解決した**ので使っていません。
（`FETCH_RUNNER_TOKEN` は私の手元に無いので、そもそも叩けませんでした。
必要になったら x-intake か本人の手が要ります。）

### 直したもの → PR #1365（1行）

```
store_sites.json
   イオンスタイルオンライン: https://www.aeonretail.com/ → https://aeonretail.com/
```

### 触っていないもの

`ec_lottery_sources.json` の `k-lottery_sale.aspx` は**そのまま**にしました。
ブラウザで開くと**「エラー」ページ**が返ります（お知らせ一覧は読めます）。
落とすか置き換えるかは人の判断です。

---

## 判断していただきたいこと

1. **PR #1365 をマージするか。**
2. **`@hobby_zone_web` の本人性** — 公式サイトが張っていません。このまま置くか、
   確かめ直すか、`_no_official_x` の形にするか。
3. **`k-lottery_sale.aspx`**（エラーページを返す）を EC巡回の一覧から落とすか。

## 状態

- Hobby Zone は**登録するものがありませんでした**（既に3つとも登録済み・読める）。
- イオンスタイルオンラインは **1行の修正**（PR #1365）。マージはしていません。
- **Vercel の関数は使っていません**（手前で解決したため）。
- 外部への通信は読み取りだけ。課金はありません。
