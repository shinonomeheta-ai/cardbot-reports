# LivePocket の本文を Vercel から読む（設計）

2026-09-07 ／ ci

`docs/vercel-read-lane.md`（#1384・x-intake）の型をそのまま写す。**新しい判断は
最小限**にして、あちらで決まっていることは決まったまま使う。

---

## 1. なぜ要るか（実測）

共有基盤の応募ページは runner から読めない。

    url          https://livepocket.jp/e/s8qt1
    fetch_status bot_challenge
    fail_streak  2
    last_error   本文を根拠として読めません: bot_challenge

`shadow_candidate_evidence_cache.json` に LivePocket の source が **37件**あり、
`fetch_status: ok` の数件も中身は `.turbo-progress-bar { position: fixed; … }` という
**JS のローダーだけ**で本文ではない。

本文が無いと V4（応募ページの本文取得）が抜粋を作れず、AI へ送れない。実際に
**キデイランド原宿店（9/8 23:58 締切）は `ai_not_run` で配布に出ていない**。
自己申告の登録（A-2・#1374）で応募URLを配る権限までは通ったのに、本文の1点で
止まっている。

    self_identified_ok        True
    tenant_allows             True
    source_kind               official_platform
    is_official_source        True
    excerpt                   0字   ← ここだけ

LivePocket は共有基盤の登録10件が使っている。**基盤ごと解ける投資**になる。

x-intake の測定（`2026-09-07-shared-platforms-via-vercel.md`）:

  * **LivePocket は Vercel から読める**（27回連続・検査0件）
  * 1ページ **3,630〜12,028字**で 32KB に収まる
  * e-starbox は **runner から読める**ので Vercel は要らない
  * Google フォーム・customform は JS 描画の別課題

---

## 2. 決めたこと（本人指定・そのまま）

| | |
| --- | --- |
| 許可表 | **`livepocket.jp` だけ**で始める |
| 運ぶもの | **本文を 32KB に切り詰めて運ぶ**（案②）。抽出は Python の1か所に残す |
| KV | xread と同じ **`HSET` ＋ `EXPIRE`** |
| runner | `build_evidence_cache` が KV から本文を受け取る |

案①（Vercel 側で値を抜く）を採らない理由は #1384 のとおり。抽出の規則が JS 側にも
住むと二重管理になる。**今日1日で6回踏んだ「同じ規則を2か所に置いてずれる」型**を
増やさない。

---

## 3. 作り

```
runner（配る役）  取りたいURLの一覧を KV へ置く        SET lpread:urls
      ↓
Vercel（読む役）  一覧を取る → 許可表で濾す → 外へHTTP
                  → 可読テキストへ → 32KB で切る → KV へ置く   HSET lpread:page
      ↓
runner（取る役）  KV から本文を貰う → 今までどおり抜粋を作る
```

### 部品

| ファイル | 役 | 元にするもの |
| --- | --- | --- |
| `web/app/api/lpread/route.js` | 入口。`CRON_SECRET` の検査・`maxDuration` | `api/xread/route.js` |
| `web/app/api/watch/lpread.mjs` | 本体。許可表・かたまりの取り合い・切り詰め・KV書き込み | `watch/xread.mjs` |
| `web/vercel.json` の `crons` | 決まった間隔で叩く | 同上 |
| `lp_read_kv.py` | runner 側。一覧を配る・本文を取る | `x_read_kv.py` |
| `candidate_evidence_fetch.py` | **KV に本文があればそれを使う** | 既存に足す |

`x_read_kv.py` の `_kv`（Upstash REST の口・秘密をログに出さない）と、
`xread.mjs` の窓・取り合い・持ち時間・`HSET`＋`EXPIRE` は**そのまま写す**。

### KV の鍵

    lpread:urls           SET     runner が配る。取りたいURLの一覧（JSON配列）
    lpread:page           HSET    欄 = URL の SHA-256 先頭16桁 → {url, text, at, status}
                          EXPIRE  6時間（材料の寿命は runner 側で4時間として見る）
    lpread:lock:<n>       SET NX EX 30分   かたまりの取り合い

**全体を読んで書き直す形にしない**（#1384 の決めごと4・「台帳1MB超で下書きが
消えた」の再発防止）。

---

## 4. 危ないところ: URL を外から受け取る

読む役は**本番と同じIPから外へ出る**ので、汚れた入力がそのまま外向きの行動になる。
#1384 の (b) をそのまま守る。

```js
// web/app/api/watch/lpread.mjs
const 許可ホスト = new Set(['livepocket.jp'])   // ← KV から来た値で決めない
```

  * 許可表は **Vercel のコード側**に持つ。KV の中身では決めない
  * 許可表の外は**取りに行かずに捨てる**。捨てた件数をログに出す
  * **リダイレクトの追随も許可表の中だけ**
  * 試験で「許可表の外のURLを渡したら1回も叩かない」を固定する

`www.livepocket.jp` は許可表に入れる（`host === m || host.endsWith('.' + m)`）。
`livepocket.jp.example.com` は入らないこと（後方一致だけにしない）を試験で押さえる。

---

## 5. runner 側の受け取り

いま本文を取るのは `candidate_evidence_fetch.fetch(url, …)` の1か所で、
`build_evidence_cache._取る()` がそこを呼ぶ。**足すのはこの1か所だけ。**

```python
def fetch(url, opener=None, resolve=None, timeout=TIMEOUT, kv=None):
    """1本だけ取る。返り値は `(text, status, content_type)`。

    **共有基盤は KV に本文があればそれを使う**（2026-09-07）。
    runner から取ると bot_challenge で返るホストがあるので、
    Vercel が読んだ本文を材料として受け取る。無ければ今までどおり自分で取る。
    """
    got = (kv or LP.本文)(url)          # 無ければ None
    if got is not None:
        return got, 200, "text/html"
    …これまでどおり…
```

  * **KV が無ければ何もしない。読めなければ今までの経路へ落ちる**（#1384 の決めごと7）。
    読む役が止まっても巡回は続く。**戻し道を残す**
  * 材料には時刻を入れ、**4時間より古いものは使わない**（決めごと6）。
    古い材料を使うと「読めているつもり」で塞がれたことに気づけない
  * どの経路で取れたかを数える。通過率 V4 の `extra` に `route:kv` / `route:direct` と、
    KV から取れなかったホストの名前（最大50）

一覧を配るのは `build_evidence_cache` の**取りに行く前**。
`固有の根拠()` が既に「取りに行くURL」を組み立てているので、そのうち
**許可ホストのぶんだけ** `lpread:urls` へ置く。二重管理にしない
（**対象の一覧は runner が正本**・決めごと5）。

---

## 6. 段取り

1. 枝を切る。`lp_read_kv.py` ＋ `lpread.mjs` ＋ `route.js` ＋ 試験
2. `candidate_evidence_fetch.fetch` に KV の口を足す（既定は今までどおり）
3. `build_evidence_cache` が一覧を配る
4. `vercel.json` に cron を足す（**窓の外は数msで返る**作りにしてから）
5. `official-x-intake` と同じく、`candidate-ai-review` の
   `evidence_cache` 段へ `KV_REST_API_URL` / `_TOKEN` を渡す
6. マージ → `evidence_cache` を回す → 原宿店の抜粋が作られるか見る
7. AI（Haiku 3段）を原宿店1件で回す → 配布に出るか

**測定は済んでいる**（x-intake が 27回連続・検査0件）ので、診断ルートの段は飛ばす。

---

## 7. 今日の締切に間に合うか

キデイランド原宿店は **9/8 23:58 締切**。

    今日  設計 → 実装 → マージ
    明日朝の巡回で evidence_cache → 抜粋
    そのあと AI を1件回す（$0.02 程度）→ 配布

間に合う見込みはあるが、**AI の1件は手で回す**必要がある（定期の candidate-ai を
待つと間に合わないかもしれない）。承認済みの範囲で回す。

---

## 8. やらないこと

  * Google フォーム・customform（JS 描画の別課題）
  * e-starbox（**runner から読める**。取れていないのは経路ではなく、
    呼んでいないか判定で落としている。別途確認する）
  * 許可表を増やすこと（`livepocket.jp` だけで数日見てから）
  * Vercel 側で値を抜くこと（案①・二重管理になる）

---

## 9. 気をつけること（#1384 の (e)）

  * **Vercel も塞がれうる。** `route:*` を数えておけば数字で分かる
  * **叩きすぎると Vercel でも検査が始まる。** 少ない回数から始めて数日見る
  * **`vercel.json` を触るなら `ignoreCommand` に注意**（`:/` 付きのパス）
  * Vercel の cron を増やすと、その口も叩かれる。**窓の外で数msで返る**作りにする
