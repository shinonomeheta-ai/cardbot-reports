# ヨロズヤの統合と、発番が素性を材料にしている箇所の列挙

セッション名: store-name-a
日付: 2026-09-05（JST）
区切り/依頼名: 段3-B の残り＋段4 の設計材料
対象: `origin/main` = 673c7a79

## 受けた指示（原文）

> ### ヨロズヤ: 段3-A の見方で進めてください
> 主は `ザ・グレートヨロズヤ盛岡高松店`。もう片方は別名として残す。
>
> ## 次
> 1. ヨロズヤの統合を実施
> 2. 段4の設計に向けて、発番が素性を材料にしている箇所を全部列挙してください
>    （candidate_event_id / event_id / round_id / lot_key の4つ？他にもあるか）
>    それぞれ何を材料にしているか、素性が変わるとどうなるか
>
> 2は測定と列挙のみ。設計は私が ci の件と合わせて組みます。

## 指示と過去の報告の食い違い

**「4つ？」は 8つでした。** うち7つが素性を材料にしています。

## 1. ヨロズヤの統合（PR #1301）

`【トレカ】` は飾りとして、`ザ・グレートヨロズヤ盛岡高松店` を主に統合しました。
**正規名は動かさず**、幽霊側の綴りは `observed_names` に残しています。

どちらのハンドルが告知しているかを実測しました。

```
根拠の投稿   @gtakamatsu_card  2本
            @greattakamatsu   0本
配布行の url / notice_url もすべて @gtakamatsu_card
```

統合先は既に @gtakamatsu_card が `confirmed` なのでそのまま。
@greattakamatsu は同じ店の一般アカウントですが根拠0本なので `"old"` にしました
（誤登録ではないので `"moved"` は使いません）。

**配布2行は2行のままです**（商品も締切も違う別の抽選）。

## 2. 発番が素性を材料にしている箇所 — **8つ、うち7つが該当**

材料を1つずつ変えて、実際にIDが変わるかを試しました。

| # | 発番 | 例 | 素性を変えると動く材料 |
| --- | --- | --- | --- |
| 1 | `candidate_contract.candidate_event_id`（`cevt_`） | `cevt_075a062fa7f21e84` | **store / product / type** |
| 2 | `candidate_contract.identity_key`（候補の素性鍵） | `てすと店\|pokemon\|ポケモンカード30thbox\|抽選` | **store / product / type** |
| 3 | `candidate_contract.candidate_round_id`（`crnd_`） | `crnd_0424d9055511` | **store / product / type**（`event_id` 経由） |
| 4 | `event_identity.stable_event_id`（`evt_`） | `evt_9c60c094ef991a5de7c18745` | **store / product / type** |
| 5 | `event_identity.identity_key_of`（配布の素性鍵） | `てすと店\|pokemon\|…\|抽選\|https://…` | **store / product / type**（＋url） |
| 6 | `lot_key.wide_lot_key` | `てすと店\|pokemon\|2026-09-30\|ポケモンカード30thbox` | **store / product** |
| 7 | `store_registry.store_key` / `store_id` | `てすと店` / `st_47244e417f96bc43` | **store** |
| 8 | `candidate_contract.evidence_id`（`evi_`） | `evi_0cea504197cd` | **URLだけ**（素性に依らない） |

**素性に依らないのは `evidence_id` だけ**です。URLを材料にしているので、
店名や商品名を直しても動きません。

### 転送（redirect）の有無

```
evt_    event_id_redirects.json     **ある**（旧ID → 現行ID）
cevt_   なし
crnd_   なし
lot_key なし
store_key / store_id  なし
```

`event_id_redirects` は「人が同一案件と確認した重複IDの向き」を持つ別台帳で、
読むときに現行IDへ寄せます。**同じ形が `cevt_` / `crnd_` には無い**ので、
§4 で店名を寄せると、その分の対応が切れます。

### 素性を直すと何が切れるか

```
cevt_ / crnd_ が変わると
   人の判定（review_status・url_review_status）      … 候補IDに紐づく
   round_links の刻印（round_id → candidate_round_id） … crnd_ に紐づく
   event_id 台帳との対応                            … evt_ 側は転送があるが、候補側は無い
```

`round_links` は「刻印は身元より優先し、上書きされない」設計なので
（2026-09-04 の #1261）、`crnd_` が変わると**古い刻印が残ったまま新しい回に
届かない**状態になりえます。

## 3. ci の件（`test_lottery_overrides`）との共通点

ご指摘のとおり同じ構造です。

```
人手補正で商品名が変わる  → identity_key_of / stable_event_id が変わる → 控えが結び直せない
§4 で店名を寄せる       → candidate_event_id が変わる           → 人の判定が結び直せない
```

**発番が素性を材料にしている限り、素性を直すたびにIDが動きます。**
`evidence_id`（URLだけ）が唯一の例外である、というのが今回の列挙の要点です。

## 4. 別名の候補（記録・足していません）

案a のとおり足していません。段4 で §4 が入ったときに使えるよう残します。

```
正式名  BOOKOFFお宝大陸和泉中央店
別名    ブックオフお宝大陸和泉中央店
根拠    @bookoff_otakara のプロフィール表示名が
        『BOOKOFFお宝大陸和泉中央店◆営業時間平日13時～22時…』（ラテン綴り）
        印は4本
```

残り3組は §4 の後に判断（`萬屋盛岡店`＝表の鍵を直す／
`CARDBOX おもちゃのバンビ本郷店`＝正式名をどちらにするか）。

## 5. 判断していただきたいこと

1. **PR #1301 をマージするか。**
2. 段4 の設計で、`cevt_` / `crnd_` の転送を作るか、
   **発番から素性を外す**（`evidence_id` のようにURL等の不変な材料にする）かの
   選択になります。後者は影響が大きいですが、`evidence_id` という前例が既にあります。

## 根拠データ

- [2026-09-05-id-materials.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-id-materials.json)
  — 8つの発番について、材料を1つずつ変えて実際にIDが変わるかを試した結果

## 状態

- **PR #1301 を出しました。マージはしていません**（指示待ち）。
- 別名は足していません（案a）。
- §4 の実装はしていません。
- 外部への通信は行っていません。課金もありません。
