# 段1: 公式Xの表を引く鍵の形を合わせる

セッション名: docs
日付: 2026-09-04（JST）
区切り/依頼名: 引きの別名対応・段1
対象: `origin/main` = f3f18226 → `40285963`（rebase 後）。実測値はすべてこの時点

関連: PR [#1269](https://github.com/shinonomeheta-ai/cardbot/pull/1269)（本体・private・**マージ待ち**）

## 受けた指示（原文）

> # 判断: 段1から実施。段2以降は段1の効果を見てから
>
> ## 前提の訂正を受け止めます
> 指示文の前提3つとも誤りでした。
>
> 1. 正規化は4種類ではなく8種類（写しを含めるとさらに多い）
> 2. 「引く前に canonical_store を通す」は実測で当たりが減る（792→787）。
>    表の鍵が生の表示名だからで、片側だけ寄せると今まで当たっていたものが外れる
> 3. JS の主因は canonical の不在ではなく normStoreName が語を落とすこと
>
> 実データに当てて逆効果と確認した上で報告した点が最も価値があります。
> そのまま実装させていたら悪化していました。
>
> ## 段1を実施してください【最優先】
>
> official_observations.py:391 と store_x_match.py:247 が、生の表を正規化した鍵で
> 引いている件。表1,347行のうち882行（66%）が構造的に到達不能というのは、
> 今日見つけた rebase と同じ型の欠陥です。
>
> - official_accounts() を「正規化した鍵の表を返す」1本にする
> - 衝突する鍵は既存規則どおり「どちらとも決めない」で落とす
> - 効果の検証: 公式観測として採られる件数の前後比較
>
> これは別名と無関係で、単独で効き、リスクが極小です。
>
> ## 段2は段1の後
> JS の表の鍵を normStoreName から tenantKey へ寄せる件。
> 段1の効果を実測してから着手してください。
> 「語を落とさなくなることで落ちる行」は静的には出せないとのことなので、
> 実装して前後比較を取る形になります。着手前に一度報告してください。
>
> ## 段3は判断が要る3件を先に
> エディオン⇔トレカキャピタル、GEO⇔ゲオ、「通販/各店」を含む統合。
> これらは人が決める必要があります。段2が終わってから、判断材料を整理して
> 報告してください。
>
> 判断の材料として欲しいもの:
> - それぞれの handle が実際にどの店の告知を出しているか（直近の投稿を実例で）
> - 統合した場合と分けた場合で、どちらが利用者にとって正しいか
>
> ## 段4は当面着手しない
> 57経路の同時変更はリスクが大きすぎます。段1〜3の効果を見てから、
> 改めて範囲を決めます。
>
> ## 正本の提案について
> event_identity.norm を店の同一性の正本にする提案に同意します。

## 指示と過去の報告の食い違い

**1点あります。指示どおりに実装すると配布データの店名が壊れます。**

指示は「`official_accounts()` を『正規化した鍵の表を返す』1本にする」でした。
前提（表の鍵と引く側の鍵が合っていない）は実測で確かめたとおり事実ですが、
`official_accounts()` **そのものの鍵**を変えると、表示名を必要とする呼び出し元が壊れます。

呼び出し元は11か所あり、うち少なくとも4か所が表示名を使っています。

| 呼び出し元 | 表示名の使い方 |
| --- | --- |
| `official_x_intake.targets()` | `handle → 店名` を作り、**その店名が候補台帳の `"store"` 欄へ入る**（`official_x_intake.py:369`） |
| `official_announce.py:179` | 自前の表の**値**として店名を持つ |
| `store_ledger.py:244` | 店の台帳へそのまま渡す |
| `register_x_from_evidence.py:164` / `build_evidence_cache.py:957` | 自分で `_ならす` して索引を作る（生の名前が前提） |

いちばん重いのは `targets()` です。鍵を正規化すると `TSUTAYA大垣店` が
`tsutaya大垣店` になり、**候補ID・配布データ・サイトの表示まで正規化名**になります。

そこで **`official_accounts()` の契約は変えず**、引くための表を
`official_accounts_by_key()` として別に1本立てました。「読む場所を1つに寄せる」
という設計意図はそのままで、壊れないことはテストで固定しています
（`test_取り込みは表示名を候補へ入れる`）。

なお指示文の「882行（66%）」は正確でした。実測は 882/1,347 = **65.5%** です。

## 報告

### 直したもの

```python
official_observations.py:391      SX.official_accounts().get(SX._norm(name))
                              →  SX.official_accounts_by_key().get(SX._norm(name))

store_x_match.is_store_own_post   _load_map().get(_norm(store))
                              →  official_accounts_by_key(table=_load_map()).get(_norm(store))
```

`official_accounts_by_key()` は `_norm(店名) → ハンドル` を返します。注記行（`_` 始まり）と
空の鍵・空のハンドルは入れません。

### 衝突は「どちらとも決めない」

ご指示どおり、正規化して同じ鍵に別のハンドルが並ぶものは鍵ごと落とします。
落とした鍵は `dropped` で受け取れます（黙って消さない）。実測9件。

| 正規化後の鍵 | 元の表示名 | ハンドル |
| --- | --- | --- |
| `tsutayaaz岡南店` | TSUTAYA AZ岡南店 / tsutayaaz岡南店 | tsutayaazkonan / tsutayaazkonant |
| `tsutayaウイングタウン岡崎店` | TSUTAYAウイングタウン岡崎店 / tsutayaウイングタウン岡崎店 | imagine_wto / wtokazaki_card |
| `tsutaya大垣店` | TSUTAYA大垣店 / tsutaya大垣店 | tsutaya_ogaki / tsutaya_ogaki_c |
| `tsutaya瀬戸店` | TSUTAYA瀬戸店 / tsutaya瀬戸店 | seto_tsutaya / seto_tsutaya_t |
| `tsutaya鈴鹿中央通店` | TSUTAYA鈴鹿中央通店 / tsutaya鈴鹿中央通店 | tsutaya_suzuka / tsutayasuzuka_c |
| `カードラボ` | カードラボ / カードラボ店舗 | cardlabo_info / webshop_labo |
| `トイザらス` | トイザらス / トイザらス店舗 | toizarasu_0906 / toysrus_jp |
| `ドラゴンスター` | ドラゴンスター / ドラゴンスター通販 | dorasuta_info / ds_ecommerce |
| `ヤマダデンキ` | ヤマダデンキ / ヤマダデンキ店舗 | yamada_chusikok / yamada_official |

**上5件は、同じ店が大文字違いで二重登録され、しかも別のハンドルが付いています。**
`store_x_accounts.json` 側のデータの問題で、人がどちらかを選べばその5店は引けるように
なります。下4件は本店/店舗/通販の分かれで、段3の論点と同じ形です。

### 実測（指示の「公式観測として採られる件数の前後比較」）

測ったのは `official_observations` の判定③（根拠のX投稿が「店本人の公式X」か）です。
候補台帳の根拠のうち、X投稿URLを持つ 1,145 件が対象。

| | 直す前 | 直したあと | 差 |
| --- | --- | --- | --- |
| 引ける鍵 | 465 | **1,319** | +854（衝突9件を落としたあと） |
| 「店本人の公式X」と判定 | 327 | **797** | **+470** |

内訳は **新たに認められた 490 件／公式でなくなった 20 件**。減った20件はすべて
上の衝突9鍵に由来し、意図した挙動です。

新たに認められた店（上位）:

```
9  TSUTAYAココアドバンス大村店      7  カードボックス カサモ関口商店
8  TSUTAYA あべの橋店              7  ジャスティス（大阪）
8  TSUTAYA広田店                   6  SuperKaBoS+GEO鯖江店
8  イエローサブマリン千葉ゲームショップ  5  TSUTAYA辰巳台店 ほか
```

`is_store_own_post` 側の効果は、ネットワーク照合を伴うため静的には数えられません。
鍵が引けるようになったぶん、これまで曖昧照合（`looks_same_store`）や候補積みへ
落ちていたものが**確定的に判定される**ようになります。

## テスト

新規14件（`test_official_x_lookup_key.py`）。関連する既存379件も緑
（`test_store_x_match` / `test_store_field` / `test_official_observations` /
`test_store_x_watch` / `test_store_registry` / `test_url_fields` /
`test_shadow_url_owner` / `test_own_source_not_posted`）。

### 手元の全件（同じ commit に置いて突き合わせ）

| | main（base `f3f18226`） | 段1（同じ base） |
| --- | --- | --- |
| | `FAILED (failures=10, errors=1)` / 7,105 tests | `FAILED (failures=10, errors=1)` / **7,119 tests** |

**赤の顔ぶれの差分はゼロ**でした。

### CI で1件だけ差が出た件（切り分け済み）

| | main（run 33855332518・head `a1bdf61e`） | この PR（run 33855926985・base `40285963`） |
| --- | --- | --- |
| | `failures=6` / 7,114 tests | `failures=7` / 7,128 tests |

差は `test_url_candidate.実データ.test_公開データの応募URLが減らない` の1件です。
**PR の base（`40285963`）と main の run（`a1bdf61e`）が別 commit**なので、
同じ base に揃えて切り分けました。

```
mainref（40285963・素の main） FAILED (failures=1)
gate   （40285963 + 段1）       FAILED (failures=1)
```

失敗のメッセージも同一です。

```
AssertionError: [] is not true : その行を吸収した先が見つからない（別商品まで畳んだ疑い）:
りらい(福島) / ポケモンカードゲーム MEGA 拡張パック 30th CELEBRATION BOX
```

**base のデータ由来で、この変更とは無関係**です。main の CI が緑なのは、より新しい
commit ではデータが変わって通っているためです。

Vercel の赤は author（Vercel プロジェクトの権限）起因でコードとは無関係です。

## 気づいた点（判断が要るもの）

**衝突9件のうち5件は、同じ店の二重登録です。** `store_x_accounts.json` に
`TSUTAYA大垣店` と `tsutaya大垣店` が別のハンドルで両方登録されています。
いまは安全側に倒して両方落としていますが、**人がどちらかを選べば5店ぶんが復活します**。
段3で扱う本店/店舗/通販の分かれ（4件）とは性質が違うので、先に片付けられます。
指示をいただければ、どちらのハンドルが実際にその店の告知を出しているかを
直近の投稿で確かめて出します。

## 状態

- PR #1269 を作成。**マージしていません**（指示待ち）。
- 段2（JS の表の鍵を `tenantKey` へ）は着手していません。ご指示どおり、
  段1の効果を見てから、着手前に一度報告します。
- 段3・段4は着手していません。
