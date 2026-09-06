# Amazon の例外と、M1g の取得経路

セッション名: store-name-a
日付: 2026-09-06（JST）
区切り/依頼名: Amazon の方針変更・intake_routes の新設
対象: PR **#1372**（`6fc00d82`）／#1371 は**クローズ**

## 受けた指示（原文）

> Amazon の方針が変わりました。巡回は作りません。
> ## 本人の判断
> Amazon は例外として、まとめの記述を値として使ってよい。
> 理由: 招待制で常設・利用者は Amazon で検索すれば見つかる・ボット対策のコストが高い。
> ## やること
> 1. M1g の Amazon を「まとめ由来でも受付中にしてよい」例外として登録
> 2. カードの表示: 「受付中」。応募URL は出さない。「Amazon で招待リクエスト受付中」の案内だけ
> 3. 設計書 §0-1 原則1 に、Amazon を例外として明記。理由も
> 4. 配信の関門（P）で、Amazon の行は「公式根拠1本以上」の条件を免除
> ## 注意
> - 例外は Amazon だけ。他の店に広げない
> - 「まとめの値を使う」のは「受付中かどうか」だけ。商品名・締切は使わない（常設なので）

（追って）

> 補足: Amazon の例外について。
> まとめの記述を使うのは「受付中かどうか」の状態だけ。
> まとめの X 投稿の URL や、まとめサイトのページを応募先として出してはいけません。
> カードの表示: 状態 受付中／応募先 なし（URL を出さない）／
> 案内「Amazon で招待リクエスト受付中」のテキストだけ／
> 根拠 内部では「まとめ由来」と記録するが、画面には出さない
> まとめの URL が画面に出る形になっていたら、それは誤りです。実装後に確認してください。

（さらに）

> M1g に「取得経路」の欄を足してください。店ごとに、どこを見に行けば取れるかを決め打ちする。
> intake_routes: ["official_x", "official_site", "livepocket", "instagram", "roundup"] のような配列。
> Hobby Zone: instagram ／ KIDDY LAND: livepocket ／ Amazon: roundup ／
> イオンスタイルオンライン: official_site ／ 他は今日の調査から分かる範囲で
> 収集側は次の PR で。経路が未実装の店は T で「経路なし」として出す。
> 設計書 §3-1 に「取得経路を店ごとに持つ」を追記。

## 指示と過去の報告の食い違い

なし。**#1371（S5 の巡回）はクローズしました。**

---

## 1. Amazon の例外

```
golden_chains.json（Amazon だけ）
   always_open        true
   always_open_note   "Amazon で招待リクエスト受付中"
   roundup_state_ok   true
   intake_routes      ["roundup"]
```

### 画面 — 応募URLは1本も出しません

```
カード   常に「受付中」。件数は付けない（回が無いので「0件」は嘘になる）
        残り時間も NEW も出ない（回を持たないため）
シート   「Amazon で招待リクエスト受付中」の一言だけ
```

やり方は「出さないように気をつける」ではなく、**描く材料を渡さない**です。
`chainState` が例外の店には**回を1件も返しません**（`open: []` / `upcoming: []`）。

### 「まとめの URL が画面に出ないか」の確認

`node_modules` の無い作業木なので**描画では見ていません**。代わりに、
**URL を描く場所が残らないこと**を実データで2点押さえました。

```
まとめのURLを持つ Amazon の行を、実物の golden_chains.json へ流す
   (1) splitByGolden が行リストへ出さない      → 応募先のリンクが描かれない
   (2) chainState がカードへ回を渡さない        → 描く材料が無い
```

試験（`実データ: まとめ由来の Amazon の行があっても、URL は画面のどこにも出ない`）
に固定しました。**本番の目視は、マージして反映されてからやります。**

### 配信の関門（P）

この店だけ「公式根拠を1本以上」を免除します。**ただし通した行は応募先のURLを
空にしてから配ります。**

```
apply_url / url / candidate_url / announce_url / source_url  → 空
url_status → none
```

画面は上のとおり塞いでありますが、**通知やX投稿は lotteries.json を直接読む**ので、
そちらから出る道も断ちました。

免除の在り処は店マスタ1か所（`roundup_state_ok`）。**例外は Amazon だけ**で、
試験が「1社であること」を留めます。

### 設計書

§0-1 原則1 に例外と**4つの理由**（告知が存在しない／常設で状態が変わらない／
利用者は検索すれば見つかる／巡回コストが高い）、§8-1 に免除を書きました。

---

## 2. M1g の取得経路 `intake_routes`

54チェーン全部に入れました。**公式X・公式サイト・EC一覧の登録と、応募URLのホスト**
から機械で導出し、**今日の実測4店は手で決め打ち**しています。

```
Hobby Zone            ["instagram"]        @hobbyzone_official・経路は未実装
KIDDY LAND            ["livepocket"]       支店ごと
Amazon                ["roundup"]          例外・受付中の状態だけ
イオンスタイルオンライン   ["official_site"]    aeonretail.com
```

```
official_site 48 ／ official_x 39 ／ livepocket 5 ／ instagram 1 ／ roundup 1
```

### T に `R` の段 — 「経路なし」が3件

```
no_route 3
   Hobby Zone    instagram だけ
   KIDDY LAND    livepocket だけ
   GIRAFULL      livepocket だけ
```

**これが経路を新設する優先順位です。** `livepocket` を未実装に数えたのは、
URLの判定（共有基盤の持ち主登録）と本文取得はあるのに、**その店の新しい
イベントを見つける経路が無い**ためです——livepocket のURLは、いまは
まとめ・X 経由でしか入ってきません。

> **livepocket の経路を作れば2件（KIDDY LAND・GIRAFULL）が解ける**、という
> 読み方ができます。Instagram は1件です。

語彙は `vocab_master.INTAKE_ROUTE` に置き、履歴へ追記して `vocab.gen.mjs` を
作り直しました（画面側も同じ語を読めます）。

**収集側はまだ全経路を試す形のまま**です（ご指示どおり、次の PR で変えます）。

---

## 3. #1371 から持ち越したもの

- `_weak_identity` に **Amazon**（移管済みの広報アカウント・取り込み0件）。
  ホビーゾーンの記述にも休眠の実測を追記。**登録は外していません**（#29 完了）
- 設計書 **§6-5** に「店頭でしか告知されない案件は収集できない」
  （Hobby Zone の実測・66店舗中61店が未登録）

**#1371 はクローズしました。** S5 の実装（`amazon_invite_watch.py`・workflow・
passrate の S5・語彙）は**ブランチに残してあるので、必要になったら開き直せます**。

## 試験

```
python -m unittest test_golden_chains_data test_passrate_m1g test_vocab_master
                   test_shadow_url_owner test_line_endings test_ci_triggers   116件 OK
node --test app/*.test.mjs app/lib/*.test.mjs                                2,851件 OK
```

CI は走っている最中です。main との突き合わせは終わり次第お知らせします。

## 判断していただきたいこと

1. **PR #1372 をマージするか。**
2. **livepocket の経路を作るか。** 「経路なし」3件のうち2件がこれです。
   Instagram（1件）より先に効きます。

## 状態

- **課金はありません。**
- 収集の workflow は**1つも触っていません**。
- 本番の目視は**まだしていません**（作業木に `node_modules` が無いため）。
  マージ後に確認します。
