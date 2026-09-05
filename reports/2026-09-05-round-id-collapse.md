# rare-zaiko を足した ／ 9月2日から重複が出るようになった原因 ／ round_id で畳む前の確認3点

日付: 2026-09-05（JST）
区切り/依頼名: CI費用の削減 1（常駐赤の解消・続き）

根拠データ:
- [2026-09-05-round-id-collapse.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-round-id-collapse.json)（受付中の同じ round_id の組・印との重なり・反例の探索）
- [2026-09-05-roundup-as-official.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-roundup-as-official.json)（まとめホストなのに公式材料扱いの根拠12件）

## 受けた指示（原文・要点）

> ## 順番
> 1. rare-zaiko.blog.jp をまとめ一覧に足す（小さい・確実）
> 2. 9/2 から出るようになった原因の調査
> 3. round_id での畳みの実装（原因が分かってから）
>
> 足した後、test_candidate_ai_runner の赤が消えることを確認してください。
>
> 実装前に確認してほしいこと:
> - この規則で畳まれる組が、現在の配布データに何組あるか
> - 畳んだとき、どちらの行を残すか（情報が多いほう、という既存の規則でよいか）
> - round_id が同じでも別の抽選である場合がありうるか

## 0. 【要対応・新規】`event_id` 台帳の作り直しが止まっています

**調査中に見つけました。CI main の赤が 5件 → 11件 に増えています。**

```
RegistryRefusal: 台帳の redirects が壊れています
  ← 止めた event_id は redirect できません
```

台帳（`event_id_registry.json`）は **2026-09-04 08:53Z を最後に24時間以上
書き直されていません**。差し戻し（`b595cd7e`・10:21Z）より前です。

**「次の巡回で吸収が7のままか確認する」がずっとできなかったのは、
巡回が台帳へ書いていないのではなく、作り直しが拒否されていたから**でした。

### 何が起きているか

保存済みの台帳は健全です（止めたIDへ向かう redirect は0件）。
**作り直したときにだけ**壊れます。

1. 作り直しの途中で `evt_74def613ab5cb0238e44646b` が新たに「止める」側へ入る
   （blocked が 2 → 3）
2. 既存の redirect `evt_71f01035793f0e4a29d57299 → evt_74def613ab5cb0238e44646b`
   がその止めたIDを指す
3. `validate(new)` が拒否して、作り直し全体が止まる

止まる原因の行は **JapanTCGCenter錦糸町マルイ店**です。

```
japantcgcenter錦糸町マルイ店|pokemon|…30thcelebrationboxシュリンク付|抽選|https://livepocket.jp/e/tn698
japantcgcenter錦糸町マルイ店|pokemon|…30thcelebrationboxシュリンク付|抽選|          ← URL 空
```

配布行を見ると、同じ店・同じ商品・**同じ応募URL**なのに応募期間が違う2行が
あります。

```
round_id=rnd_2060193223ad4f01  url=livepocket.jp/e/tn698  apply 2026-08-28 〜 09-01T23:59
round_id=rnd_f9205895ae1f10fd  url=livepocket.jp/e/tn698  apply （空） 〜 08-23T12:46
```

`identity_key` は日付を含まないので、**別回なのに1つの素性へ潰れて「曖昧」**と
判定されます。

### CI main の赤（`run 33934128691` / `bd34585c`・実測）

**11件**（`test_dedupe_channel` は模擬の印字なので除く）。

```
test_candidate_ai_runner  ×1
test_lottery_overrides    ×3
event_id の作り直し系      ×7   ← 9月4日から増えたぶん
  test_collapse_same_deadline.test_畳んだ後に台帳の作り直しが通る
  test_event_id_redirects.test_書かずに作り直しを通せる
  test_event_id_registry   ×4
  test_event_id_reuse.test_作り直せて旧IDが残る
```

**`test_畳んだ後に台帳の作り直しが通る` が落ちている**のが示すとおり、
畳みと台帳は繋がっています。重複の話と同じ根から来ています。

**この件は指示を受けていないので、調査だけで止めています。**
下の案A/B/Cの判断と一緒に、こちらも扱うか指示してください。

## 1. `rare-zaiko.blog.jp` を足しました。**ただし赤は消えません**

`source_names.json` の `hosts` と `words` へ追加。`url_quality.classify` は
`source` → **`reject`** になり、応募先として配らなくなりました。
関係する試験（`test_source_names` / `test_publish_summary_only` /
`test_url_quality`・92件）は緑です。

PR [#1286](https://github.com/shinonomeheta-ai/cardbot/pull/1286)。
無改変の**同じ元**と全件を突き合わせて **23件 = 23件（増減0）**。

**しかし `test_candidate_ai_runner` の赤は消えませんでした。私の見立てが誤りでした。**

前回の報告で「まとめ一覧へ足せば `page_role` が `summary` になり、抜粋がAIへ
渡らなくなる」と書きましたが、**そうなりません**。`page_role` も
`source_authority` も**台帳に保存済みの値**で、一覧へ足しても作り直されません。

問題の根拠はこう保存されています。

```
page_role         announcement
source_authority  official_unverified     ← これが効く
→ candidate_contract.is_official_source() = True
```

**まとめサイトの記事が「公式材料」として数えられ、AIへ渡っています。**

### これは rare-zaiko だけの話ではありません

まとめ一覧に載っているホストのうち、**公式材料扱いのままの根拠が12件**あります。

| ホスト | 件数 |
| --- | ---: |
| `rare-zaiko.blog.jp` | 5 |
| `pokecawatch.com` | 4 |
| `meli-melo.blog.jp` | 2 |
| `pokesoku.com` | 1 |

役割の内訳は `application` 7件・`announcement` 5件。
**`pokecawatch` と `pokesoku` は昨日この一覧へ足したホストで、それでも
公式材料のままです。**「まとめ一覧へ足す」は配布側の判定にしか効かず、
**材料レーンには届いていません。**

### 直すなら、影響はこれだけ

`is_official_source()` がまとめホストを公式と見なさないようにした場合:

| | 件数 |
| --- | ---: |
| 公式材料がまとめを含む応募回 | 10 |
| **公式材料がまとめ「だけ」の応募回**（＝AIへ送れなくなる） | **4** |

落ちる4回は ブックオフ新座志木南店 / トレカステーション各店 /
TSUTAYA 流山おおたかの森駅前店 / イトーヨーカドー各店 です。

これは材料レーンの規則（「AI審査は公式材料だけ」）に関わるので、
**私からは触っていません。** roundup セッションの判断材料としてお渡しします。

## 2. 9月2日から出るようになった原因

### 引き金は **#1204**（`url_scoped` の店名寄せを配布直前で適用）

最後に重複0だった巡回（`01e09f74` 09-02 09:22 UTC）と、最初に重複した巡回
（`ee203f67` 09-02 09:59 UTC）の間に入ったのは**1本だけ**でした。

```
15ad8fa5  Merge pull request #1204 from shinonomeheta-ai/fix/url-scoped-and-promote-gate
14077d2b  fix(publish): url_scoped の店名寄せを配布直前で適用し、
                        昇格行にも共有基盤の持ち主関門を掛ける
```

最初に重複した巡回で重複していたのは**カードショップ黄鶏屋**——
`store_aliases.json` の `url_scoped` に載っている店です
（`canonical: カードショップ黄鶏屋` / `aliases: 黄鶏屋（大阪）`）。

**別名だった行が同じ店名へ寄った結果、同じ店・同じ商品・同じ締切の行が
並ぶようになった**、という筋が通ります。`collapse_open_duplicates.py` の
説明文も同じ日に黄鶏屋を名指ししています。

なお 684553de（9/1 14:40・event_id 汚染の原因）は**別件**でした。
差し戻し（`b595cd7e`・9/4 10:21 UTC）の後も重複は出続けています（9/4 は85%）。

### いま残っているのは「担当の隙間」1つだけ

重複の後始末は**2つに分担**されています。

| 形 | 担当 | 動き |
| --- | --- | --- |
| 商品名の芯が**完全一致** | `collapse_open_duplicates` | 畳む |
| 商品名の芯が**包含関係** | `mark_similar_rounds`（2026-09-03・本人指示A） | 畳まず印を付けて人待ち |

`mark_similar_rounds.py:71` に `continue  # 完全一致は畳みの仕事` と明記されています。

**【訂正】前回の報告で組B（TSUTAYA能代店）を「同じ病気」と書いたのは誤りです。**
実測すると `similar_round_suspects.json` に**印が付いています**。
**指示Aどおりに動いており、不具合ではありません。**

残る本物の隙間は**組A（北国書林辰口店 CARD BOX）だけ**です。

```
芯が完全一致 → 畳みの担当
しかし collapse_open_duplicates.同じ回の空開始() が
    有 = [l for l in rows if _urls(l)]     # 応募先の無い行は同一視しない
で**応募先を1つも持たない行を外す**ので、組が1件になり畳めない
```

この除外自体は意図的です（「応募先無しは何とでも『同じ』になってしまう」）。
足りないのは、**`round_id` という強い同一性の証拠を見ていない**ことです。

## 3. `round_id` で畳む前の確認3点（指示への回答）

### ① いま何組が畳まれるか → **2組**

受付中の行136件のうち、同じ `round_id` が2行以上あるのは2組です。

| `round_id` | 店 | 芯 | いまの畳みで畳めるか |
| --- | --- | --- | --- |
| `rnd_7942188951610d00` | 北国書林辰口店 CARD BOX | 同じ | **いいえ** |
| `rnd_ff6b7c38ad920aff` | TSUTAYA能代店 | 違う（＝印の担当） | はい |

### ② どちらを残すか → **既存の規則でそのまま動きます**

既存の「強さ」順（人の確認 > 観測が新しい > 裏の数 > 締切が遅い）で選ぶと、
2組とも `url` が空の行が残ります。ただし `引き継ぐ` に `url` と `url_status` が
入っているので、**捨てる側のXの告知URLが空欄へ引き継がれます**。
日付も `_日付を選ぶ` が権威で選び直します。**追加の規則は要りません。**

### ③ `round_id` が同じでも別回か → **実データに反例0件**

配布280行を全部見て、**同じ `round_id` なのに締切か開始が違う組は0件**でした。
`round_id` は `lottery_round_registry.json` が「同じ `event_id` の中の応募回」
として振るものなので、設計上も同一回です。

### ⚠ ただし1点、判断が要ります

**印が付いた57組のうち1組（TSUTAYA能代店）は `round_id` まで同じ**です。

`round_id` で畳むと、**この1組について 2026-09-03 の「畳まずに印を付けて
人が確認する」という判断を上書き**します。

- 案A: `round_id` が同じなら畳む（印より優先）。2組とも消える。
  ただし指示Aの対象が1件減る
- 案B: **印が付いている組は畳まない**（印を優先）。組Aだけ畳む。
  CIの赤は消え、指示Aはそのまま
- 案C: 畳みの除外条件だけ緩める（`round_id` が同じなら応募先が無くても同一視）。
  実質Bと同じ結果で、変更がいちばん小さい

**私の推しは案B**です。「完全一致は畳み、包含関係は印」という既存の分担を
壊さずに済み、`round_id` は分担の判定ではなく**畳み側の証拠**として足すだけで
済みます。

**実装はまだしていません。** 案の指示をお待ちします。

## 次にやること

- **`event_id` 台帳の作り直しが止まっている件**（§0）をどう扱うか
- 上の案A/B/Cの判断
- まとめホストが「公式材料」のままの件（12件・落ちる回4件）は roundup セッションへ
- `event_id_registry.json` が書き直されたら吸収を測り直す → 既存7件の直し
- 段1は `2026-09-04-tsutaya-handle-collision.md` を読んでから
- CI削減は着手しない
