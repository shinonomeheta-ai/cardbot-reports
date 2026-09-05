# 商品マスタ（M2）: 公式サイトから正解を作る（調査と設計のみ）

日付: 2026-09-05　セッション: product　対象: `origin/main` 81231543（作業ツリーは使わず `git show origin/main:` で読んだ）
根拠データ:
- 公式一覧の写しと取り方 … https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-m2-official-sources.json
- 収集した商品名の分布・鍵の割れ方・提案との突き合わせ … https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-m2-name-distribution.json

コードもマスタも変更していない。外部サイトへの通信は GET のみ。

---

## 受けた指示（原文）

> # 商品マスタ（M2）: 公式サイトから正解を作る（調査と設計のみ）
>
> ## 背景
> 商品名の正規化ができていない。「30th CELEBRATION」だけの行が
> 拡張パックBOX・プレミアムデッキセット・カードセットのどれか判定できず、
> 「30th CELEBRATION BOX」と「拡張パック「30th CELEBRATION」1BOX」が別の商品として扱われる。
>
> 既存の product_master_proposal.json（468商品名→68クラスタ）は「今ある表記を寄せ合う」
> だけで正解が無い。正解は公式にある。
>
> ## 方針
> 1. 公式サイトから商品一覧を取り、M2 の正本にする
>    （正式名・弾・形態〔拡張パック/デッキ/セット/パック〕・発売日・型番）
> 2. 収集した商品名を、AI が M2 の中から選ぶ形で寄せる（新しい商品名を作らせない）
> 3. 寄せられないものは「弾は分かるが形態が不明」として保留
> 4. 新しい弾は公式から取り込む
>
> ## 調べること
> 1. 各ゲームの公式サイトに商品一覧があるか、どの形で取れるか
>    - ポケモンカード（pokemon-card.com）
>    - ワンピースカード（onepiece-cardgame.com）
>    - 遊戯王（yugioh-card.com）
>    - ドラゴンボール（dbs-cardgame.com）
>    取れる項目（正式名・弾・形態・発売日・型番）と、取り方（ページ構造・更新頻度）
> 2. 既存の product_master_proposal.json と event_identity.game_identity() の内容
>    - 何が使えるか、何が正解と食い違うか
> 3. 収集した商品名（候補台帳・配布データ）の表記の分布
>    - 正式名そのままが何件、弾の名前だけが何件、独自の書き方が何件
> 4. M2 の形の設計
>    - 弾 → 商品 の階層をどう持つか
>    - 「30th CELEBRATION」だけ（形態不明）をどう扱うか
>    - lot_key（弾に寄せる）と identity_key（生の商品名）との関係
>
> ## 注意
> - 調査と設計のみ。コードもマスタも変更しない
> - 案E（素性の鍵からURLを外す。ci が実装中）が入るまで、商品名を動かす実装はできない。
>   IDが動くため。設計まで
> - D:\cardbot の作業ツリーは使わず git show origin/main: で読む
> - 外部サイトへの通信は読み取り（GET）のみ

---

## 指示と過去の報告・実装の食い違い

1. **「468商品名→68クラスタ」は一致する。** `product_master_proposal.json` の counts は names 468 / clusters 68 / unclassified 103 / dropped 6。
2. **「30th CELEBRATION BOX と 拡張パック「30th CELEBRATION」1BOX が別の商品として扱われる」は、鍵によって違う。** 素性の鍵（`event_identity.norm`）では別（配布184行が51鍵に割れる）。利用者の鍵 `lot_key`（`lot_key.product_key`＝弾へ寄せる）では**既に同じ**（8鍵）。ただし `lot_key` は逆に**寄せすぎている**——「30th CELEBRATION」だけの行（形態不明）も「拡張パック「30th CELEBRATION」」も同じ `30thcelebration` になる（配布114行のうち弾名だけの行が15行、候補439行のうち98行）。指示の「別の商品として扱われる」と「同じ商品に潰れる」が**同時に**起きている（ci の報告 2026-09-05-identity-design §1 の「丸め方は逆だった」の訂正と同じ向き）。
3. 指示にある「拡張パックBOX・プレミアムデッキセット・カードセット」の3つに加えて、公式には **FUTURISTIC BOX**（特別セット）があり、収集にも出ている（配布1行・候補5行）。「30th CELEBRATION」だけの行の候補は4形態。

---

## 0. 結論（先に）

- **公式一覧は5ゲームとも機械で取れる。** 正式名・形態（公式の種別欄）・発売日・価格は全部取れる。**型番はワンピース／DB／遊戯王／ユニオンアリーナにはあり、ポケモンには無い**（詳細ページのURL slug `m6a` `mf` `furbox` が代わりになる）。JAN はどこにも無い。
- **既存の巡回（`*_news.py`）が既に公式一覧を読んでいるが、4つのうち3つは1頁目しか読んでいない**（ワンピース12件・DB 14件・ポケモンは一覧APIでなくニュース見出し）。M2 の正本にするには「全頁・全種別」に広げるだけで、新しい取得口は要らない。ポケモンだけは未使用の **JSON API（`/products/resultAPI.php`）**へ切り替える。
- **収集した商品名の分布**（候補台帳 1,888 行／配布 287 行）: 正式名を含む行は候補 48%・配布 56%。**弾名だけ**は候補 13%・配布 16%。弾名＋条件語（BOX・数量・価格）が候補 18%・配布 19%。複数商品の列挙 4%。読めない独自表記 3〜5%。商品名が空の候補が 14%（259 行・うち 119 行はゲームも空）。
- **`product_master_proposal.json` は正本にできない。** 68 の正規名のうち公式名と一字一句一致は 0。42 は公式名にゲーム名の前置きを足しただけで使えるが、**17 は公式に無い名前**で、うち明らかな誤りが4種（ドラゴンボールの弾をワンピースとして正規名にした／ハイクラスパックを拡張パックと呼んだ／店の売り方「9種セット」「3種」を商品にした／語順を入れ替えた）。AI に正規名を**作らせた**結果で、方針2「AI は M2 から選ぶだけ」の裏付けになる。
- **M2 の形**: `game → set（弾）→ product（公式一覧の1行）` の2層＋**販売単位（BOX／パック／1個）は商品でなく行の属性**。「30th CELEBRATION」だけは `set_id` 確定・`product_id` 空・`resolution=set_only` で保留。`lot_key` は弾（set）の名前、`identity_key` は `product_id`（既に `event_identity_parts` が `product_id` → `id:` を受ける口を持っている。**使われていないだけ**）。
- **弾の判定が4か所にある**（`lot_key.product_key` / `set-names.mjs setsForProduct` / `mark_similar_rounds.芯` / `unknown_sets.parts_of`）。設計書 §11 の分散そのもので、M2 の第1の効果はこの一元化。

---

## 1. 公式サイトの商品一覧（2026-09-05 取得・GET のみ）

| ゲーム | 取得口 | 形 | 件数（今回） | 正式名 | 弾 | 形態（公式の種別） | 発売日 | 型番 | 価格 | 過去分 | 既存の実装 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| ポケモン | `https://www.pokemon-card.com/products/resultAPI.php` | **GET で JSON**。`productType=expansion\|construction\|others\|peripheral`・`dateLowerY/M/D`・`dateUpperY/M/D`・`page` | 2025-01〜: 拡張 16・構築 9・その他 23（周辺は未取得） | `productTitle`（「拡張パック「30th CELEBRATION」」） | 名前の「」内 | `productType`（拡張パック／構築デッキ／その他の商品／周辺グッズ）＋ 名前の先頭語（強化拡張／ハイクラス／拡張パックデラックス） | `releaseDate`（和文「2026年 9月16日（水）」） | **無い**。`link_detailPage` の slug（`/ex/m6/`・`30th…/product/m6a`）が代わり | `priceTxt` | `START_YEAR=1996` から日付範囲で全期間 | `pokecard_news.py` は `/info/` のニュース見出しから「」内を抜く。**一覧APIは未使用** |
| ワンピース | `https://www.onepiece-cardgame.com/products/?subcategory=boosters\|decks\|others&page=N` | HTML（サーバー描画）12件/頁 | boosters 2頁（2025-01〜）・全体1頁目は12件中ブースター2件 | `linkListColTitle` | 名前 | `data-cat`（boosters／decks／others）＋名前の先頭語（ブースターパック／エクストラブースター／プレミアムブースター／スタートデッキ） | `<time datetime>`（ISO） | **名前末尾【OP-17】** | あり | 2頁まで（2025〜） | `onepiece_news.py` は `/products/` の1頁目だけ（種別混在）。**subcategory も page も使っていない** |
| 遊戯王 | `https://www.yugioh-card.com/japan/products/` | HTML 内の JS `p[N]={…}` | **307**（2018〜） | `title` | 名前 | `class-key`／`class-name`（基本パック 35・コンセプトパック 59・スペシャルパック 18・スペシャルセット 17・構築済みデッキ 33・デュエリストアイテム 145） | `release-date`（和文・「10月下旬」あり） | `url` slug（`imph`）と `id`（`cg2142`） | `price-intax` | 全件1頁 | `yugioh_news.py` が同じ `p[N]` を読む（KEEP_KEYS で絞る）。**最も M2 に近い** |
| ドラゴンボール | `https://www.dbs-cardgame.com/fw/jp/products/?page=1..6`（＋`?tags=BoosterPack\|StarterDecks\|ACCESSORIES`） | HTML 14件/頁 | **76**（2024-02〜・6頁） | `cardText` | 名前 | 名前の先頭語（ブースターパック／スタートデッキ／スタートデッキEX／STORY BOOSTER／MANGA BOOSTER）・`tags` | `発売日`（`2026.09.12`） | **名前末尾 [FB11]** | あり | 6頁で全件 | `dragonball_news.py` は**1頁目14件だけ**。過去弾は `set_releases.json` の手入力に頼っている |
| ユニオンアリーナ（参考） | `https://www.unionarena-tcg.com/jp/products/` | HTML 1頁 | 185 | `js_productsTit` | 作品名 | `data-tags`（boosters 80／decks 37／other 68）＋作品コード | あり | slug（`icg-1`） | あり | 全件 | `unionarena_news.py` が同じ頁を読む |

**更新頻度**: どれもサーバー側の静的一覧で、新商品の発表時に増える。日次で読めば足りる（既存の巡回が毎日 `build_data.py` から `*_news.py` を呼んでいる）。ポケモンの API は日付範囲を渡す形なので、「直近2年」を毎日読み、新しい `link_detailPage` が出たら足す運用になる。

**取れないもの**: JAN はどこにも無い（`set_releases.json` の jan は手入力）。ポケモンの型番も無い。「1BOX の入数」は詳細ページの本文にある（`内容物：カード6枚入り`・遊戯王は `1ボックス：30パック入り`）が一覧には無い。

**ポケモンの30周年特設サイト** `https://www.30th.pokemon-card.com/product` は4商品（`m6a`＝拡張パック・`mf`＝プレミアムデッキセット・`furbox`＝FUTURISTIC BOX・`cardset`＝カードセット）を1頁に並べ、発売日・希望小売価格・内容物を持つ。一覧APIの `link_detailPage` がここを指すので、**APIの1行＝この頁の1商品**として突き合わせられる。カードセットは公式では**9つの個別商品**（「30th CELEBRATION カードセット ニャオハ・ホゲータ・クワッス」…）で、ロスターにある「カードセット (9種セット)」は店の売り方（9種を束ねて売る）であって公式の商品名ではない。

---

## 2. 既存資産の評価

### 2-1. `product_master_proposal.json`（2026-09-03・Haiku）

68 クラスタの正規名を、今回取った公式一覧と突き合わせた。

| 突き合わせ | 件数 |
|---|---|
| 公式名と一字一句一致 | **0** |
| 公式名を含む（「ポケモンカードゲーム MEGA」等の前置きを足しただけ） | 42 |
| 弾名までは一致するが形態語が公式と違う／無い | 9 |
| 公式一覧に当たらない | 17 |

当たらない17のうち、明らかな誤りが4種:

- `ONE PIECEカードゲーム ブースターパック BRIGHTNESS OF HOPE [FB11]` — **ドラゴンボールの弾**をワンピースの正規名にしている（型番 FB は DB フュージョンワールド）
- `ポケモンカードゲーム MEGA 拡張パック「MEGAドリームex」` — 公式は**ハイクラスパック**
- `30th CELEBRATION カードセット 9種`／`スターターセットex 3種`／`スターターセットMEGAex 3種` — **店の売り方**を商品名にしている（公式は9つ／3つの個別商品）
- `MEGA 30th CELEBRATION 拡張パック BOX` — 語順を入れ替え、販売単位 BOX を名前に含めている

残りは `4th Anniversary Set`・`プレミアムカードコレクション -ONE PIECE DAY'26-`・`スカーレットex / バイオレットex` など、公式一覧の期間外（2024以前）かイベント限定品。

**使えるもの**: variants の側（468 の生の表記とその出現数）。これは M2 の**別名表の材料**として再利用できる。正規名の側は捨てる。

### 2-2. `event_identity.game_identity()`

ゲームの5分岐（ポケ／onepiece・ワンピース／遊戯王／ユニオン／ドラゴンボール・dragonball）を部分一致で当て、知らない値はそのまま返す。**ゲーム軸としては十分**。ただし:

- `GAME_LABEL` に `gundam` があるが `game_identity` に分岐が無い（鍵が作れない表示名）
- `game_names.正準` が `GAME_LABEL` と**別の写し**を持つ（ドラゴンボールの表示が「ドラゴンボール」と「ドラゴンボールスーパーカードゲーム フュージョンワールド」で違う）。§11-2 の「写しの定数はずれる」型
- 候補台帳の `game` の値は12種類（`ポケモンカード` 1,266・`ONE PIECEカードゲーム` 281・空 119・`遊戯王` 93・`ドラゴンボール` 63・`ポケモンカードゲーム` 21・`ユニオンアリーナ` 16・`ポケカ` 12・`ワンピース` 11 …）。`game_identity` を通せば5つに寄るので、M2 は鍵 `pokemon|onepiece|yugioh|dragonball|unionarena` で持てばよい

### 2-3. いま「弾」を判定している場所（4か所・§11 違反）

| 場所 | 材料 | 規則 | 用途 |
|---|---|---|---|
| `lot_key.product_key` | `lottery_stores.json` の `sets` | 長い名前から順に部分一致・複数は `+` で繋ぐ・当たらなければ生の名前 | 利用者の鍵（お気に入り・応募済み・既読） |
| `web/app/lib/set-names.mjs setsForProduct` | ロスター＋`latest.json` の items | 長い一致が勝つ・総称は飲まれる・「A／B」は区切る | 画面の弾タブ・表示名（`product-name.mjs`） |
| `mark_similar_rounds.芯` | 定型語の正規表現（ゲーム名・拡張パック・BOX…を落とす） | 芯の包含で「同一疑い」 | 人の確認キュー |
| `unknown_sets.parts_of` | `set_releases.json`＋ロスター | 区切って部分一致・GENERIC を除く | 未登録の弾の検出 |

同じ商品名が場所によって別の弾に当たる。M2 が入れば、この4つは**M2 の解決結果（`set_id`／`product_id`）を読むだけ**になる。

### 2-4. 弾の名簿の現状

- `lottery_stores.json` の `sets`（手で足す・ポケモン14・ワンピース18・ユニアリ14・DB 5・遊戯王4）。「30th CELEBRATION カードセット (9種セット)」のように公式に無い名前が入っている。「Fusion World」「フュージョンワールド」は弾でなくシリーズ総称
- `set_releases.json`（`*_news.py` が自動＋手入力）。DB は同じ弾が `CROSS FORCE[FB10]` と `ブースターパック CROSS FORCE [FB10]` の2表記で3組重複。ポケモンは「30th CELEBRATION」「30th CELEBRATION FUTURISTIC BOX」「30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー」を**同じ階層に並べている**（弾と商品の区別が無い）
- `product_sale_policies.json`（FUTURISTIC BOX の販売先制約1件・手入力）。M2 の `product` に `sales_scope` として吸収できる

---

## 3. 収集した商品名の分布（origin/main 81231543）

分類は正規表現による近似（`reports/data/2026-09-05-m2-name-distribution.json` の `examples` に各分類の実例）。

| 分類 | 意味 | 候補台帳 1,888 行（560 種） | 配布 287 行（127 種） |
|---|---|---|---|
| official | 公式の正式名そのまま | 32（1.7%）／10種 | 8（2.8%）／5種 |
| official+ | 正式名を含み、前後がゲーム名・条件語（BOX・数量・価格・再販）だけ | 878（46.5%）／199種 | 154（53.7%）／46種 |
| set_only | **弾の名前だけ**（「30th CELEBRATION」「ストームエメラルダ」「世界最強の戦士」「ORIGINAL ARTWORK COLLECTION」「フュージョンワールド」「BRIGHTNESS」） | 243（12.9%）／24種 | 45（15.7%）／10種 |
| set+cond | 弾名＋条件語だけ（「ポケモンカード 30th CELEBRATION BOX」） | 78（4.1%）／41種 | 18（6.3%）／12種 |
| set+extra | 弾名を含むが、条件語で説明できない語が残る（応募条件・障害対応・購入権…を商品名に書いたもの） | 258（13.7%）／183種 | 36（12.5%）／31種 |
| multi | 複数商品の列挙（「ストームエメラルダ/メガシンフォニア/メガブレイブ」「スターターセットex 3種（…／…／…）」） | 81（4.3%）／58種 | 12（4.2%）／11種 |
| other | 弾が読めない独自表記（「30th」「30周年記念BOX」「第2回抽選」「ポケモンカード 3商品」「再販商品」） | 57（3.0%）／37種 | 13（4.5%）／11種 |
| empty | 商品名が空 | 259（13.7%）（うち game も空 119） | 0 |

読み方:

- **正式名が読める行は約半分**（official＋official+：候補 48%・配布 56%）。ここは辞書の完全一致で寄る。
- **弾は分かるが形態が名前に無い行が約2割**（set_only＋set+cond：候補 17%・配布 22%）。指示の「30th CELEBRATION」だけの行はここ。
- 「30th」を含む商品名は候補台帳で **158 種類・726 行**、配布で **59 種類・184 行**。実体は公式の4商品（拡張パック・プレミアムデッキセット・FUTURISTIC BOX・カードセット）＋その組み合わせ。
- 「30th CELEBRATION」**だけ**の行（形態不明）: 候補 96 行・配布 14 行。「30th」だけ: 候補 13 行・配布 2 行。根拠の出所は公式X 124 本・Web 39 本（うち meli-melo 13・Google フォーム 4）。**公式X投稿が本文で弾名しか書かず、形態は画像にある**型と読める（roundup の画像の報告と同じ）。
- 収集側の不具合が1つ見えた: 「30th CELEBRATION/フュージョンワールド」（候補 18 行）は**別ゲームの弾を `/` で繋いだ**もの。同じ店が2ゲームの抽選を1告知に書いたのを1商品名にしている。

### 3-1. 鍵の割れ方（既存の `event_identity.norm` と `lot_key.product_key` を origin/main の実装で走らせた）

| | 行 | 商品名の種類 | identity の product 鍵 | lot_key の product 鍵 |
|---|---|---|---|---|
| 配布・30th を含む | 184 | 59 | **51** | **8** |
| 候補・30th を含む | 726 | 158 | 136 | 16 |
| 配布・全体（商品あり） | 287 | 127 | 117 | 41 |
| 候補・全体（商品あり） | 1,629 | 554 | 496 | 112 |

`lot_key` の `30thcelebration`（配布 114 行）の中身: 「拡張パック」と書いてある 89・BOX 語だけ 8・**弾名だけ 15**・その他 2。つまり `lot_key` は形態不明の 15 行を拡張パックと**同じ鍵に入れている**。利用者側でお気に入りの印が「拡張パックの回」と「形態不明の回」に同時に付く（ci の報告の症状3と同じ機構）。

`lot_key` で弾に寄らず生の名前のまま残る行: 配布 65 行（23%）・候補 330 行（20%）。ロスターに無い弾・独自表記・空。

---

## 4. M2 の形の設計

### 4-1. 原則

1. **正本は公式一覧の1行。** 名前は公式の `title`／`productTitle` をそのまま持ち、ゲーム名の前置き（「ポケモンカードゲーム MEGA」）は付けない（公式一覧に無いため）。表示用の前置きは画面側の規則で足す。
2. **AI は M2 の中から選ぶだけ。** 選択肢は `product_id` の一覧、答えは ID か「該当なし」。自由記述の正規名を返させない（§0-1 原則3の商品版）。
3. **販売単位・条件は商品ではない。** BOX／1BOX／パック／カートン／1個・再販・価格・購入上限は `sale_unit`／`note` として**行**に持つ（`product-name.mjs productNote` が既に拾っている語をそのまま使う）。
4. **形態が読めないものは推測しない。** `set_id` 確定・`product_id` 空で保留（§3-3 育成キュー）。
5. **判定は1か所。** 商品名から `set_id`／`product_id`／`sale_unit` を返す関数を1本にし、§2-3 の4か所はそれを読む。

### 4-2. 階層

```
game（5: pokemon / onepiece / yugioh / dragonball / unionarena）
 └ set（弾）           公式が1つの名前で呼ぶ発売のまとまり
     └ product（商品） 公式一覧の1行＝買える単位
```

- **set（弾）**: ポケモン＝拡張パック名（`30th CELEBRATION`）、ワンピース＝ブースター名＋型番（`世界最強の戦士【OP-17】`）、遊戯王＝パック名（`IMMORTAL PHOENIX`）、DB＝ブースター名＋型番（`BRIGHTNESS OF HOPE [FB11]`）、ユニアリ＝作品コード（`BLC`）。**弾に属さない商品**（構築デッキ単品・サプライ）は `set_id` 空でよい。
- **product（商品）**: 公式一覧の1行。`form`（形態）は公式の種別欄を M5 の小さな語彙へ寄せる:

  | M5 `form` | 公式の種別・語 |
  |---|---|
  | `pack`（拡張パック系・弾の主商品） | 拡張パック／強化拡張パック／ハイクラスパック／ブースターパック／エクストラブースター／基本パック／コンセプトパック／スペシャルパック |
  | `deck` | 構築デッキ／スターターセット／スタートデッキ／構築済みデッキ／アドバンスドデッキ |
  | `set`（特別セット） | FUTURISTIC BOX／プレミアムデッキセット／スペシャルセット／アニバーサリーセット／ポケモンセンターセット |
  | `cardset` | カードセット／プレミアムカードコレクション／スペシャルカードセット |
  | `supply` | 周辺グッズ／デュエリストアイテム／スリーブ／プレイマット（配信対象外の印） |

  公式の生の種別（`form_raw`）も残す。寄せ方は1か所（M5）。

- **30th CELEBRATION の実例**:

  ```
  set  pokemon:30th-celebration   name「30th CELEBRATION」 lot_name「30th CELEBRATION」 release 2026-09-16
    product pokemon:m6a      拡張パック「30th CELEBRATION」                          form=pack     360円
    product pokemon:mf       「30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー」 form=set   6,200円
    product pokemon:furbox   「30th CELEBRATION FUTURISTIC BOX」                     form=set   27,500円  sales_scope=ポケモンセンターオンライン
    product pokemon:cardset-nyaoha-hogeta-kuwassu 「30th CELEBRATION カードセット ニャオハ・ホゲータ・クワッス」 form=cardset 1,200円 (×9)
  ```

### 4-3. ID

- `product_id` = `game:公式の識別子`。ワンピース＝型番（`onepiece:op17`・`onepiece:eb05`）、DB＝型番（`dragonball:fb11`）、遊戯王＝`url` slug（`yugioh:imph`。slug が無い商品は `yugioh:cg2142`）、ユニアリ＝slug（`unionarena:icg-1`）、ポケモン＝`link_detailPage` の slug（`pokemon:m6a`・`pokemon:mf`・`pokemon:furbox`・`pokemon:ex-m6`）。**名前から作らない**ので、公式が表記を直しても動かない。
- `set_id` = `game:弾の芯の slug`（`pokemon:30th-celebration`）。`lot_name` に**いまのロスターの文字列をそのまま**持つ（`lot_key` を動かさないため。後述）。
- 既存の `event_identity_parts` は `record["product_id"]` があれば `product = "id:<product_id>"`（`durable_product_id`）にする口を**既に持っている**（実測: 配布 0 行・候補 0 行が使っている＝配線されていない）。M2 の `product_id` はこの口に入る。

### 4-4. 正規化の手順（N の商品側・1本の関数）

```
入力: 生の商品名 raw, game
1. 分割      「／」「/」「｜」で区切る（名前の中に出ないので安全。`・` は区切らない＝set-names.mjs と同じ）
2. 条件の抜き取り  sale_unit（\d+BOX・\d+パック・1個）・再販・購入上限・価格 → 行の欄へ。名前からは落とさない（別名表は生の名前で引く）
3. 別名表の完全一致  norm(raw) → product_id（公式名そのまま／前置き付き／人が確認した表記／AIが選んだ表記）
4. 弾の一致        別名表に無ければ set の名前で当てる（長い一致が勝つ・総称は飲まれる＝setsForProduct の規則をここへ移す）
     4a. 当たった set に pack 形態の商品が1つだけ、かつ raw に BOX／パック の販売単位語がある → その pack 商品（規則で埋める・F と同じく「規則で埋めた」印を付ける）
     4b. それ以外 → set_id だけ確定・product_id 空・resolution=set_only（保留）
5. 当たらない      → 育成キューへ（§3-3）。resolution=unknown。配信は止めない（商品名は生のまま出る＝いまと同じ）
```

- 4a の規則は指示の「推測しない」に触れるので**採否は判断待ち**（§5 の判断②）。数: 配布 8 行・候補 16 行が該当（BOX 語あり・拡張パック語なし）。採らなければ set_only に入る。
- 手順3の別名表は `{norm(表記): {product_id | set_id, by: official|human|ai|rule, at, evidence}}`。**AI が足す行は `by: ai` で入り、育成キューを通ってから効く**（勝手に既存へ寄せない・§3-3）。

### 4-5. 「30th CELEBRATION」だけ（形態不明）の扱い

- 台帳: `set_id=pokemon:30th-celebration`・`product_id=""`・`product_resolution="set_only"`。
- 配信・表示: 弾名で出し、商品名の脇に「商品未特定」の印。`lot_key` はいまと同じ（弾）。お気に入りの印が拡張パックの回と同時に付く問題（§3-1）は残るが、**いまより悪くならない**。
- 解消の道: (a) V5（応募ページ確認AI）に「この告知の商品は次のうちどれか」を `product_id` の選択肢で聞く（画像を材料に含める・2026-09-05 確定の方針どおり）。(b) 公式サイトの告知本文に形態語があれば手順3〜4で寄る。(c) 人が育成キューで決める。決まったら `product_id` が入り、**素性が変わる**——ここが案E待ちの理由。
- 「30th」だけ（候補 13 行・配布 2 行）は set の一致も1つに決まらない（4候補すべてが「30th CELEBRATION」を含むので、setsForProduct の「総称」規則では 30th CELEBRATION の set に寄る）。set_only と同じ扱いでよい。
- 「30th CELEBRATION/フュージョンワールド」（候補 18 行）は手順1で2つに割れ、別ゲームの弾が混ざる。**1行に2ゲーム**は候補の形として壊れているので、育成キューでなく**収集側の不具合**として別に直す（M2 の範囲外・記録のみ）。

### 4-6. `lot_key` と `identity_key` との関係

| 鍵 | いま | M2 後 | 動くか |
|---|---|---|---|
| `lot_key`（利用者・店｜game｜締切日｜商品） | `product_key` がロスターの弾名で丸める | `set.lot_name` で丸める。**ロスターの文字列を M2 の `lot_name` に写す**ので同じ結果 | **動かさない**。ロスターは M2 から生成する形へ移し、文字列は保つ。将来変えるときは `no_game_lot_key` と同じ「旧い鍵も読む」 |
| `identity_key`（案件・seller｜game｜product｜event_type［｜url］） | `norm(生の商品名)` | `product_id` があれば `id:<product_id>`、無ければ `norm(生の商品名)` のまま | **動く**（`product_id` が付いた瞬間に鍵が変わる）。だから案E（URLを外す）＋`identity_keys` の追記（§3-3-2）＋凍結欄（段4-1）が入るまで**配線しない** |
| `lot_key` の弾と `identity_key` の商品 | 丸め方が逆（ci 訂正） | **役割が違うので揃えない**。lot=弾（set）・identity=商品（product）。M2 は両方の正本を1つのファイルで持つだけ | — |

`product_id` が付くと、いま 51 に割れている配布の 30th の identity 鍵は **4（＋列挙の組）** に寄る。これは案Eの「同じ素性の案件を寄せる」（`event_id_auto_redirects.json`・205本）と同じ機構で吸収できる。

### 4-7. ファイルと更新

- `product_master.json`（1ファイル・`schema_version`）: `games.<game>.sets.<set_id>`・`games.<game>.products.<product_id>`・`aliases`。今回の写しで 600 商品前後・別名 560 種 → 200KB 程度（1MB の器の事故を踏まない）。
- 更新は日次: 5つの公式一覧を読み、`product_id` で upsert。**公式一覧に載った商品は公式が根拠なので人確認なしで足す**（§0-1 原則1）。消えた商品は消さない（過去の抽選が指す）。
- 別名表の育成: 公式名・前置き付き（自動）／人（管理画面）／AI（バッチで `product_id` を選ぶ・`by: ai`・キュー経由）。
- 派生物: `lottery_stores.json` の `sets`（= `lot_name` の一覧）・`set_releases.json`（= product の発売日）・`latest.json` の items は**M2 から生成**し、手で足すのをやめる（§11-2「画面も同じ一覧を読む」）。
- T（通過率）: N/product として `in`（商品名の種類）・`out`（product_id が付いた）・`set_only`・`unknown` を毎 run 記録（§10-1 の N の行）。

### 4-8. 試験（設計のみ）

- 公式一覧の写し（今回の JSON）を fixture にし、5サイトのパーサが `product_id`・`form`・`release_date` を作れること
- いまの `lottery_stores.json` の `sets` の全文字列が M2 の `lot_name` に**一字一句**あること（`lot_key` が動かない証明）
- 560 種の生の商品名に対する分類の回帰（`resolution` の内訳が急に動いたら赤）
- 商品名から弾・商品を判定する関数が `product_master.py` 以外に無いこと（§11 の分散検出）
- 「新しい商品名を作らない」: AI の答えが `product_id` の一覧か「該当なし」以外なら落とす

---

## 5. 判断待ち（TODO_REQUIREMENT）

| # | 何が未確定か | 推奨 | 代替 |
|---|---|---|---|
| ① | 遊戯王の「デュエリストアイテム」145件・ポケモン「周辺グッズ」・各社サプライを M2 に入れるか | 入れる（`form=supply`・配信の弾タブからは外す）。抽選対象になることは稀だが、公式一覧をそのまま持てば取捨の規則が要らない | 種別で落とす（既存 KEEP_KEYS の踏襲） |
| ② | 4a「BOX／パック の語 ＋ 弾に pack 商品が1つ」を拡張パックと**規則で**決めるか | 採る（配布 8 行・候補 16 行。F の既定値と同じく「規則で埋めた」印を付ける） | 採らず set_only へ（推測しないを厳密に） |
| ③ | 「商品未特定」の見せ方（弾名だけ出す／「商品未特定」の札／出さない） | 弾名＋札。出さないと配信が 15%減る | 弾名だけ |
| ④ | 店の売り方の束（「カードセット 9種セット」「スターターセットex 3種」）を M2 の商品として持つか | 持たない。`product_ids` の複数と `sale_unit` で表す（公式にない商品名を作らない） | 束を「擬似商品」として持つ |
| ⑤ | ポケモンの `product_id` を slug にするか（`m6a`）、`link_detailPage` の URL 全体にするか | slug。特設サイトと本サイトで prefix が違うだけで slug は一意 | URL 全体 |
| ⑥ | 着手の順序（案E との関係） | 段1（M2 の器と公式取り込み・配線なし）は案Eと独立に進められる。段2（`product_id`／`set_id` を候補に**影で**書く・T 計測）も ID を動かさない。段3（identity に `id:` を配線）だけ案E＋凍結欄の後 | 全部案Eの後 |

回答が無くても進められるもの: 段1の実装設計（パーサ5本の仕様・`product_master.json` の schema・試験）。保留になるもの: ②④の規則と段3の配線。

---

## 6. 既知のリスク

- ポケモンの `resultAPI.php` は公開 API ではなく画面の裏の口。Referer 無しでも 200 だったが、形が変わる可能性は他より高い。写し（fixture）で守り、落ちたら前回の値を消さない（画像URLと同じ扱い）。
- ワンピースの一覧は12件/頁で、`decks` と `others` の頁数は今回未確認（boosters は2頁）。
- 遊戯王の `release-date` に「10月下旬」の形があり、ISO にできない。M2 では生の文字列も残す。
- 分類の数字は正規表現の近似。±数%の揺れを見込むこと。
- 「30th CELEBRATION/フュージョンワールド」型（2ゲーム1行）は M2 では直らない。収集側（X 取得時AI の商品欄）の直し。

---

## 7. 次に着手すべき作業（この報告の判断が出たら）

1. 段1: `product_master.py`（5サイトの読み込み・`product_master.json` の生成・fixture）。コードは足すがどこからも呼ばない。`lottery_stores.json` の `sets` が `lot_name` に全部あることの試験だけ先に置く。
2. 段2: 候補台帳と配布行に `set_id`／`product_id`／`product_resolution`／`sale_unit` を**影の欄**として書く（identity には触れない）。T に N/product の行。1〜2日測って、set_only と unknown の中身を見る。
3. 段3（案E・凍結欄の後）: `event_identity_parts` の `product_id` の口へ配線。`event_id_auto_redirects.json` で寄せ、`identity_keys` の追記を確かめる（`docs/renaming-procedure.md` の4点）。
4. 並行して収集側: 2ゲーム1行の不具合、公式X本文が弾名だけのときに V5 へ「商品はどれか」を `product_id` の選択肢で聞く。
