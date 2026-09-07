# (d) 素性の鍵を M2 の product_id で作る（設計のみ・案E の後）

日付: 2026-09-07　セッション: product　対象: origin/main 5f655f96（15:14 JST）の候補台帳 2,296 件・配布 312 行
根拠データ: https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-07-m2-identity-design.json
関連: 案E（`2026-09-05-identity-design.md`・`2026-09-05-identity-drop-url.md`）／段4-1（`2026-09-05-stage4-1-id-design.md`・凍結欄）／M2 段1〜2（`2026-09-05-m2-stage1.md`・`2026-09-06-m2-stage2.md`）

コードもマスタも変更していない。

---

## 受けた指示（原文）

> (d) の設計を出してください。
> 「ブックオフ川崎モアーズ店の2行が商品名の書き方違いで割れる」——
> 素性の鍵を M2 の product_id で作る形。案E（URL を外す）の後に入れるが、設計は今。
>
> - product_master の product_id を identity_key_of() の材料にする
> - set_only・unknown の行はどうするか（product_id が無い）
> - 既存の候補が割れているものを、product_id で統合できるか（数）

---

## 指示と実装の食い違い

1. **ブックオフ川崎モアーズ店は 2 行ではなく 3 行**（配布・同じ弾）。「30th CELEBRATION」（人手補正あり）・「ポケモンカード 30th CELEBRATION BOX」・「…拡張パック「30th CELEBRATION」1BOX（おひとり様…）」。影の欄はいま 3 行とも set_only だが、3 行目は手元の解決では product（m6a）になる——Actions の fill が見た商品名（人手補正を当てた後）が生の名と違う、前の報告 §7 と同じ型（同じ店・同じ回に生の行と補正の行が並び、補正がどの行に当たるかが巡回ごとに動く＝案ロの領域）。
2. **`identity_key_of()` は既に `product_id` の口を持つ**（`event_identity_parts` が top-level `product_id` → `id:<product_id>`・`durable_product_id`）。だが (d) の入力を top-level に置くと段2の影の欄との区別が付かないので、**入力は M2 の解決結果そのもの**にし、top-level の口は使わない（下記 §2）。

---

## 0. 結論

- **鍵の商品欄は解決結果で3種類に分ける**: product → `id:<product_id>`、set_only → `set:<set_id>`、multi → `ids:<sorted product_ids>`。unknown・empty は従来どおり `norm(生の商品名)`。
- **実データで統合できるのは、候補台帳 81 組・169 件（鍵 2,296→2,208）、配布 11 組・24 行（鍵 309→297）。** 商品名の書き方違い（1BOX・価格・再販の注記・鉤括弧・型番の有無）はこれで全部寄る。
- **product と set_only が同じ店×弾に混ざる組は残る**（候補 142 組・配布 16 組）。「30th CELEBRATION BOX」と「拡張パック「30th CELEBRATION」」は判断②（BOX 語で決めない）の帰結として別の鍵。ブックオフ川崎はこの型で、(d) だけでは 1 本にならない。**寄せるのは V3（同一疑い）→人の決着（案ロ）で、identity では決めない**。
- **入れる順は 案E → 凍結欄（段4-1）→ (d)**。(d) は鍵の商品欄を変えるので ID の材料が動く。候補 ID は `identity_keys` の索引で動かないが、統合される 81 組は「2 候補が 1 鍵」になるので統合の手順が要る（案E の 200 組と同じ形）。

---

## 1. 鍵の形

いま（`candidate_contract.IDENTITY_PARTS` = seller | game | product | event_type。配布側は案E で URL を外して同じ 4 欄に揃う）:

```
product = norm(生の商品名)        ← 「拡張パック「30th CELEBRATION」」と「…「30th CELEBRATION」1BOX（…）」が別
```

(d) 後:

| 解決結果 | 商品欄 | 例 |
|---|---|---|
| product | `id:<product_id>` | `id:pokemon:m6a` |
| multi（列挙） | `ids:<sorted product_ids>`（set_only の片は `set:` を混ぜる） | `ids:pokemon:m6a+pokemon:mf` |
| set_only（弾だけ） | `set:<set_id>` | `set:pokemon:30thcelebration` |
| unknown / empty | `norm(生の商品名)`（従来どおり） | `第2回抽選` |

- `id:` `ids:` `set:` は既存の `durable_product_id` の接頭辞 `id:` の延長。`product_identity_method` にも `set_id` / `product_ids` を足して、鍵から「どの段で決めた商品欄か」が読めるようにする（`identity_parts_of_key` で戻せる形は保つ）。
- **product と set_only は別の鍵**。同じ弾でも「拡張パック」と「弾だけ」は別案件として立つ。これを寄せると、弾だけの行が拡張パックと決めたことになり判断②に反する。
- **set_only 同士は寄る**。「30th CELEBRATION」「30th」「ポケモンカード 30th CELEBRATION BOX」は同じ `set:pokemon:30thcelebration`（ブックオフ川崎の 1・2 行目はこれで寄る）。
- **弾も決まらない行は生の名のまま**。ここは M2 を通しても情報が増えないので変えない（候補 471・配布 17）。

### 1-1. 判定の置き場（§11）

商品欄を作るのは `event_identity.event_identity_parts` の 1 か所（候補側 `candidate_contract.identity_key` はこれを呼ぶ）。**解決は `product_master.resolve` を呼ぶ**（影の欄を読まない——影の欄は fill が後段で書くので、収集時の `upsert` では無い。`resolve` は決定的で、1 件あたり公式名 600 件との照合＝ミリ秒）。

- 循環 import に注意: `product_master` が `event_identity.norm` を使っている。`event_identity_parts` の中で遅延 import する。
- M2 の版はその run で 1 つ（`product_master.json` は update-data が日次で作り直す）。公式に商品が増えて set_only → product に変わる行は、鍵が変わる。その扱いは §3。

---

## 2. set_only・unknown の行

| 行 | 鍵 | ID |
|---|---|---|
| set_only | `set:<set_id>`。弾だけの行どうしは 1 案件 | 後で商品が決まる（V5 の画像・人の別名・公式一覧の更新）と鍵が `id:` に変わる → §3 の移行と同じ機構で吸収 |
| unknown | `norm(生の名)`（従来どおり） | 変わらない |
| empty | `norm("")`＝空（従来どおり） | 変わらない |
| multi | `ids:` | 列挙の並びが変わっても同じ鍵（sorted） |

「弾は分かるが形態が不明」を **1 案件として立てる**のが設計の要点。V5 で商品が決まれば `id:` へ寄り、決まらなければ `set:` のまま配信（札「商品未特定」）。決めないことで割れる分（product と set_only の混在）は identity では埋めない。

---

## 3. 既存の候補を product_id で統合できるか（数）

origin/main 5f655f96 の影の欄（`product_master`）をそのまま商品欄に写して数えた。

| | 候補台帳 2,296 | 配布 312 |
|---|---|---|
| 鍵の数 いま → (d) | 2,296 → **2,208（88 減）** | 309 → **297（12 減）** |
| 統合される組（同じ鍵に 2 つ以上の書き方） | **81 組・169 件** | **11 組・24 行** |
| 商品欄の種類 | id 1,262・set 503・ids 60・生の名 471 | id 217・set 72・ids 6・生の名 17 |
| product と set_only が混ざり残る組（同じ店×弾） | **142 組** | **16 組** |

統合される組の例（候補）: カードラボ浜松店「拡張パック「メガシンフォニア」30パック」「同（5,400円）」「同（再販抽選）」→ `id:pokemon:ex-m1-…`／ゲームプラザ元気302「ブースターパック「世界最強の戦士」【OP-17】1BOX（…）」×3 → `id:onepiece:op17`／TSUTAYA能代店「30th CELEBRATION」「プレミアムデッキセットエーフィ・ブラッキー」「MEGA 30th CELEBRATION」→ `set:pokemon:30thcelebration`。配布: ブックオフ川崎の 3 行（いまの影の欄では 3 行とも set_only）→ `set:pokemon:30thcelebration`／JapanTCGCenter錦糸町「…「30th CELEBRATION」BOX（シュ…）」「MEGA拡張パック「30th CELEBRATION」」→ `id:pokemon:m6a`。

混ざり残る組の例: tsutaya横須賀粟田店 30th（product 3・set_only 1）、カードショップアンカー篠山（product 2・set_only 1）、カーナベル ORIGINAL ARTWORK COLLECTION（set_only 2・product 1）。**これらは (d) では 1 本にならない。** 同じ店×同じ弾×同じ期間で product と set_only が並ぶ組は `mark_similar_rounds`（芯の包含）が既に印を付ける対象なので、そこから人の決着（案ロ）へ。判断②を守る限り、機械が寄せてよいのは「同じ解決結果」の組だけ。

注: 候補台帳の 503 件の set_only のうち、ブックオフ川崎の 3 行目のように**影の欄が古い**行が混ざる（手元の解決では product）。(d) は影の欄でなく `resolve` を鍵の材料にするので、この古さは鍵には出ない。

---

## 4. 入れる順と移行

```
案E（配布側の素性から URL を外す・4 欄に揃える）
  → 凍結欄（段4-1: 候補に frozen_event_id・素性が変わっても ID が動かない）
    → (d) 商品欄を id:/set:/ids: に
```

(d) が先だと、鍵の商品欄が変わった瞬間に `candidate_event_id`（鍵のハッシュ）が動く。候補台帳は `identity_keys` の索引で同じ候補へ当てるので ID は動かないが、**統合される 81 組は「2 つの候補が同じ鍵」になり、索引が曖昧で落ちる**（`docs/renaming-procedure.md` §4-1）。だから:

1. **乾式**: 新しい鍵を全候補に付け、同じ鍵に寄る候補の組（81）と、混ざり残る組（142）を一覧にする（案E の `2026-09-05-identity-merge-list.md` と同じ形・本人が目視）
2. **統合**: 組ごとに `rounds` と `evidence` を残す側へ寄せ、消える側の `candidate_event_id` を `event_id_auto_redirects.json`（機械の寄せ先）に書く。配布側の `event_id` は凍結欄があれば動かない。無ければ案E のときと同じく `孤児の寄せ先を足す` で寄せる（案E は 205 本）
3. **巡回 1 回**: `identity_keys` に新しい鍵が追記されたか／`round_links.食い違う刻印()` が 0 か／人の判定（`lottery-admin.json`）が引けるか、の 4 点（`docs/renaming-procedure.md`）
4. **T**: `N/product` の out（product＋multi）と held（set_only）がそのまま「鍵を `id:` / `set:` で作れた数」になる。移行前後で L2 の `issued` / `matched` を見る（統合の日だけ matched が跳ねるはず）

M2 が日々更新されて set_only → product に変わる行（公式が商品を足した・別名が育った）は、同じ機構（`identity_keys` 追記・凍結欄）で吸収される。**鍵が変わること自体は設計上の前提**で、変わっても ID が動かないことを凍結欄が保証する。

---

## 5. 判断待ち

| # | 何が未確定か | 推奨 | 代替 |
|---|---|---|---|
| ⑨ | set_only を `set:` として 1 案件に立てるか、それとも生の名のままにするか | `set:`（弾だけの書き方違い——「30th」「30th CELEBRATION」「… BOX」——が寄る。ブックオフ川崎の 1・2 行目、候補 503 件の書き方違いを吸収） | 生の名のまま（割れは残るが判断②に最も近い） |
| ⑩ | product と set_only の混在（142 組）を identity で寄せない、でよいか | 寄せない。V3 の印→人の決着（案ロ）。判断②を守る | 「同じ店×弾×期間で product が 1 種類だけなら set_only をそこへ」の規則（判断②の例外になる） |
| ⑪ | (d) の入力を `resolve` の呼び出しにするか、影の欄にするか | `resolve`（収集時の upsert で使える・影の欄の古さに左右されない） | 影の欄（fill の後にしか鍵が作れない） |

---

## 6. 補足（同日の観測）

- `product_master.json` の来歴が **fetch（2026-09-07）** になった。#1364 の後の update-data で `build --fetch` が書けている（M2 の日次更新が効き始めた）。詳細は 9/7〜8 の報告で。
- 影の欄の古さ（ブックオフ川崎 3 行目）は前の報告 §7 と同じ型。同じ店・同じ回に生の行と人手補正の行が並び、補正がどの行に当たるかが巡回ごとに動く。M2 の外（案ロ）。

## 7. 追記（同日）: 本人判断で設計確定

- ⑨ set_only は `set:` で 1 案件に立てる（書き方違いの候補 81 組・配布 11 組が寄る）
- ⑩ product と set_only の混在は identity で寄せない（判断②に反する。V3 の同一疑い→人の決着＝案ロ）
- ⑪ 入力は `resolve` の呼び出し（影の欄の古さに左右されない・判定は 1 か所）
- 順序は 案E → 凍結欄 → (d)。統合の手順は案E と同じ（乾式で一覧→目視→統合と redirect→4 点確認）。**(d) の実装は案E の後。設計はこれで確定。**
