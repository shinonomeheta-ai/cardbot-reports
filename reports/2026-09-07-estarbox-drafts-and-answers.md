# e-starbox の下書き20件と、回答1〜4（#1441）

セッション名: store-name-a
日付: 2026-09-07（JST）
区切り/依頼名: #1441 の条件b・回答1〜4・下書き20件
対象: `origin/main`（#1430 マージ後）

## 本部（M1g）の受付中

**8社**（2026-09-07 20:49 JST 実測）。前回（今朝の点検）は **16社**だったので、
**8社減っています**——増えていません。締切が過ぎた回が抜けたぶんです。

```
GIRAFULL 2 / ポケモンカードストア 2 / フルコンプ 2 / ドラゴンスター 2 /
晴れる屋2 2 / WonderGOO 1 / ファミマオンライン 1 / コジマ 1
```

## 受けた指示（原文）

> 条件a: コードのマージと、20件の台帳への追記を分けること。
> 条件b: --json の下書きを出す道具について、使う場所を全部列挙すること。数を先に答える。
> 1. 「応募先を出せる回 +20」のうち、本部の抽選は何回で、支店は何回か。
> 2. 「実測47件中1件」の 47 と、「一致20＋保留29＝49」の 49 が合わない。母数はそれぞれ何か。
> 3. 「名乗りが台帳と一致 20」と「shared_platform_owner_unconfirmed 20回」が同じ 20 なのは
>    偶然か、同じ集合か。
> 4. e-starbox の根拠 118本のうち 90本が official_unverified とのことだが、残り 28本は何か。

## 指示と過去の報告の食い違い

**あります。「応募先を出せる回 +20」は誤りでした。実際は 0 です**（回答3・1）。

---

# 条件b: 配線先は **0か所**

`estarbox_watch.py` を**どの workflow にも配線していません**。手で叩く道具です。

```
.github/workflows/*.yml  への参照   **0**
ほかの .py からの import            **0**
```

配線しない理由は、**この道具は書かないから**です。出すのは人が確かめるための
下書きだけで、巡回に置いても誰も読みません。**確かめる人が居るときに叩く**のが
正しい使い方です。

## 名乗りの照合をしている他の場所（片側配線の点検）

```
date_source.self_identified_ok()   登録が「いま台帳にその URL を名乗る行があるか」を見る
date_source._live_registrations()  読むたびに上を通す（tenant_rules / tenant_allows /
                                   source_kind / unowned_platform が全部ここを通る）
resolve_urls.py:503                同じ判定を配布側でも通す
```

**私の道具はこの3か所のどれとも競合しません。** あちらは「登録が使えるか」を
見るもので、私のは「登録の下書きを作る」もの。**判定は増やしていません**
（照合は `date_source.tenant_key` を借りているだけ）。

---

# 回答

## 1. 「応募先を出せる回 +20」の本部/支店 → **前提が誤りでした。0回です**

下書き20件のURLと、`shared_platform_owner_unconfirmed` の回の集合を突き合わせた
結果、**重なりは0**でした（回答3）。ですから**この20件を登録しても、いま出せる
ようになる回は0回**です。将来その URL の回が来たときに効きます。

**いま出せていない回の実態は別**にあります。`shared_platform_owner_unconfirmed`
で e-starbox のURLを持つ回のうち、**16回は既に登録があるのに出せていません**。

```
支店   13回     本部/通販  3回     M1g のカードに載るもの **0**
   SuperKaBoS＋ゲオwasse店 / ときわ書房本八幡スクエア店 /
   カードボックス ブックスジュピター店 / カードボックス 本の王国大垣店 /
   カードボックス田中書店イオンモール都城駅前店 / ＣＢ田中書店イオンモール都城駅前店 /
   CARDBOXワッセ店（SuperKaBoS+ゲオwasse店） / ブックセンター江戸屋
```

**§3-1-1 のとおり、支店はゴールデンのカードに入りません。** 16回は全部カード外です。

### なぜ登録があるのに出せないのか（追加で分かったこと）

`date_source.self_identified_ok()` が読むたびに落としていました。**自己申告の
登録は、いま台帳にその URL を名乗る行があるときだけ使える**という決まりです。

```
その URL を名乗っている行が台帳に無い    40件   ← 締切が過ぎて行が消えたぶん。設計どおり
複数の店が同じURLを指している              5件   ← **別名の問題**
通る                                       10件
```

「複数の店が同じURLを指している」の中身はこうでした。

```
CARDBOXワッセ店（SuperKaBoS+ゲオwasse店）  ⇔  SuperKaBoS＋ゲオwasse店
カードボックス田中書店イオンモール都城駅前店   ⇔  ＣＢ田中書店イオンモール都城駅前店
```

**同じ店を2通りに書いているだけ**です。別名表で寄せれば、この5件は通ります。
**登録を足すより、別名を寄せるほうが効きます**——ただし今日ジョーシンで踏んだ
とおり「寄せ先を変えると `event_id` が動く」ので、締切を先に数えてから出します。

## 2. 47 と 49 の母数

**同じものを2通りに数えていました。**

```
78   e-starbox のURL（全部）
29   うち登録済み
49   **うち未登録** ← 「一致20＋保留29」の母数
47   **回ごとに先頭の1本だけ**を見た数 ← `official_route` を試したときの母数
```

47 は「回を1件ずつ見て、その回が持つ e-starbox のURLの**先頭1本**」を数えた
ものです。1つの回が2本持つ場合に2本目を数えていません。**母数の取り方を
そろえていなかった私のミス**で、正しい母数は **49** です。

`official_route` の当たりは、49 で数え直しても **1件**のままです。

## 3. 「一致20」と「未確認20」は **偶然。集合の重なりは0**

```
一致20   **URL 20本**（店は13店）
未確認20 **回 20**
重なり   **0**
```

単位も違い（URL と 回）、中身も重なりません。**同じ20だと読める書き方をしたのは
私の誤りです。**

未確認20回の側の内訳は上（回答1）のとおりで、**16回は登録済み・4回は名乗りが
食い違う・2回はページが名乗っていない**でした（1回が複数URLを持つので合計は
20を超えます）。

## 4. 残り28本は `unofficial`

```
90本   authority=official_unverified  page_role=application  owner_scope=unknown
28本   authority=unofficial           page_role=unknown      owner_scope=unknown
```

28本は**まとめサイト経由で拾ったときの保存値**です。`source_of()` はホストが
取れれば `official_unverified` を付けますが、**まとめのURLから辿った根拠は
`unofficial` のまま**保存されます。`is_official_source` は `official*` で
始まらないので False——**設計どおり**で、直す対象ではありません。

---

# 条件a: 台帳への追記は分けます

**#1441 はコードだけ**で、`store_platforms.json` を1文字も触っていません。
**20件の追記は、ci の移行（`migrate_identity_drop_url.py`・鍵1,901本）が
終わってから**にします。同じ台帳を2セッションが同時に書く形は作りません。

---

| # | 店名 | 台帳の名乗り | ページ側の名乗り | 本部/支店 | store_evidence の URL |
|---|---|---|---|---|---|
| 1 | ブックセンター江戸屋 | ブックセンター江戸屋 | ブックセンター江戸屋 | 本部/通販 | https://shoplottery.e-starbox.com/lottery/entry?code=uWs3fDCGHt |
| 2 | SuperKaBoS＋ゲオ二の宮本店 | SuperKaBoS＋ゲオ二の宮本店 | SuperKaBoS+ゲオ二の宮本店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=Raxwdgphkq |
| 3 | 北国書林松任店 | 北国書林松任店 | 北国書林松任店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=GI6QeuhkWb |
| 4 | 北国書林松任店 | 北国書林松任店 | 北国書林松任店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=bicpPurGDN |
| 5 | CARDBOX宇和島店 | CARDBOX宇和島店 | CARDBOX宇和島店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=oUM24n3HF6 |
| 6 | きくざわ書店ナッピィモール店 | きくざわ書店ナッピィモール店 | きくざわ書店ナッピィモール店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=ZdpfsNIw23 |
| 7 | カードボックス 本の王国大垣店 | カードボックス 本の王国大垣店 | カードボックス本の王国大垣店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=Aorg0l86Iv |
| 8 | SuperKaBoS+GEO鯖江店 | SuperKaBoS+GEO鯖江店 | SuperKaBoS+GEO鯖江店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=tcZP4eD82M |
| 9 | ブックセンター江戸屋 | ブックセンター江戸屋 | ブックセンター江戸屋 | 本部/通販 | https://shoplottery.e-starbox.com/lottery/entry?code=KbeWBrpTnM |
| 10 | ブックセンター江戸屋 | ブックセンター江戸屋 | ブックセンター江戸屋 | 本部/通販 | https://shoplottery.e-starbox.com/lottery/entry?code=jYsSHRtJel |
| 11 | SuperKaBoS＋ゲオwasse店 | SuperKaBoS＋ゲオwasse店 | SuperKaBoS+ゲオwasse店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=ytiK4jLXBW |
| 12 | ときわ書房ニューコースト新浦安店 | ときわ書房ニューコースト新浦安店 | ときわ書房ニューコースト新浦安店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=nbmj6yq4dH |
| 13 | きくざわ書店ナッピィモール店 | きくざわ書店ナッピィモール店 | きくざわ書店ナッピィモール店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=kYPXAGvrzF |
| 14 | SuperKaBoS敦賀店 | SuperKaBoS敦賀店 | SuperKaBoS敦賀店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=lZfdcSXuIP |
| 15 | ときわ書房ニューコースト新浦安店 | ときわ書房ニューコースト新浦安店 | ときわ書房ニューコースト新浦安店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=L6nmZ7lqKc |
| 16 | カードボックス ブックスジュピター店 | カードボックス ブックスジュピター店 | カードボックス ブックスジュピター店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=0PUlp7E5ST |
| 17 | カードボックス 津店 | カードボックス 津店 | カードボックス津店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=oIYROc4i7J |
| 18 | カードボックス船橋駅前店 | カードボックス船橋駅前店 | カードボックス船橋駅前店 | 支店 | https://shoplottery.e-starbox.com/lottery/entry?code=IFxT7iJXap |
| 19 | ブックセンター江戸屋 | ブックセンター江戸屋 | ブックセンター江戸屋 | 本部/通販 | https://shoplottery.e-starbox.com/lottery/entry?code=tuf751UWQ9 |
| 20 | ブックセンター江戸屋 | ブックセンター江戸屋 | ブックセンター江戸屋 | 本部/通販 | https://shoplottery.e-starbox.com/lottery/entry?code=AMx67EubTW |

## 1件ずつの中身（本人が URL を開いて突き合わせる用）

### 1. ブックセンター江戸屋
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=uWs3fDCGHt
* store_evidence: 題の先頭「応募：【ブックセンター江戸屋】」
* product_evidence: 応募：【ブックセンター江戸屋】ポケモンカード MEGA 拡張パック「メガシンフォニア」1BOX（販売価格税込：5,400円）購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/09/04 21:00:00 ～ 2026/09/06 21:00:00

### 2. SuperKaBoS＋ゲオ二の宮本店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=Raxwdgphkq
* store_evidence: 題の先頭「応募：【SuperKaBoS+ゲオ二の宮本店】」
* product_evidence: 応募：【SuperKaBoS+ゲオ二の宮本店】9月11日再販ポケモンカード『ストームエメラルダ』『メガブレイブ』『メガシンフォニア』拡張パック購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/08/31 09:30:00 ～ 2026/09/06 23:59:59

### 3. 北国書林松任店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=GI6QeuhkWb
* store_evidence: 題の先頭「応募：【北国書林松任店】」
* product_evidence: 応募：【北国書林松任店】ポケモンカードMEGA 30th CELEBRATION「プレミアムデッキセット エーフィ・ブラッキー」購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/08/31 00:00:00 ～ 2026/09/07 00:00:00

### 4. 北国書林松任店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=bicpPurGDN
* store_evidence: 題の先頭「応募：【北国書林松任店】」
* product_evidence: 応募：【北国書林松任店】ポケモンカードMEGA拡張パック「30th CELEBRATION」購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/08/31 00:00:00 ～ 2026/09/07 00:00:00

### 5. CARDBOX宇和島店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=oUM24n3HF6
* store_evidence: 題の先頭「応募：【CARDBOX宇和島店】」
* product_evidence: 応募：【CARDBOX宇和島店】ポケモンカードゲームMEGA拡張パック「30th CELEBRATION」購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/09/05 15:00:00 ～ 2026/09/13 19:00:00

### 6. きくざわ書店ナッピィモール店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=ZdpfsNIw23
* store_evidence: 題の先頭「応募：【きくざわ書店ナッピィモール店】」
* product_evidence: 応募：【きくざわ書店ナッピィモール店】【キャンセル分・再販】ポケモンカードゲーム 『メガブレイブ』『メガシンフォニア』『ストームエメラルダ』購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/08/31 00:00:00 ～ 2026/09/06 23:59:59

### 7. カードボックス 本の王国大垣店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=Aorg0l86Iv
* store_evidence: 題の先頭「応募：【カードボックス本の王国大垣店】」
* product_evidence: 応募：【カードボックス本の王国大垣店】 再販 「9月再入荷ポケモンカード商品」購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/09/01 15:00:00 ～ 2026/09/04 21:00:00

### 8. SuperKaBoS+GEO鯖江店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=tcZP4eD82M
* store_evidence: 題の先頭「応募：【SuperKaBoS+GEO鯖江店】」
* product_evidence: 応募：【SuperKaBoS+GEO鯖江店】 9月11日再販ポケモンカード MEGA 拡張パック『メガブレイブ』『メガシンフォニア』『ストームエメラルダ』購入権抽選 | 抽選ロトボックス 当サービスでは広告が表示されます。抽選に応募する上で
* round_evidence: 2026/08/31 16:00:00 ～ 2026/09/06 23:59:59

### 9. ブックセンター江戸屋
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=KbeWBrpTnM
* store_evidence: 題の先頭「応募：【ブックセンター江戸屋】」
* product_evidence: 応募：【ブックセンター江戸屋】ポケモンカード MEGA 拡張パック「メガブレイブ」1BOX（販売価格税込：5,400円）購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/09/04 21:00:00 ～ 2026/09/06 21:00:00

### 10. ブックセンター江戸屋
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=jYsSHRtJel
* store_evidence: 題の先頭「応募：【ブックセンター江戸屋】」
* product_evidence: 応募：【ブックセンター江戸屋】 9月16日発売 ポケモンカード MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー1個（販売価格税込：6,200円）購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/09/04 21:00:00 ～ 2026/09/11 21:00:00

### 11. SuperKaBoS＋ゲオwasse店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=ytiK4jLXBW
* store_evidence: 題の先頭「応募：【SuperKaBoS+ゲオwasse店】」
* product_evidence: 応募：【SuperKaBoS+ゲオwasse店】9月11日再販ポケモンカード『ストームエメラルダ』『メガブレイブ』『メガシンフォニア』拡張パック購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/08/31 15:00:00 ～ 2026/09/07 23:59:59

### 12. ときわ書房ニューコースト新浦安店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=nbmj6yq4dH
* store_evidence: 題の先頭「応募：【ときわ書房ニューコースト新浦安店】」
* product_evidence: 応募：【ときわ書房ニューコースト新浦安店】ポケモンカード「30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー」購入権抽選 | 抽選ロトボックス 当サービスでは広告が表示されます。抽選に応募する上で、クレジットカー
* round_evidence: 2026/08/31 00:00:00 ～ 2026/09/06 23:59:59

### 13. きくざわ書店ナッピィモール店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=kYPXAGvrzF
* store_evidence: 題の先頭「応募：【きくざわ書店ナッピィモール店】」
* product_evidence: 応募：【きくざわ書店ナッピィモール店】ポケモンカードゲーム『30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー』購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/09/07 00:00:00 ～ 2026/09/13 23:59:59

### 14. SuperKaBoS敦賀店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=lZfdcSXuIP
* store_evidence: 題の先頭「応募：【SuperKaBoS敦賀店】」
* product_evidence: 応募：【SuperKaBoS敦賀店】【再販分】「メガブレイブ」「メガシンフォニア」「ストームエメラルダ」購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/09/01 17:00:00 ～ 2026/09/06 22:00:00

### 15. ときわ書房ニューコースト新浦安店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=L6nmZ7lqKc
* store_evidence: 題の先頭「応募：【ときわ書房ニューコースト新浦安店】」
* product_evidence: 応募：【ときわ書房ニューコースト新浦安店】ポケモンカード「30th CELEBRATION」購入権抽選 | 抽選ロトボックス 当サービスでは広告が表示されます。抽選に応募する上で、クレジットカード情報の入力や金銭の支払いは発生しませんのでご
* round_evidence: 2026/08/31 00:00:00 ～ 2026/09/06 23:59:59

### 16. カードボックス ブックスジュピター店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=0PUlp7E5ST
* store_evidence: 題の先頭「応募：【カードボックス ブックスジュピター店】」
* product_evidence: 応募：【カードボックス ブックスジュピター店】ワンピースカード ブースターパック「世界最強の戦士」購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/09/02 18:00:00 ～ 2026/09/08 23:59:00

### 17. カードボックス 津店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=oIYROc4i7J
* store_evidence: 題の先頭「応募：【カードボックス津店】」
* product_evidence: 応募：【カードボックス津店】「ポケモンカード ストームエメラルダ」再販分購入権利抽選 | 抽選ロトボックス
* round_evidence: 2026/09/04 21:00:00 ～ 2026/09/06 22:00:00

### 18. カードボックス船橋駅前店
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=IFxT7iJXap
* store_evidence: 題の先頭「応募：【カードボックス船橋駅前店】」
* product_evidence: 応募：【カードボックス船橋駅前店】9/16(水)発売ポケモンカードゲーム「30th CELEBRATION」関連商品購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/09/05 00:00:00 ～ 2026/09/09 23:59:59 2026

### 19. ブックセンター江戸屋
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=tuf751UWQ9
* store_evidence: 題の先頭「応募：【ブックセンター江戸屋】」
* product_evidence: 応募：【ブックセンター江戸屋】9月16日発売 ポケモンカード MEGA 「30th CELEBRATION」1BOX（販売価格税込：7,200円）購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/09/04 21:00:00 ～ 2026/09/11 21:00:00

### 20. ブックセンター江戸屋
* URL: https://shoplottery.e-starbox.com/lottery/entry?code=AMx67EubTW
* store_evidence: 題の先頭「応募：【ブックセンター江戸屋】」
* product_evidence: 応募：【ブックセンター江戸屋】 ポケモンカードゲーム MEGA 拡張パック「ストームエメラルダ」 （販売価格税込：6,000円）1BOX購入権抽選 | 抽選ロトボックス
* round_evidence: 2026/09/04 21:00:00 ～ 2026/09/06 21:00:00


---

## 判断していただきたいこと

1. **下書き20件は、いま登録しても出せる回が増えません**（回答1・3）。それでも
   先に登録しておくか、**16回の側（別名を寄せる／`self_identified_ok` の
   「台帳に名乗る行が無い」40件）を先に見るか**
2. **別名を寄せる2組**（ワッセ店・都城駅前店）を進めてよいか。寄せると
   `event_id` が動くので、動く行の締切を先に数えて出します

## 状態

- **#1441 はコードだけ。** データファイルは1つも触っていません
- **課金なし。** この作業で外部APIは1回も呼んでいません
- V5 の残り187回は ci の合図待ちのままです

