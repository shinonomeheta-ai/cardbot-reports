# 引きの別名対応: 正規化の正本を決める（調査のみ）

日付: 2026-09-04（JST）
区切り/依頼名: 引きの別名対応・正規化の正本
対象: `origin/main` = e65b7b97（本文中のコード位置・実測値はすべてこの時点）

## 受けた指示（原文）

> # 引きの別名対応: 正規化の正本を決める（調査のみ）
>
> ## 背景（前回の調査で判明していること）
> store_aliases.json に登録済みの別名でも、公式Xの引きに効いていません。
> official_accounts() も publish_reviewed_only.公式の告知を運ぶ も
> store_canon を通さず、正規化した生の店名で素引きしています。
> MINT GAMES池袋店 と MINT池袋店 は同じ canonical なのに別扱いになっています。
>
> さらに正規化そのものが4種類あり、写しがずれています。
> - store_canon._norm（NFKC＋小書きカナ統一＋飾り除去）… 別名辞書
> - candidate_evidence_excerpt._ならす（NFKC＋casefold のみ）… 公式Xの引き
> - event_identity.norm（NFKC＋casefold＋記号除去）… 店舗台帳・重複判定
> - JS normStoreName / tenantKey（2種で別ルール）… 配布・表示
>
> JS側には canonical が1つも存在せず、Python だけ直しても配る瞬間に別扱いになります。
>
> ## 調べること
>
> ### 1. 正規化の正本をどれにするか
> 上記4種類のうち、どれを正本にすべきかを判断材料つきで提案してください。
> - それぞれの正規化が何を落とし、何を残すか
> - 統一した場合、既存のデータで何が変わるか
>   （重複判定の結果・店舗台帳の鍵・配布の店名表示）
> - 統一によって壊れる可能性のある箇所
>
> ### 2. 店名で引いている全経路の一覧
> 前回、A（公式X 14経路）/ B（公式サイト）/ C（共有基盤）/ D（台帳・重複・ゴールデン）
> / JS の分類で洗い出しがありました。同じ形で最新の origin/main で洗い直し、
> 各経路が store_canon を通しているかを一覧にしてください。
>
> ### 3. 直す順番の提案
> どこから直せば影響が小さく効果が大きいか。
> 段階を分ける場合の区切りも提案してください。
>
> ## 注意
> - 実装はしない。調査と提案のみ
> - 他セッションが publish_reviewed_only.py を触る可能性があるため、
>   ファイルの変更は行わないこと
> - 前回の調査結果と食い違う点があれば、着手前に指摘すること

## 指示と過去の調査の食い違い（3点）

### 食い違い①「正規化は4種類」→ 実測は8種類（店名用に限って）

`origin/main` を全走査した結果、店名を正規化する関数は 8 種類ある。指示文の4種類は
そのうち5つ（JS の2種を含む）で、3種類が漏れている。

| # | 実装 | 規則 | 用途 |
|---|---|---|---|
| 1 | `store_canon._norm` | 空白除去＋小書きカナ統一＋lower（NFKC を通していない） | 別名辞書 |
| 2 | `candidate_evidence_excerpt._ならす` | NFKC＋casefold のみ（空白を落とさない） | 公式Xの引き・抜粋 |
| 3 | `event_identity.norm` | NFKC＋casefold＋記号/空白除去 | 案件ID・店マスタの鍵 |
| 4 | `store_x_match._norm` ＝ JS `normStoreName` | NFKC＋lower＋語の除去（公式/通販/各店/店舗/ショップ/◯号店…）＋区切り除去 | 投稿者の照合・配布判定 |
| 5 | `date_source.tenant_key` ＝ JS `tenantKey` | NFKC＋lower＋区切り除去（語は落とさない） | 共有基盤の権限 |
| 6 | `lot_key.norm_store` ＝ JS `lot-key.mjs normName` | lower＋一部記号除去＋全角英数だけ半角化＋電機→デンキ | 案件の鍵・通知・ロスター照合 |
| 7 | `candidate_contract._norm` ＝ `candidate_ai_index._名` | NFKC＋strip のみ | 販売主体ID（sales_channels） |
| 8 | `candidate_evidence_excerpt._店舗比較用` | 2 ＋ 会社形態語除去＋非かな英数除去＋各店/全店除去 | LivePocket の会場照合 |

さらに写しが別ファイルにある。

- 1 の写し: `build_lotteries_nyuka._norm_store_text`（同一コード）
- 5 の派生: `build_lotteries_nyuka._主体キー`（tenant_key ＋末尾「店」除去）。`store_registry.主体キー` はこれを呼ぶ
- 6 の写し: `notify_open_lotteries.norm_name/norm_store`、`notify_new_lotteries.norm_name/norm_store`、`web/app/lib/set-names.mjs normName`。`store_ledger._norm` は `notify_open_lotteries.norm_store` を呼ぶ
- 6 の旧版: `lot_key.norm_name_wide/norm_store_wide`（保存済みの鍵を読むためだけ）
- 独自の 9 種目: `fill_review_from_evidence.なら`（そのファイルの中だけで定義した別ノイズ表。`D:\cardbot\worktrees\notice-preview` を直接読む一時スクリプト）

### 食い違い②「canonical_store を引きの前に通せば直る」は実測で成り立たない

指示の前半（「別名が引きに効いていない」「`公式の告知を運ぶ` は `store_canon` を通していない」
「MINT GAMES池袋店 と MINT池袋店 が別扱い」）はすべて事実として確認した。
しかし、そこから素直に出てくる直し（引く前に `canonical_store()` を通す）を実データに
当てると、当たりが増えず減る。

`shadow_candidates.json` の応募回 1,691 件で、根拠のX投稿が「店本人の公式X」と
認められる件数:

| 経路 | 現状 | 引く側だけ canonical を通す |
|---|---|---|
| `publish_reviewed_only.公式の告知を運ぶ`（`_ならす`） | 792 件 | 787 件（−5） |
| 配る側 `public-fields`（`normStoreName`） | 804 件 | 799 件（−5） |

理由は2つある。

1. 公式X表（`store_x_accounts.json`・1,347行）は生の表示名で鍵を持っている。
   MINT の例では表にあるのは `MINT池袋店 → mintgames_ikb` で、寄せ先の
   `MINT GAMES池袋店` の行は無い。引く側だけ寄せると、いままで当たっていた
   `MINT池袋店` が当たらなくなる。
2. 寄せると別々の公式Xが1つの鍵に潰れる。実データで2組:

   | 正式名 | handle | 別名 | handle |
   |---|---|---|---|
   | エディオン | `edion_com` | トレカキャピタル | `trecapi_akiba` |
   | GEO | `geo_official` | ゲオ | `geo_onlinestore` |

   衝突した鍵は「どちらの店とも決めない」規則でまるごと落ちるので、
   2店ぶんの公式Xが使えなくなる（`_ならす` で無効鍵 4→6、`normStoreName` で 9→11）。

正しい形は「引く側を寄せる」ではなく「表の鍵と引く側を同じ正本で作り直す」。
片側だけ寄せる修正は、この2点の理由で今日のデータを悪化させる。

### 食い違い③「JS に canonical が無いから配る瞬間に別扱いになる」→ 主因は別

JS に canonical が1つも無いのは事実（`web/` 配下で `store_aliases.json` を読むコードは
`golden_chains.json` の記録欄以外に無い）。ただし JS 側は表の鍵も引く側も
`normStoreName` で正規化しており、内部では整合している（`store-x-match.mjs`
`xAccountMap` / `siteHostMap` が鍵を正規化し、衝突鍵は削除する）。

配る瞬間にずれる主因は canonical の不在ではなく、`normStoreName` が語を落とすこと。
これで公式X表の 9 鍵が衝突して落ち、その9店は配る側で公式Xを1つも持てない。

```
カードラボ        : カードラボ→webshop_labo      / カードラボ店舗→cardlabo_info
トイザらス        : トイザらス→toizarasu_0906    / トイザらス店舗→toysrus_jp
ドラゴンスター    : ドラゴンスター→dorasuta_info / ドラゴンスター通販→ds_ecommerce
ヤマダデンキ      : ヤマダデンキ→yamada_official / ヤマダデンキ店舗→yamada_chusikok
TSUTAYA AZ岡南店 ほか4件（大文字/小文字違いの重複行に別handle）
```

上4件は「通販」「店舗」を語ごと落とす `normStoreName` だけが起こす衝突で、
`tenantKey`（語を落とさない）なら起きない。`tenant_key` はまさにこの事故
（`_norm("ドラゴンスター通販") == _norm("ドラゴンスター")`）を防ぐために
2026-08-16 に切り出された規則で、公式Xの引きにはまだ適用されていない。

### 追加で見つかった、より大きな欠陥（指示に無い）

生の表を正規化した鍵で引いている箇所が2つある。`store_x_accounts.json` の
鍵は生の表示名なので、正規化した鍵で `.get()` すると構造的に当たらない。

- `official_observations.py:391` — `SX.official_accounts().get(SX._norm(name)) == handle`
- `store_x_match.py:247`（`is_store_own_post`）— `known.get(_norm(store))`（`known` は `official_accounts()` の生の辞書）

実測: 表の 1,347 行のうち `SX._norm(鍵) == 鍵` なのは 465 行（34%）。
残る 882 行は、この2経路から一度も引けない。
実データの店名 1,555 種で見ると、`SX._norm` で当たるのは 510 種、
生の名前なら 1,347 種が当たる。

`official_observations.is_official_url()` は「そのX投稿を公式観測として採るか」の
判定なので、ここが 3 分の 2 外れているのは、まとめ由来比率が高い（公開の79%）
という既知の症状と向きが一致する。別名以前の問題として先に直す価値がある。

---

## 報告

### 1. 正規化の正本をどれにするか

#### 提案: `event_identity.norm` を「店の同一性」の正本にする

理由は4つ。

**(a) 店マスタが既にこの鍵で出来ている。**
`store_registry.store_key()` は `event_identity.norm` そのもの。
実測で `store_registry.json` の 3,312 行すべてが `norm(鍵) == 鍵` を満たす（例外0）。

**(b) 実データの店名が 100% マスタに載っている。**
配布行・候補台帳・公式X表・公式サイト表に出てくる店名 1,555 種すべてが
`event_identity.norm` の鍵で `store_registry.json` に存在する。
内訳は 公式X表 1,347/1,347・公式サイト表 131/131。
新しい辞書を作らなくても、いま全部引ける。

**(c) 設計書 §3-1 の店マスタが要求する欄が、すでに registry にある。**

| 設計書 §3-1 | store_registry の欄 | いまの状態 |
|---|---|---|
| 正規名 | `canonical_name` | 3,312 行すべてに有り |
| 表記ゆれ | `observed_names` | 3,346 件。2件以上ある行 153 |
| 公式Xアカウント | `x_candidates`（confirmed 1,189 行） | 有り |
| （統合） | `merged_into` | 0 行。欄はあるが1件も使われていない |

**(d) 変えるとコストが最も大きい鍵だから、こちらを動かさない。**
`event_identity.norm` は `event_id` の `seller` 欄に入る。規則を変えると
発番が総入れ替えになり、`RegistryRefusal` と配布行の event_id 崩壊
（「配布行を手で消すと event_id 台帳が壊れる」で経験済み）を招く。
正本にするとは「これに他を寄せる」ということで、これ自体は動かさない。

#### 各正規化が何を落とし、何を残すか（実測つき）

母集団 = 実データの店名 1,555 種。

| 正規化 | 群の数 | 他と同一視される店名 | 落とすもの | 残すもの |
|---|---|---|---|---|
| `store_canon._norm` | 1,531 | 24 | 空白・小書きカナ差・大小文字 | 全角半角の差（NFKC 無し）・記号 |
| `_ならす` | 1,543 | 12 | 全角半角・大小文字 | 空白・記号 |
| `event_identity.norm` | 1,520 | 35 | 全角半角・大小文字・空白・括弧/中黒/アンダースコア/スラッシュ/ハイフン | 語（通販・各店・公式） |
| `normStoreName` | 1,475 | 80 | 上記＋語（公式/オンライン/ネット/ショップ/ストア/店舗/各店/通販/トレカ/tcg/card/shop/store/official/◯号店） | — |
| `tenantKey` | 1,523 | 32 | 全角半角・大小文字・区切り記号 | 語・括弧 |
| `lot_key.norm_store` | 1,525 | 30 | 一部括弧・中黒・空白・全角英数のみ・電機→デンキ | 全角記号・大小文字以外 |

正規化どうしで群が食い違う店名の数（多い順・抜粋）:

```
_ならす            vs normStoreName   127 種
normStoreName      vs lot_key         110 種
store_canon._norm  vs normStoreName   107 種
event_identity     vs normStoreName    97 種
tenantKey          vs normStoreName    91 種
_ならす            vs lot_key           52 種
_ならす            vs event_identity    46 種
...
event_identity     vs tenantKey          6 種   ← ここだけ極端に近い
```

`event_identity.norm` と `tenant_key` は 6 種しか違わない。括弧・中黒を
落とすかどうかだけの差で、どちらも「語は落とさない」という同じ思想。
一方 `normStoreName` は語を落とすため、あらゆる相手と 90〜130 種でずれる。

#### 提案する役割分担（正本1本＋用途を限定した1本）

| 概念 | 正本 | 中身 |
|---|---|---|
| 店の同一性（この行はどの店か） | `event_identity.norm` ＋ `store_registry.merged_into` | 表の鍵も、引く側も、これで作る |
| 案件の鍵（この行はどの抽選か） | `lot_key`（現状のまま） | 利用者の localStorage に保存済みなので触らない。店の同一性とは別概念 |
| 投稿者が本人らしいかの緩い推定 | `store_x_match.looks_same_store` | 表の鍵には使わない。候補を積むためだけ |

廃止して正本へ寄せる: `store_canon._norm`、`_ならす`（店名用途）、`tenant_key`、
`build_lotteries_nyuka._norm_store_text` / `_主体キー`、`store_ledger._norm`、
`candidate_contract._norm`（店名用途）、`fill_review_from_evidence.なら`、
JS `normStoreName`（表の鍵としての用途）／`tenantKey`。

別名辞書は `store_aliases.json` から `store_registry.merged_into` へ移す。
いま別名辞書は canonical 37件・別名 58件しかなく、そのうち 21 組が registry では
別の行、37 組は片方が未登録。`merged_into` は 0 行＝未使用なので、
移し先はすでに空いている。「同じ店」の宣言が2か所にあるのが、この件の根であり、
設計書 §11-1「判定の定義は1か所に置く」がそのまま当てはまる。

#### 統一で既存データが何が変わるか

**重複判定**: `event_identity.norm` は `_ならす` より 23 種多く畳む（1,543→1,520 群）。
`normStoreName` からは 45 種畳まなくなる（1,475→1,520 群）。後者は畳みすぎの解消で、
上に挙げた「カードラボ／トイザらス／ドラゴンスター／ヤマダデンキ」の4店が
公式Xを取り戻す方向。

**店舗台帳の鍵**: 変わらない。`store_registry.store_key` は既に `event_identity.norm`。

**配布の店名表示**: `store_aliases.json` の宣言をそのまま `merged_into` へ移すと、
配布行 298 のうち 7 行（店名2種）の表示名が変わる。

```
CARDBOXワッセ店（SuperKaBoS+ゲオwasse店） → SuperKaBoS＋ゲオwasse店
トレカスタイル                            → トレカショップ「DANDAN」BASE店
```

候補台帳では 12 種が寄る（MINT GAMES 池袋 / MINT池袋店 / フルコンプ各店 /
ヤマシロヤ通販 など）。

#### 統一によって壊れる可能性のある箇所

1. **`event_id` の発番。** `seller` は `sales_channel_id` か `norm(store)`。
   `merged_into` を効かせて店名を寄せると seller が変わり、既存 event_id が
   引けなくなる行が出る。`resolve_event_id` は索引に当たらなければ新しいIDを
   発番するので、黙って二重発番になる。→ 寄せた店の行は
   `event_id_redirects.json`（人が確認した旧ID→現行ID）に載せる必要がある。
   ここが本件で一番危ない。
2. **`lot_key`（利用者の localStorage）。** 店名が変わると `applied:` の鍵が変わり、
   応募済みの印が孤立する。`lot_key` 側は触らない方針でも、店名そのものを
   書き換えるなら影響する。上の7行が該当。
3. **公式Xの衝突2組**（エディオン／GEO）。寄せると別々の handle が1鍵に潰れて
   両方落ちる。→ `merged_into` に載せる前に、どちらの handle が正かを人が決めるか、
   支店として分けて登録する必要がある。
4. **`tenant_key` の契約。** 「通販」「各店」「◯号店」は別主体という明示契約
   （`store_platforms.json` は「store は完全一致」）。`event_identity.norm` も語は
   落とさないので契約は保たれるが、`merged_into` で `ドラゴンスター通販 → ドラゴンスター`
   のような統合を入れると契約違反になる。統合の宣言は権限の判定より
   後段に置くか、権限だけ統合前の鍵で引くか、どちらかを決める必要がある。
5. **`store_x_match.looks_same_store` の4文字一致。** 正本を変えても、この関数は
   別の（緩い）規則のまま。用途を「候補を積むだけ」に閉じてある限り安全だが、
   ここを正本に寄せると「ポケモン」4文字で当たっていた挙動が変わる。

### 2. 店名で引いている全経路の一覧（origin/main = e65b7b97）

`store_canon` 列: ○=通す / ×=通さない / —=無関係。

#### A. 公式X（`store_x_accounts.json` を店名で引く）

| # | 経路 | 位置 | 表の鍵 | 引く側の鍵 | store_canon |
|---|---|---|---|---|---|
| A1 | `store_x_match.official_accounts()` | `store_x_match.py:125` | 生のまま返す | — | × |
| A2 | `store_x_match.is_store_own_post` | `store_x_match.py:247` | 生 | `SX._norm` | × 鍵の形が不一致 |
| A3 | `store_x_match.remember_candidate` | `store_x_match.py:296` | `SX._norm` で書く | `SX._norm` | × |
| A4 | `official_observations.is_official_url` | `official_observations.py:391` | 生 | `SX._norm` | ○（`name` は寄せ済み）だが 鍵の形が不一致 |
| A5 | `publish_reviewed_only.公式の告知を運ぶ` | `publish_reviewed_only.py:704-731` | `EX._ならす` | `EX._ならす`（配布行の店名） | × |
| A6 | `build_evidence_cache`（X投稿の突き合わせ） | `build_evidence_cache.py:957-1003` | `EX._ならす` | `EX._ならす` | × |
| A7 | `official_announce.公式Xの表` | `official_announce.py:179-216` | `SX._norm` | `SX._norm` | × |
| A8 | `official_x_intake.targets` | `official_x_intake.py:204` | handle→店名（逆引き・生の名前を値に） | — | × |
| A9 | `official_x_contract.handle_to_store` | `official_x_contract.py:332` | handle→店名（`_名`＝NFKC+strip） | — | × |
| A10 | `candidate_ai_index.seller_index` | `candidate_ai_index.py:75-110` | `_名`（NFKC+strip）→ sales_channel_id | 同 | × |
| A11 | `build_candidates_shadow.公式Xの登録` | `build_candidates_shadow.py:381` | 生の辞書をそのまま `candidate_contract` へ | — | × |
| A12 | `shadow_url_owner._正規化表` | `shadow_url_owner.py:313-330` | `SX._norm`（衝突鍵は削除） | `SX._norm` (197,231) | × |
| A13 | `register_x_from_evidence` | `register_x_from_evidence.py:79,163` | `EX._ならす` | `EX._ならす` | × |
| A14 | `store_x_watch.公式Xの表` | `store_x_watch.py:125-128` | `NY._主体キー`（tenant_key＋末尾「店」除去） | 同 | × |
| A15 | `fill_review_from_evidence` | `fill_review_from_evidence.py:28,123` | 独自の `なら` | 同 | × |
| A16 | `build_x_icons` | `build_x_icons.py:38` | 生 | — | × |
| A17 | JS `xAccountMap` → `店の公式ポストか` / `sourceRef` | `store-x-match.mjs:129`, `public-fields.mjs:316,373,390,660,693` | `normStoreName`（衝突鍵は削除） | `normStoreName` | ×（JSに実装が無い） |
| A18 | JS `publish-preview` | `publish-preview.mjs:49-52` | `normStoreName` | `normStoreName` | × |
| A19 | JS `candidate-review-api` | `candidate-review-api.mjs:132-135` | `normStoreName` | `normStoreName` | × |

19 経路すべてが `store_canon` を通していない。鍵の種類は 6 種類に割れている
（生 / `SX._norm` / `_ならす` / `_名` / `NY._主体キー` / 独自）。
そのうち A2・A4 は表と引きで鍵の形が違う（前節の欠陥）。

#### B. 公式サイト（`store_sites.json` を店名で引く）

| # | 経路 | 位置 | 鍵 | store_canon |
|---|---|---|---|---|
| B1 | `date_source.store_hosts` / `own_host` | `date_source.py:156,563` | 生の店名＋部分一致（親チェーンを継ぐ） | × |
| B2 | `date_source.foreign_owner` | `date_source.py:627` | 生＋`_親チェーン`(tenant_key)＋`_同じ主体` | ○（`_同じ主体` の中だけ） |
| B3 | `date_source.source_kind` | `date_source.py:698` | B1 経由 | × |
| B4 | `official_observations.is_official_url` ④ | `official_observations.py:395` | `own_host(寄せた名)` | ○ |
| B5 | `candidate_ai_index.seller_index` | `candidate_ai_index.py:83` | `_名` | × |
| B6 | `official_page_intake` ① | `official_page_intake.py:16` | `url_quality.host_belongs_to` | × |
| B7 | `build_store_logos` | `build_store_logos.py:161` | 生 | × |
| B8 | JS `siteHostMap` → `店の公式ページか` | `store-x-match.mjs:137`, `public-fields.mjs:329` | `normStoreName` | × |

`own_host` は正規化を一切していないうえ、`known in name` の部分一致で
親チェーンを継ぐ。ここだけ思想が違う。

#### C. 共有基盤（`store_platforms.json`）

| # | 経路 | 位置 | 鍵 | store_canon |
|---|---|---|---|---|
| C1 | `date_source.tenant_rules` / `tenant_allows` | `date_source.py:333,491` | `tenant_key` | × |
| C2 | `date_source.unowned_platform` | `date_source.py:809` | `tenant_key` | × |
| C3 | `shadow_url_owner._tenant_allows` | `shadow_url_owner.py:187,243,286` | `tenant_key` | × |
| C4 | `store_canon.canonical_store_for_url` | `store_canon.py:84` | `store_canon._norm` ＋ URL 完全一致 | ○（唯一） |
| C5 | `publish_reviewed_only.店名をURL限定で寄せる` | `publish_reviewed_only.py:503-518` | C4 を呼ぶ | ○ |
| C6 | `official_page_intake` ② | `official_page_intake.py:17` | C1 経由 | × |
| C7 | JS `tenantMap` / `tenantAllows` | `store-x-match.mjs:201`, `public-fields.mjs:336,657,675,700` | `tenantKey` | ×（JSに実装が無い） |

C 系列は `tenant_key` で統一されている（2026-08-16 の [P2] 指摘で揃えた）。
`store_canon` を通す経路は C4/C5 の `url_scoped` だけで、これは
「そのURLに限って寄せる」特殊規則。

#### D. 台帳・重複判定・ゴールデン

| # | 経路 | 位置 | 鍵 | store_canon |
|---|---|---|---|---|
| D1 | `store_registry.store_key` | `store_registry.py:106` | `event_identity.norm` | × |
| D2 | `store_registry.主体キー` | `store_registry.py:606` | `NY._主体キー` | × |
| D3 | `store_registry.表記の池` | `store_registry.py:805` | `store_key`。別名辞書の canonical と別名をそれぞれ別の鍵で足す | × |
| D4 | `event_identity.event_identity_parts.seller` | `event_identity.py:82` | `sales_channel_id` or `norm(store)` | × |
| D5 | `store_ledger.build` | `store_ledger.py:63` | `notify_open_lotteries.norm_store` | × |
| D6 | `build_lotteries_nyuka.store_identity` | `build_lotteries_nyuka.py:568` | `canonical_store` → `_norm_store_text` → roster keys | ○ |
| D7 | `build_lotteries_nyuka.merge_into` | `build_lotteries_nyuka.py:828,831,1424` | `r["store"] = canonical_store(...)` 値を書き換える | ○ |
| D8 | `candidate_round_fold.応募回を行の形に` | `candidate_round_fold.py:55` | `canonical_store` | ○ |
| D9 | `promote_candidate_decisions` | `promote_candidate_decisions.py:395,422` | `SC._norm(SC.canonical_store(...))` | ○ |
| D10 | `build_evidence_cache`（店の索引） | `build_evidence_cache.py:347,391,399` | `SC._norm(SC.canonical_store(...))` | ○ |
| D11 | `official_observations`（観測の突き合わせ） | `official_observations.py:200,355,480,696,772` | `canonical_store` | ○ |
| D12 | `materialize_official_lotteries` | `materialize_official_lotteries.py:137,163,265` | `canonical_store` | ○ |
| D13 | `round_links.店名の鍵` | `round_links.py:88-96` | `canonical_store` | ○ |
| D14 | `line_personal_notify` | `line_personal_notify.py:302,309` | `canonical_store` | ○ |
| D15 | `lint_posts` | `lint_posts.py:43` | `canonical_store` | ○ |
| D16 | `notify_open_lotteries.canonical_store_name` | `notify_open_lotteries.py:848` | ロスター照合 → `store_base`（`norm_store`） | × |
| D17 | `verify_lotteries.cross_verify` | `verify_lotteries.py:131` | D16 を呼ぶ | × |
| D18 | `notify_new_lotteries._bucket_records` | `notify_new_lotteries.py:1062` | D16 を呼ぶ | × |
| D19 | `link_golden_chains.store_keys_for` | `link_golden_chains.py:83` | `SC._norm(SC.canonical_store(...))` | ○ |
| D20 | `candidate_evidence_excerpt.store_identity` / `_索引` | `candidate_evidence_excerpt.py:236,264` | `_ならす` ＋ `_別名の表`（別名辞書を自前で読み直す） ＋ `EI.norm` | × |
| D21 | `cardchusen_official_links` | `cardchusen_official_links.py:222,246` | `canonical_store` | ○ |
| D22 | JS `store-chains.chainKey` | `store-chains.mjs:26` | `normStoreName` | × |
| D23 | JS `store-registry.ownerKey` | `store-registry.mjs:55` | `tenantKey` ＋末尾「店」除去 | × |

D は `store_canon` を通す経路が 11 ある一方、店マスタの鍵（D1〜D5）は
1つも通していない。これが本件の構図で、「同じ店」の判断が
配布データ側（D6〜D15・store_canon 経由）と
マスタ側（D1〜D5・event_identity.norm）の 2 系統に分かれている。

D20 が特に悪い。`candidate_evidence_excerpt._別名の表` は `store_aliases.json` の
canonical を自分で読み直して `_ならす` で鍵を作るので、`store_canon` の
`_specific_branch` フィルタ（支店名の別名を系列名へ潰さない安全弁）を通らない。
同じ辞書の2つ目の読み手であり、設計書 §11-2「値の一覧は正本1か所」に反する。

#### まとめ（経路数と store_canon 通過率）

| 分類 | 経路数 | store_canon を通す |
|---|---|---|
| A 公式X | 19 | 0 |
| B 公式サイト | 8 | 2（部分的） |
| C 共有基盤 | 7 | 2（url_scoped のみ） |
| D 台帳・重複・ゴールデン | 23 | 11 |
| 合計 | 57 | 15（26%） |

### 3. 直す順番の提案

「影響が小さく効果が大きい順」で 4 段に分ける。段1と段2は別名の話をしない。
別名を触る前に、鍵の形と表の作り方を先に揃える。

#### 段1: 鍵の形が合っていない2箇所を直す（別名と無関係・単独で効く）

- `official_observations.py:391` と `store_x_match.py:247` が、生の表を
  正規化した鍵で引いている
- 直し: `official_accounts()` を「正規化した鍵の表を返す」1本にする
  （読む場所を1つに寄せる設計は既にある。鍵の形が抜けているだけ）
- 効果: 表の 882/1,347 行（66%）が引けるようになる。公式観測の採否に直結
- リスク: 極小。当たらなかったものが当たるようになるだけ。ただし正規化で
  衝突する鍵は「どちらとも決めない」で落とす既存規則をそのまま適用する
- 検証: 公式観測として採られる件数の前後比較

#### 段2: JS の表の鍵を `normStoreName` から `tenantKey` へ寄せる

- いま `normStoreName` は「通販」「店舗」を語ごと落とすため、
  カードラボ／トイザらス／ドラゴンスター／ヤマダデンキの公式Xが衝突で落ちている
- `tenantKey` は同じ事故を防ぐために 2026-08-16 に作られた規則で、
  すでに共有基盤の権限（C 系列）では使っている
- 直し: `xAccountMap` / `siteHostMap` の鍵を `tenantKey` に変える。
  Python 側の対になる表（A5・A6・A7・A12・A13）も同じ鍵へ
- 効果: 4 店が公式Xを取り戻す。JS と Python の鍵が 1 種類減る
- リスク: 語を落とさなくなるので「ドラゴンスター」の登録が
  「ドラゴンスター通販」に効かなくなる。これは契約どおりの挙動
  （`store_platforms.json` は「store は完全一致」）だが、
  いま緩く当たっていた行が落ちる可能性があるので前後比較が要る
- 検証: 公式X一致の応募回数（現状 804）の前後比較。TSUTAYA 5 件の
  大小文字違い重複行はデータ側の問題なので、この段では直さない

#### 段3: 「同じ店」の宣言を `store_registry.merged_into` へ一本化する

- `store_aliases.json` の canonical 37 件・別名 58 件を `merged_into` へ移す
- `store_canon.canonical_store()` は registry を読むだけの薄い関数にする
  （呼び出し 11 箇所はそのまま動く）
- 移す前に、人が決める必要がある3件を先に片付ける:
  - エディオン ⇔ トレカキャピタル（handle が別）
  - GEO ⇔ ゲオ（handle が別）
  - 「通販」「各店」を含む統合（トレカプラザ55通販 / フルコンプ各店 /
    ヤマシロヤ通販 / ドラゴンスター通販）が `tenant_key` の別主体契約と
    ぶつからないか
- 効果: 「同じ店」の宣言が1か所になる。設計書 §11-1 を満たす
- リスク: `event_id` の再発番。寄せた店名は seller が変わるので、
  `event_id_redirects.json` に旧ID→現行IDを載せる作業が同時に要る。
  配布行 7 行・店名 2 種が対象（候補台帳では 12 種）
- 検証: 配布行 298 と event_id の増減を 0 に保てるか

#### 段4: 表の鍵を `event_identity.norm` へ揃え、正本以外の直書きを CI で落とす

- A/B/C/D の全 57 経路の鍵を `event_identity.norm` ＋ `merged_into` に寄せる
- JS 側は Python から書き出した生成物を読む（設計書 §11-2 の決まり3）。
  `store-name-norm-parity` の枠組みが既にあるので、材料を差し替える形で使える
- `store_canon._norm` / `_ならす` / `tenant_key` / `_主体キー` / `store_ledger._norm` /
  `_別名の表` を削除。正本以外で店名を正規化したら CI で落とす
- `lot_key` は触らない（利用者の localStorage の鍵）。
  「案件の鍵」と「店の同一性」は別概念として明示的に分ける
- 効果: 設計書 §11 を満たす。以後この形の食い違いが再発しない
- リスク: 一番大きい。57 経路の同時変更なので、段1〜3 が終わってからにする

#### 段を分ける根拠

段1・段2 は別名を1件も触らずに、いま落ちている引きを回復させる。
段3 は人の判断が 3 件要る。段4 は範囲が広い。
指示文の想定した直し（引く側に `canonical_store` を足す）は、
段3 を段1・段2 より先にやることに相当し、実測では当たりが 792→787 に減る。

---

## 根拠データ

- [2026-09-04-store-name-normalization.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-04-store-name-normalization.json)
  — `origin/main` = e65b7b97 の `lotteries.json` / `shadow_candidates.json` /
  `store_x_accounts.json` / `store_sites.json` / `store_registry.json` /
  `store_aliases.json` / `store_aliases_learned.json` を読んで数えた。
  母集団・正規化ごとの畳み具合・正規化どうしの食い違い・canonical 併用の前後比較・
  生の表を正規化鍵で引く欠陥・店マスタとの関係・寄せると潰れる公式X の組・
  書き換えられる配布行。

## 未確認・保留

- 段2 の「語を落とさなくなることで落ちる行」は、実際に `tenantKey` へ切り替えて
  配布を通さないと数えられない（表の鍵と引く側を同時に変える必要があるため、
  静的な集計では出せない）。
- `store_platforms.json` は 3 行しかなく、C 系列の実効範囲は小さい。
  段2 のリスク評価はこの前提。
- `fill_review_from_evidence.py` は `D:\cardbot\worktrees\notice-preview` を
  直接読む一時スクリプト。巡回からは呼ばれていないので、段4 では削除候補。
- 実装は行っていない。`D:\cardbot` の作業ツリーには一切触れていない
  （すべて `git show origin/main:<path>` で読み、集計はスクラッチパッドで実行）。
