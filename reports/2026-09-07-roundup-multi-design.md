# 実装の設計: 「まとめ複数確認」——公式が無い店を、複数のまとめで一致した情報として出す

日付: 2026-09-07（JST）
区切り/依頼名: 設計変更（本人決定）の実装設計（docs の変更は後）
セッション名: roundup

## 受けた指示（原文）

> 設計変更（本人決定・今日）:
> 公式が無い店は、複数のまとめで一致した情報を「まとめ複数確認」として出す。
> 応募URL は出さない。店名・商品・締切・応募方法（店頭なら「各店舗で確認」）・公式サイトのリンク。
>
> 実装:
> - 候補台帳の根拠に「まとめ複数確認」の状態を足す（2つ以上のまとめホストで同じ店・商品・締切）
> - 配信の関門を「公式根拠1本以上 または まとめ複数確認」に
> - 配布行に出所の印（official / roundup_multi）
> - 画面で「まとめ情報」と明示
>
> docs の設計書変更を待たずに、実装の設計を出してください。

## 指示と過去の報告の食い違い

1. **いまの台帳では「2 つ以上のまとめホスト」を持つ応募回はほぼ無い。** 受付中の応募回 1,421 のうち、まとめの根拠が 2 ホストある回は **6**、1 ホストは 432（ほぼ全部 cardchusen・#1201 の一覧リンク）、0 が 983。まとめの**値**を根拠として集める収集は #1088 で止めていて（設計書 §0-1 原則 2）、D1 の道具は店名と口しか取らない。**この設計は「まとめの値を根拠に入れる収集」を再び置くことを含む**（§0-1 原則 2 の書き換え。docs はあとで）。
2. 「同じ店・商品・締切」の一致は、ホストごとに書き方が違う（商品名の略・締切の時刻の有無・店名の別表記）。一致の物差しをこの設計で決める（§3）。

## 報告（設計）

根拠データ: [2026-09-07-roundup-multi-design.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-07-roundup-multi-design.json)（いまの台帳の根拠の内訳）

### 0. 一言で

まとめの行（店・商品・締切）を**ホストの印つきの根拠**として候補台帳に入れ、**別々の 2 ホスト以上が同じ店・商品・締切で一致した応募回**だけを `roundup_multi` として、公式根拠の代わりに配信の関門を通す。行には出所の印を付け、応募 URL は出さず、画面は「まとめ情報」と明示する。判定は 1 か所（`candidate_contract`）、関門は `publish_reviewed_only` の条件①だけを広げる。

### 1. 語彙（3 点セット: `vocab_master` → `gen_vocab_js` → 試験）

| 語彙 | 値 | 意味 |
|---|---|---|
| `SOURCE_AUTHORITY` | 既存 `official_verified` / `official_unverified` / `unofficial` に **`roundup`** を足す | まとめの行から取った根拠（値つき）。`unofficial` と分ける（いまはまとめも共有基盤も `unofficial` に混ざる） |
| 根拠の欄 | `roundup_host`（`source_names.hosts` の 1 つ）・`observed`（店名・商品・締切・応募方法の**そのホストが書いた値**） | 一致の判定材料。値は根拠の中に閉じる（候補の値へ勝手に流さない） |
| 応募回の欄 | `roundup_confirm: {"state": "none"\|"single"\|"multi"\|"conflict", "hosts": [...], "agreed": {"store","product","apply_end"}, "checked_at"}` | 派生値。`candidate_contract.roundup_confirm(c, r)` が根拠から**毎回計算**し、台帳には控えとして書く（正は根拠） |
| `PUBLISH_VERDICT_REASON` | `no_official_evidence` はそのまま。落ちる理由に **`roundup_single`**（まとめ 1 ホストだけ）と **`roundup_conflict`**（ホスト間で不一致）を足す | T と管理画面が「なぜ出ないか」を数えられる |
| `PUBLISH_VERDICT_PATH` | 既存 `ec` / `ai` に **`roundup_multi`** を足す | 行の出所の印。配布行の `source_kind` は `official` / `roundup_multi` の 2 値（人確認・AI の行は `official`） |
| `APPLY_METHOD` | 既存の語彙に **`store_check`（各店舗で確認）** を足す（無ければ） | 店頭の行の応募方法 |

### 2. 収集: まとめの行を値つきの根拠にする（D1 の道具の拡張）

- `roundup_store_discovery.行を読む` は店名と口だけ。**`roundup_rows.py`（新）** が同じ行から商品・期間・応募方法の欄を読み、`{"host","page","store","product","apply_end","apply_method","row_fingerprint"}` の**行**にする。ホストごとに読み方が違うので、`source_names.hosts` の各ホストに小さな読み手（pokecawatch: 表の列／cardchusen: #1201 の一覧／meli-melo: 記事の見出し）。読めない欄は空（推測しない）
- 候補台帳へは `CL.upsert` の既存の口で、`row_evidence` に `source_authority="roundup"`・`roundup_host`・`observed` を付けて入れる。**候補の値（product / apply_end）はまとめの行からは書かない**（`observed` に閉じる）。既存の身元の鍵（店＋商品）で同じ候補に集まる
- 走らせる場所: `roundup-daily`（#1419）に **④ rows** を足す（survey → discovery → x_seed → rows）。値の収集はまとめ 1 日 1 回で足りる（締切は日単位）
- 店名の橋: 行の X の口 → 登録名（§2-2）。口が無い行は店名の正規化＋別名。**どちらでも店マスタに着かない行は根拠にしない**（幽霊の鍵を作らない）

### 3. 一致の物差し（`candidate_contract.roundup_confirm`・判定は 1 か所）

同じ応募回に付いた `roundup` 根拠のうち、**ホストが異なる 2 本以上**で次の 3 つが揃えば `multi`:

| 欄 | 一致の読み方 |
|---|---|
| 店 | 同じ候補に付いている時点で店は同じ（身元の鍵）。別表記は §2-2 の橋で吸収 |
| 商品 | 商品マスタ（M2）の `product_id` が同じ。無ければ `product` を正規化して、片方がもう片方を含む（「30th CELEBRATION BOX」⊂「ポケモンカードゲーム MEGA 拡張パック 30th CELEBRATION BOX」） |
| 締切 | **日付が同じ**（時刻は片方に無いことが多いので、両方にあれば同じ、片方だけなら日付だけで一致）。日付が無い根拠は数えない |

- 3 つ揃わないホストが混ざる → `conflict`（配らない・理由 `roundup_conflict`）。1 ホストだけ → `single`（理由 `roundup_single`）
- `agreed` には一致した値（店＝候補の店・商品＝一致した方の短い名・締切＝日付＋時刻があれば時刻）
- **公式根拠が 1 本でもあれば `roundup_confirm` は見ない**（公式が正。まとめは補助にしない）
- 独立性の注意: まとめ同士が写しあう（同じ誤りが 2 ホストに出る）ことは防げない。まずは「2 ホスト」で出し、T の `roundup_conflict` と誤り報告で様子を見る。3 ホストへ上げるのは数字を見てから

### 4. 関門（`publish_reviewed_only`・§8-1 の条件①を広げる）

```
いま:   条件① 公式根拠 1 本以上   AND  条件② 日付の食い違いなし   AND  決着（人 or AI）
これから: 条件① 公式根拠 1 本以上  OR  roundup_confirm.state == "multi"
          条件② そのまま
          決着: 公式の行は今までどおり（人 or AI）。roundup_multi の行は AI を通さない（公式の本文が無い）。
               「2 ホストの一致」を決着とみなし、`kept_ai` でも `kept_human` でもない新しい状態 **`kept_roundup`** を刻む
```

- 落ちる理由の刻印: `no_official_evidence` は「公式も無く、まとめも 1 ホスト以下」に狭まる。`roundup_single` / `roundup_conflict` を足す
- 昇格（`promote_candidate_decisions`）に **roundup レーン**を足す: 公式根拠 0・`multi` の応募回から行を作る（AI レーンと同じ「既存の行と身元が一致しなければ新しい行」）。既存の cardchusen 由来の行（`round_id` 空・340 行）とは身元で当てる
- ゴールデン（M1g）の扱い: §3-1-1 のとおり `store_keys` の完全一致だけ。まとめ複数確認の行がゴールデンのカードに入るかは**入る**（店が M1g なら）。ただし印は `roundup_multi`

### 5. 配布行（`build_lotteries` / `clean`）

| 欄 | roundup_multi の行 |
|---|---|
| `store` / `product` / `apply_end` | `roundup_confirm.agreed` の値 |
| `url` / `candidate_url` / `candidate_url_alt` | **空**（応募 URL は出さない。まとめの記事 URL も出さない） |
| `apply_method` | 行の応募方法が読めればそれ、店頭なら `store_check`（各店舗で確認） |
| `official_site_url`（新・任意） | `store_sites.json` にその店の公式サイトがあれば入れる（無ければ空） |
| `source_kind`（新） | `official` / `roundup_multi` |
| `publish_verdicts` | `state=kept_roundup`・`path=roundup_multi`・`reason=""` |
| `source_url` / `source` | まとめの記事 URL は**出さない**（公開 JSON に収集元名を出さない決まり）。`source` は `roundup_multi` の文字だけ |

`clean` が `source` を落とす既知の穴（2026-09-03）があるので、`source_kind` は `clean` の**残す欄**に最初から入れる（欄だけ足して配線を忘れる型の予防）。

### 6. 画面（web）

- 店カード・一覧行・詳細シート: `source_kind === "roundup_multi"` のとき **札「まとめ情報」**（UI 規則: 札は最大 3・色の意味は 1 対 1。既存の「確認済み」「AI」と別の色を 1 つ足す）。応募ボタンは出さず、代わりに「各店舗で確認」＋公式サイトのリンク（あれば）
- 管理画面の候補確認の表: `roundup_confirm.state` と `hosts` を列に（人が「一致しているのに出ない」を見られる）
- SEO ページ・X 投稿: まとめ情報の行は **X 投稿の対象にしない**（post-must-be-actionable: まとめ記事を応募先と呼ばない）

### 7. T（通過率・§10）

- `P`（配信の関門）の reasons に `roundup_single` / `roundup_conflict`
- 新しい段 **`D1/rows`**: 読んだ行数 → 根拠になった数（店マスタに着かなかった数が落ちた理由）
- `roundup_survey` の物差し（まとめ n・システム m・両方 k）はそのまま。roundup_multi で出た行は k に入るので、**公式で取れた数と分けて数える**（`extra.k_official` / `extra.k_roundup`）

### 8. 段階と順番（PR の切り方）

| 段 | 中身 | 出るもの | 課金 |
|---|---|---|---:|
| 1 | 語彙（3 点セット）＋ `roundup_rows.py`（pokecawatch・cardchusen の 2 ホスト）＋ 根拠の `roundup` 化 ＋ `roundup_confirm` の計算 ＋ `roundup-daily` ④ | 台帳に根拠と `roundup_confirm`。**配信は変えない**。T の `D1/rows` と、`multi` になった応募回の数の報告 | 0 |
| 2 | 関門①の OR ＋ 昇格の roundup レーン ＋ 刻印（`kept_roundup` / `roundup_multi`）＋ 配布行の欄（URL 空・`source_kind`・`official_site_url`）＋ `clean` の残す欄 | 配布行に roundup_multi の行が出る（画面は札なしで一旦「応募先なし」の表示） | 0 |
| 3 | 画面の札「まとめ情報」＋ 各店舗で確認 ＋ 公式サイトのリンク ＋ 管理画面の列 | 利用者に見える | 0 |
| 4 | docs（§0-1 原則 2・§8-1・§3-1-1）の書き換え | — | 0 |

段 1 の後に数字（`multi` が何回・どの店）を出してから段 2 へ。段 1 の見込み: いま 2 ホストの回は 6 だが、pokecawatch の行を値つきで入れると、30th の受付中 149 行のうち cardchusen と重なる分（cardchusen 434 根拠）が `multi` の母集団になる。

### 9. 触らないもの・危ないところ

- **公式根拠がある回は今までどおり**。まとめの値で公式の値を上書きしない（`observed` に閉じる）
- 応募 URL・まとめの記事 URL は配布行に**出さない**（link-integrity・公開 JSON に収集元名を出さない）
- 店マスタに着かない行は根拠にしない（幽霊の鍵）。`roundup_rows` は登録もしない（登録は discovery）
- まとめ同士の写しあいで誤りが 2 ホストに揃う型は防げない。誤り報告の導線（trust-plan）と `roundup_conflict` の数で見る
- 段 2 で配布行が増えると `test_公開データの応募URLが減らない` 系の実データ試験の基準が動く。段ごとに main の基準を取り直す

## 実行したこと・していないこと

- 台帳の根拠の内訳を数えただけ（通信なし・書き換えなし・課金なし）。コードは書いていない

## 判断が要る点

1. 段 1 から着手してよいか（語彙＋収集＋派生値・配信は変えない）
2. `multi` の条件を「2 ホスト」で始めてよいか（3 ホストは数字を見てから）
3. roundup_multi の行は AI を通さず「2 ホストの一致」を決着とする（`kept_roundup`）でよいか
4. まとめの記事 URL は配布行に出さない（`source` は `roundup_multi` の文字だけ）でよいか
