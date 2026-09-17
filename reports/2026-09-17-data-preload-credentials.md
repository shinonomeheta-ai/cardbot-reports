# コンソールの警告2件（PR #1612）— 公開JSONを毎回2回取っていた

本人報告 2026-09-17（実機のコンソールの写真）。

## 1. 先読みが使われていない（4本すべて）

    A preload for 'https://torecanavi.app/data/latest.json' is found,
    but is not used because the request credentials mode does not match.

`lotteries` / `latest` / `golden_chains` / `lottery_stores` の4本で出ていた。
見た目は地味だが、中身は「**1.4MBの抽選台帳を毎回2回取っている**」。

### 食い違いの正体

`crossorigin="anonymous"` の preload は credentials mode が **same-origin**
であって omit ではない（CORS設定属性の対応）。取りに行く側の `getJSON` が
`credentials: "omit"` を渡していたので食い違い、先読みは捨てられていた。

**本番で実測**（Chrome・`performance.getEntriesByName(url).length`）:

| preload | fetch | 取りに行った回数 |
| --- | --- | --- |
| anonymous | `credentials: "omit"` | **2回** ← 踏んでいた |
| anonymous | 既定（same-origin） | **1回** ← これにする |
| なし | `credentials: "omit"` | 2回 |
| なし | 既定 | 2回 |

実際のトップでも、4本すべてが2回以上取られていた（`link` と `fetch` の2本ずつ。
`golden_chains` と `lotteries` は Service Worker のぶんを含めて4本）。

### 本題は「思い込みが3か所に写っていた」こと

先読みを足した回の注釈が「credentials は preload（anonymous）と揃える」と書き、
`home-weight.test.mjs` の assert が **`credentials: "omit"` であることを求めて**
いた。つまり**試験が間違いのほうを守っていた**ので、直すと赤くなる形だった。
実測で確かめてから、注釈・コード・試験の3つとも入れ替えた。

## 2. 非推奨の meta

`<meta name="apple-mobile-web-app-capable">` は Chrome が非推奨とする。
標準名の `mobile-web-app-capable` を `other` から並べて出した。
iOS は古い名前しか見ないので、**外さずに両方**置く。

## 3. 「preloaded but not used within a few seconds」（32件）

これは上の2件と同じ根（使われなかった先読みが期限切れになった、の再掲）。
1 を直せば消える見込み。残るようなら別途見る。

## 試験

* `node --test web/app/data-preload.test.mjs` → **5件 OK**（新規）
* `cd web && node --test app` → 落ちた38件は枝分かれ元 `5dfb1cd1e` と**完全一致（差分0）**
* `npx next build` 成功

## 残っていること

* PR #1612 はマージ待ち
* 効果の確かめ方: 本番で `performance.getEntriesByName(location.origin+"/data/lotteries.json").length`
  が **2 → 1** になること
