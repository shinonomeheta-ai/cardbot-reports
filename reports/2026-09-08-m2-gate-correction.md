# 訂正: 「関門で40回開く」は誤りでした（締切の関門を数え落とし）／⑳ の25組／PR を分けました

セッション名: product
日付: 2026-09-08（JST 深夜）
対象: `origin/main`
前の報告: https://raw.githubusercontent.com/shinonomeheta-ai/cardbot-reports/main/reports/2026-09-08-m2-gate-connection.md
根拠データ: https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-08-m2-fold-guard-future25.json

---

## 0. 結論（3行）

1. **前の報告の「40回」は誤りです。** `missing_identity` は締切の関門より**前**に判定されるので、締切が無い回（131）と過ぎた回（25）も数に入っていました。**締切が未来なのは 8 回**で、そのうち関門を開けて実際に増えうるのは **1 回**です。
2. **store-name-a の「いま作っても0件」が正しい**と分かりました。しかも本人が実装して測ったところ、関門だけ開けると **+1 が「Antigravity エクスプローラーバンドル」**（家電）で、M2 の関門を足して ±0 に戻っています。
3. ⑳ の締切が未来の 25 組を出しました（下表）。**24 組は 拡張パック（m6a）× プレミアムデッキセット（mf）** の形で、本当に別商品です。

---

## 1. 訂正: 40回 → 実質1回

`promote_candidate_decisions.AI昇格できるか` の判定の順です。

```python
if not str(c.get("store") or "") or not str(c.get("product") or ""):
    return False, "missing_identity"      # ← ここで数えていた
end = str(r.get("apply_end") or "")[:10]
if not end or end < 今日:
    return False, "ended_or_no_end"       # ← 締切の関門は「あと」
```

**身元の関門を開けても、次の締切の関門で落ちます。**

| `missing_identity`（AI の結果がある回・全期間） | 回 |
|---|---:|
| 締切なし | **131** |
| 締切が過去 | 25 |
| **締切が未来**（次へ進める） | **8** |
| 合計 | 164 |

締切が未来の 8 回の中身です。

| 店 | 締切 | AI の商品 | ⑱ の本文 |
|---|---|---|---|
| ヤマダデンキ | 09-13 | お手元テレビスピーカー | × |
| ビックカメラ | 09-11 | Antigravity エクスプローラーバンドル | × |
| TC バトロコsatellite静岡駅前 | 09-08 | （なし） | **◯** |
| イオン店舗 ×2・カードマックス秋葉原店・バトロコ札幌大通・お宝創庫 | 09-08〜09-30 | （なし） | × |

**AI で埋まる 2 回はどちらもトレカでない商品**なので配信すべきではありません。実際に増えうるのは **⑱ 由来の 1 回**だけです。

### store-name-a の実測が、この警告どおりでした

本人が関門を実装して測った結果を受け取りました。

```
直す前          new_rows 30
関門だけ        new_rows 31   ← +1 が「Antigravity エクスプローラーバンドル」
関門＋M2        new_rows 30   ← ±0。混入せず、配線だけが入る
```

**関門を開けた効果が、そのままトレカでない回の混入になりました。** M2 を関門に入れて戻っています。

---

## 2. 164 の時点・母数・定義（ci の 81 との差）

```
時点  2026-09-08 深夜（JST）・origin/main
母数  候補台帳の全応募回のうち、**AI の結果がある回**（shadow_candidate_ai.json に行がある）
定義  promote_candidate_decisions.AI昇格できるか(c, r, res, 今日) が "missing_identity" を返す回
      **締切で絞っていない**（この関門は締切より前に判定されるため）
```

**ci の 81 は再現できていません。** 母数か時点が違うはずですが、ci の数え方を確かめていないので、差がどこから来るかは言えません。store-name-a が `promote --json` の除外一覧で数えると **0** になるそうで（AI レーンの理由が除外一覧に記録されず `no_human_decision` として出るため）、**3 通りの数え方で 164 / 81 / 0 になっています**。数を出すときは、この3つのどれで数えたかを言う必要があります。

---

## 3. ⑳ が止める組のうち、締切が未来の 25 組

| 店名 | 締切 | 商品A | 商品B | 理由 |
|---|---|---|---|---|
| フルコンプ（八王子本店・立川南口店・町田店・吉祥寺店・新宿南口店・大阪日本橋店・仙台駅前店・福岡天神店・札幌駅前店） | 2026-09-08 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1（pokemon:m6a） | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | different_product_id |
| TSUTAYA福井高柳店 | 2026-09-09 | ポケモンカードゲーム MEGA 拡張パック「メガブレイブ」（再販）（pokemon:ex-m1-拡張パックメガブレイブ） | ポケモンカードゲーム MEGA 拡張パック「メガシンフォニア」（再販）（pokemon:ex-m1-拡張パックメガシンフォニア） | different_product_id |
| カードボックス船橋駅前店 | 2026-09-09 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1（pokemon:m6a） | different_product_id |
| ドラゴンスター各店 | 2026-09-09 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1（pokemon:m6a） | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | different_product_id |
| バトロコ東武宇都宮 | 2026-09-09 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | different_product_id |
| TC バトロコ札幌狸小路 | 2026-09-10 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | different_product_id |
| TC バトロコ福島駅前 | 2026-09-10 | ポケモンカードゲーム MEGA「30th CELEBRATION プレミアムデッ（pokemon:mf） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1（pokemon:m6a） | different_product_id |
| MINT 吉祥寺店 | 2026-09-11 | ポケモンカードゲーム MEGA 拡張パック 30th CELEBRATION B（pokemon:m6a） | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | different_product_id |
| 文教堂 南大沢店【トレカ】 | 2026-09-11 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | ポケモンカードゲーム MEGA スタートデッキ100 バトルコレクション（pokemon:ex-mc） | different_product_id |
| ときわ書房 本八幡スクエア店 | 2026-09-12 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | different_product_id |
| 晴れる屋2各店（店舗） | 2026-09-12 | ポケモンカードゲーム MEGA「30th CELEBRATION プレミアムデッ（pokemon:mf） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | different_product_id |
| MINT GAMES池袋店 | 2026-09-13 | 30th（set_only） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1（pokemon:m6a） | set_only（当て先2種以上） |
| TC バトロコ川越駅前 | 2026-09-13 | ポケモンカードゲーム 拡張パック「30th CELEBRATION」（pokemon:m6a） | ポケモンカードゲーム 30th CELEBRATION プレミアムデッキセット （pokemon:mf） | different_product_id |
| TCバトロコ小田原駅前 | 2026-09-13 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | different_product_id |
| TSUTAYA須賀川店 | 2026-09-13 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | different_product_id |
| とれじゃらす別館（大阪難波・日本橋） | 2026-09-13 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | different_product_id |
| カードショップホビビ通販部 | 2026-09-13 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | different_product_id |
| カードショップ＠ほ～む。熊本店 | 2026-09-13 | ポケモンカード 拡張パック 30th CELEBRATION（pokemon:m6a） | ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフ（pokemon:mf） | different_product_id |
| トレカ専門店Vidaway佐沼店（TSUTAYA佐沼店） | 2026-09-13 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | different_product_id |
| トレカ専門店Vidaway白河立石店（TSUTAYA白河立石店内） | 2026-09-13 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | different_product_id |
| バトロコ金沢駅前 | 2026-09-13 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1（pokemon:m6a） | 30th CELEBRATION（set_only） | set_only（当て先2種以上） |
| ミント名古屋店（アルペンナゴヤ6F） | 2026-09-13 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | different_product_id |
| TC バトロコ横浜伊勢佐木町 | 2026-09-14 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（pokemon:m6a） | different_product_id |
| 福福トレカ（通販店・秋葉原店・池袋店本館） | 2026-09-14 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1（pokemon:m6a） | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッ（pokemon:mf） | different_product_id |
| ポケモンセンターオンライン | 2026-09-16 | ポケモンカードゲーム MEGA「30th CELEBRATION カードセット」（set_only） | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」B（pokemon:m6a） | different_product_id |

**24 組は 拡張パック（m6a）× プレミアムデッキセット（mf）** です。ほかは TSUTAYA福井高柳店（メガブレイブ × メガシンフォニア）、文教堂 南大沢店（プレミアムデッキセット × スタートデッキ100）、`set_only` が 3 組（MINT GAMES池袋店・バトロコ金沢駅前・ポケモンセンターオンライン）。

**どれも同じ店が同じ日に別商品を売る形**で、畳むと片方が消えます。全件（締切が過去も含む 73 組）は前の報告の根拠データにあります。

---

## 4. PR を分けました

| PR | 中身 | 状態 |
|---|---|---|
| **#1473** | **⑱ 材料の本文にも辞書を当てる**（承認済み） | CI 実行中。通れば自分でマージします |
| **#1472** | **⑳ 商品が違えば畳まない**（目視待ち） | 題名を変えて据え置き。#1473 がマージされたら main を取り込んで ⑳ だけの差分にします |

#1472 の CI（⑱＋⑳ の状態）は失敗 5 で、**そのうち 2 件は最新 main の clean checkout でも赤**でした（`test_candidate_ai_runner` の抜粋の実データ試験 2 件・`test_lottery_overrides` 2 件・`test_url_candidate` 1 件）。**PR 固有の赤 0** です。

---

## 5. ⑱ 由来の回を関門に通す配線（store-name-a と分担を決めました）

store-name-a の `身元がそろうか(c, res生)` は台帳と AI の答えだけを見ます。**⑱ 由来の回（影の欄 `product_master.product_id`）を通す枝は、こちらの PR で足します。** 理由は本人の提案どおりで、

- 行の商品名を M2 の `title` から作る配線（`新規行を組む` 側）と**同じ変更**になるため。分けると「関門は開くが商品名が空の行ができる」状態になりうる
- 影の欄が何を持つか・`product_id` から `title` をどう引くかは M2 の中の話

**⑱（#1473）がマージされてから設計を出します。**

---

## 6. 測り方の記録（今日6回目・私の分）

**関門の戻り値だけを数えて、その後ろの関門を見ませんでした。** `missing_identity` は締切より前に判定されるので、締切が無い回も過ぎた回も同じ理由で止まります。「この関門を開けたら何回進むか」を答えるには、**開けた先の関門まで通して数える**必要がありました。

store-name-a が実装して測ったら +1 が家電だった、という結果と突き合わせて初めて自分の数の意味が分かりました。**数を出すときは「その数が何の手前で止まっている数か」を言う。**
