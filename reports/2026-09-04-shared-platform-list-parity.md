# 共有基盤の一覧のずれを直す ＋ まとめ一覧に無い記事形式ホストの棚卸し

日付: 2026-09-04（JST）
区切り/依頼名: CI費用の削減 1（常駐赤の解消・続き）

根拠データ:
- [2026-09-04-rule-drift.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-04-rule-drift.json)（ホストごとの Python/JS の答え）
- [2026-09-04-announce-hosts.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-04-announce-hosts.json)（未登録で `announcement` 扱いのホスト39件・抜粋の混入）

## 受けた指示（原文・要点）

> ## 共有基盤の一覧のずれ
> 全件実行が終わって PR 固有の赤が無ければ、マージしてください。
>
> ## test_candidate_ai_runner の赤
> 報告に「まとめ一覧に入っていないホストが他にもないか」を追記できますか。
> 記事形式のホストで、いま announcement 扱いになっているものの一覧です。
> 調査だけで、追加はしないでください。

## 1. #1278（案A）マージ済み

`d9e86103`。CI の本物の赤は **5件 → 4件**。
`test_共有基盤のokは登録済みの店だけ` は CI 上でも消えました。

## 2. 共有基盤の一覧のずれ — PR [#1281](https://github.com/shinonomeheta-ai/cardbot/pull/1281) マージ済み（`d572c23c`）

CI の実測: `test` は `FAILED (failures=4)` で、**main と同じ4件だけ**
（`test_candidate_ai_runner` ×1 ＋ `test_lottery_overrides` ×3）。
**PR 固有の赤はゼロ。**

`build` も赤でしたが、中身は `lotteries/e2e.test.mjs` の1件（290≠292）だけで、
**同時期の他ブランチ（`fix/unify-store-lookup-key` / `fix/intake-outage-alert` /
`fix/intake-coverage`）でも同じく失敗**しており、無改変の `d9e86103` でも再現します。
main 由来です。

### 直したもの

| ホスト | Python | JS | 経緯 |
| --- | :---: | :---: | --- |
| `membercard.jp` | ✓ | **無し→追加** | 2026-08-16 に Python へ追加（誤 `ok` の後始末） |
| `hopapp.jp` | ✓ | **無し→追加** | 同上 |
| `customform.jp` | ✓ | **無し→追加** | 2026-08-17 に Python へ追加（同上） |
| `myshopify.com` | **無し→追加** | ✓ | Python は `ORIGIN_OK` にだけ持っていた |

`myshopify.com` は、兄弟の `thebase.in` / `stores.jp` / `base.ec` が
`PLATFORMS` と `ORIGIN_OK` の**両方**に入っているので、ここだけ抜けているのは
写し忘れと判断しました。

### 突き合わせ試験4本（こちらが本体）

- `test_一覧が完全に一致する` … 正規表現の**字面から一覧そのものを取り出して**
  集合で比べる。走らせて比べるだけだと、試すホストを人が別に書くことになり、
  **片方にしか無いホストに気づけない**
- `test_一覧が空でない` … 取り出しに失敗して「空集合どうしが一致」で通らないこと
- `test_答えも一致する` … node を走らせて `isSharedPlatform()` の答えを比べる。
  字面が同じでも正規表現の組み方が違えば答えは変わりうる
  （`shop.` 付き・`.evil.com` 付き・前置きありも試す）
- `test_ORIGIN_OKは別の表` … `PLATFORMS`（明示登録を求める）と
  `ORIGIN_OK`（オリジン配下をまとめて許す）の役割の違い。**同じ表にはできない**

### 試験が本当に効くかの確認

わざと JS から `membercard.jp` を1つ外したところ、**2本が発火してホスト名まで指しました。**

```
FAIL: test_一覧が完全に一致する
  共有基盤の一覧がずれている。Pythonにだけ: ['membercard.jp'] ／ JSにだけ: なし
FAIL: test_答えも一致する
  AssertionError: True != False : 'membercard.jp' の答えが Python と JS で違う
```

戻すと緑。

### 実測

- `test_shared_platform_gate` … 56件すべて緑
- 全件（CIと同じ）… 7186件・赤16件で、**直前の実測と同一の顔ぶれ**（新規なし）
- `node --test app` … `lotteries/e2e.test.mjs` の1件が赤だが、
  **無改変の `d9e86103` でも同じ赤**（290≠292）。この変更とは無関係
- pyflakes … 0（`date_source.py:907 global _DEAD` は main の既存）

## 3. まとめ一覧に入っていない記事形式ホスト（調査のみ・追加はしていない）

台帳の全 evidence をホストごとに数え、**まとめ一覧（`source_names.json` の
`hosts`）に入っていないのに `page_role = announcement` を持つホスト**を洗いました。

| | 件数 |
| --- | ---: |
| 未登録で `announcement` を持つホスト | **39** |
| うち ブログ基盤（`blog.jp` / `hatenablog.com` など） | 1 |
| うち 記事パス（`/archives/` `/articles/` `/entry/`） | 4 |
| うち 2店以上に付いている | 12 |
| **うち 2店以上かつ記事形式** | **1** |

### 該当は `rare-zaiko.blog.jp` の1件だけ

```
rare-zaiko.blog.jp    announcement 5件 / 4店
  https://rare-zaiko.blog.jp/archives/31035617.html
```

**まとめ一覧の抜けは、この1件に絞られます。**

### 記事パスの残り3件は、いずれも1店

| ホスト | 店数 | 見本 |
| --- | ---: | --- |
| `tsutaya.tsite.jp` | 1 | `/articles/trading-card-4582` |
| `limited.yodobashi.com` | 1 | `/entry/shared` |
| `help.7net.omni7.jp` | 1 | `/hc/ja/articles/...抽選販売予定-ポケモンカード` |

いずれも**小売自身の告知ページ**で、記事の形をしているだけです。
まとめではないので、一覧へ入れるべきではありません。

### 2店以上の残り11件も、まとめではない

```
x.com                       1044件 / 512店   ← SNS
livepocket.jp                  4件 /  47店   ← 共有基盤
c-labo.jp                     31件 /  12店   ← チェーンの支店
otakarasouko.com               6件 /   4店   ← 同上
cloud-pass.jp                  2件 /   4店   ← 共有基盤
magi.camp                      8件 /   3店
shop.pokemon.co.jp             7件 /   3店
yamada-denki.jp                1件 /   3店   ← チェーン
ryuunoshippo.membercard.jp     6件 /   2店   ← 共有基盤のテナント
iyec.itoyokado.co.jp           2件 /   2店
biccamera.com                  2件 /   2店
```

SNS・共有基盤・チェーンの支店なので、複数店に付くのが正常です。

### 実害の測定: 抜粋に他店名が残っている応募回は台帳全体で1件

```
Joshin   ← 「ローソン」が抜粋に残っている
   根拠: rare-zaiko.blog.jp, rebates.jp, shop.joshin.co.jp, x.com
```

抜粋は103文字で、複数店が並ぶ表の一部でした。

```
Joshin / 8月27日(木)23:59まで / アプリ抽選 / 9月1日(火) /
シルバースマイル会員以上が対象 / / 全国 / ローソン / / 先着 / ...
```

**`test_candidate_ai_runner.test_実データの抜粋が店ごとに分かれている` の
赤は、この1件だけが原因です。**

### 判断が要ること（roundup セッションと重なる）

`rare-zaiko.blog.jp` をまとめ一覧へ足すかどうかは、まとめの扱い全体
（発見と値の分離）の判断になるので、**私からは足しません**。

足した場合に起きることだけ書いておきます。

- `page_role` が `summary` になり、**抜粋がAIへ渡らなくなる**
  → `test_candidate_ai_runner` の赤は消える
- `publish_reviewed_only` の「まとめだけの根拠は配らない」関門にかかるので、
  **この5件が唯一の根拠になっている応募回は配布から落ちる**（要事前測定）
- `url_quality.classify` はいまも `source` を返しているので、
  **分類だけが既にまとめ扱い**という食い違いがあります（ホスト一覧に無いのに）

## 次にやること

- **`build` の常駐赤**（`lotteries/e2e.test.mjs` の 290≠292）。全PRで赤なので、
  いずれ「PR固有の赤」を見分けにくくなります。未調査
- `event_id_registry.json` が書き直されたら吸収を測り直す → 既存7件の直し
- 段1は `2026-09-04-tsutaya-handle-collision.md` を読んでから
- §11 の材料として記録済み: 保留理由の語彙（JSの3語が手書き・既定が「出す」）、
  `PLATFORMS` と `ORIGIN_OK` の役割の違い
- CI削減は着手しない
