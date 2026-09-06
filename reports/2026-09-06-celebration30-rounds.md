# 30th CELEBRATION の応募回 — システムにあるまま

セッション名: store-name-a
日付: 2026-09-06（JST）
区切り/依頼名: 30th CELEBRATION の大手チェーンの応募回の洗い出し
対象: `origin/main` = `3f3844be`

## 受けた指示（原文）

> # 30th CELEBRATION の大手チェーンの応募回を、システムから全部出してください
> 正解表との比較は私がやります。正解表は渡しません。
> システムが持っているものを、そのまま出してください。
> ## 出すもの
> 商品が「30th CELEBRATION」に関わる応募回で、店が M1g（ゴールデンチェーン）に
> 対応付くものを全部。締切が過ぎたものも含める。
> 各行: 店名 / M1g のチェーン名 / 商品名 / 締切 / 状態 / 公式根拠の有無 / 画面のカードに出ているか
> ## 出し方
> 候補台帳と配布データの両方から。
> 「M1g に対応付かないが店名からして大手チェーン」のものも別枠で出す
> ## 注意
> - 値はシステムにあるまま。補完・推測しない
> - 外部データとの比較はしない（私がやる）

## 指示と過去の報告の食い違い

なし。**外部データとの比較はしていません。**

## 数え方（ここだけ私が決めました）

```
商品の絞り方   商品名に "30th" か "30周年" を含む（大小文字を無視）
              → 生の商品名を各行にそのまま出しています
M1g の対応     golden_chains.json の store_keys と、**画面と同じ normStore の完全一致**
              （空白を落として小文字にするだけ。前方一致はしない）
カードに出るか  上の完全一致で当たるか。配布データに行が無いものは「出ない」
```

## 集計

```
配布データ    M1g 対応あり   23行     M1g 対応なし  158行
候補台帳      M1g 対応あり  116行     M1g 対応なし  715行
別枠（M1g 対応なしだが店名がチェーン全体を指すもの）   96行 / 51種
```

## 状態の語彙（システムにある値をそのまま）

```
配布データ   「配布済み」＋ publish_verdicts の刻印（round_links で rnd_ → crnd_ を辿った）
              公開経路 ec/ai ・ 状態 kept_human/kept_ai/dropped
              「刻印なし」＝ round_links にその行の対応が無い
候補台帳     review_status / lifecycle_status / round.review_status
              ＋ 配布に出ているか ＋ publish_dropped の落ちた理由
公式根拠     配布は source と official_ref の有無
              候補は evidence の件数と source_authority
              （official_verified / official_unverified / unofficial）と page_role
```

**候補台帳の `review_status` は 1,996件すべて `pending`** です（この台帳では他の値が
使われていません）。「AI未実行」「人待ち」に相当する語は、候補台帳側には
入っていませんでした。配布側の刻印（`kept_human` / `kept_ai` / `dropped`）と、
`publish_dropped` の理由（`date_conflict_unresolved` / `not_reviewed_ec` /
`rejected` / `start_too_old` / `ai_not_run` / `no_official_evidence`）が、
いまシステムが持っている「状態」の全部です。

### 配布データ（M1g 対応あり）— 23行

| M1g | 店名 | 商品名 | 締切 | 状態 | 公式根拠 | カード |
| --- | --- | --- | --- | --- | --- | --- |
| EDION | エディオン/トレカキャピタル | 拡張パック「30th CELEBRATION」 | 2026-08-30 | 配布済み／刻印なし | source=human_review | 出る |
| EDION | エディオン | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-30T23:59 | 配布済み／公開経路 ec・kept_human | source=human_review | 出る |
| EDION | エディオン・トレカキャピタル | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-30T23:59 | 配布済み／公開経路 ec・kept_human | source=human_review | 出る |
| EDION | エディオン/トレカキャピタル | 30th | 2026-08-30T23:59 | 配布済み／公開経路 ec・kept_human | source=human_review | 出る |
| EDION | エディオン | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」BOX | 2026-08-30T23:59 | 配布済み／公開経路 ec・kept_human | source=human_review | 出る |
| GEO | GEO | 30周年記念BOX / エーフィ&ブラッキー プレミアムデッキセット | 2026-09-03 | 配布済み／公開経路 ec・kept_human | source=human_review official_ref あり | 出る |
| GEO | GEO | 30th | 2026-09-03T17:59 | 配布済み／公開経路 ec・kept_human | source=meli-melo official_ref あり | 出る |
| イトーヨーカドー | イトーヨーカドー各店 | ポケモンカード 30th CELEBRATION BOX / ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-31T23:59 | 配布済み／公開経路 ec・kept_human | source=human_review | 出る |
| トレカプラザ55 | トレカプラザ55通販店 | 30th CELEBRATION/プレミアムデッキセット エーフィ・ブラッキー | 2026-09-01 | 配布済み／刻印なし | source=human_review | 出る |
| トレカプラザ55 | トレカプラザ55通販店 | 30th CELEBRATION/プレミアムデッキセット エーフィ・ブラッキー | 2026-09-01 | 配布済み／刻印なし | source=human_review | 出る |
| ドラゴンスター | ドラゴンスター各店 | 拡張パック 30th CELEBRATION/プレミアムデッキセット エーフィ・ブラッキー | 2026-09-06T23:59 | 配布済み／公開経路 ec・kept_human | source=human_review | 出る |
| ドラゴンスター | ドラゴンスター各店 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1BOXまで（ドラゴンスターモバイル会員限定） | 2026-09-06T23:59 | 配布済み／刻印なし | source=human_review official_ref あり | 出る |
| ドラゴンスター | ドラゴンスター各店 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー 1個まで（ドラゴンスターモバイル会員限定） | 2026-09-06T23:59 | 配布済み／公開経路 ec・kept_human | source=human_review official_ref あり | 出る |
| ポケモンカードストア | ポケモンカードストア | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」（お一人様10パックまで） | 2026-09-08T23:59 | 配布済み／公開経路 ec・kept_human | source=human_review | 出る |
| ポケモンカードストア | ポケモンカードストア | 30th CELEBRATION | 2026-09-08T23:59 | 配布済み／刻印なし | source=human_review | 出る |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」BOX | 2026-08-14T16:59 | 配布済み／刻印なし | （欄が空） | 出る |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA「30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー」 | 2026-08-14T16:59 | 配布済み／刻印なし | （欄が空） | 出る |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA「30th CELEBRATION FUTURISTIC BOX」 | 2026-08-14T16:59 | 配布済み／刻印なし | （欄が空） | 出る |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA「30th CELEBRATION カードセット (9種セット)」 | 2026-08-31T16:59 | 配布済み／公開経路 ec・kept_human | official_ref あり | 出る |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA「30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー」（追加抽選販売） | 2026-08-31T16:59 | 配布済み／公開経路 ec・kept_human | source=human_review official_ref あり | 出る |
| 平和堂 | 平和堂 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-03T23:59 | 配布済み／公開経路 ec・kept_human | source=human_review official_ref あり | 出る |
| 平和堂 | 平和堂 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」 | 2026-09-03T23:59 | 配布済み／公開経路 ec・kept_human | source=human_review official_ref あり | 出る |
| 楽天ブックス | 楽天ブックス | 30th CELEBRATION | 2026-08-30T23:59 | 配布済み／公開経路 ec・kept_human | source=human_review official_ref あり | 出る |

### 候補台帳（M1g 対応あり）— 116行

| M1g | 店名 | 商品名 | 締切 | 状態 | 公式根拠 | カード |
| --- | --- | --- | --- | --- | --- | --- |
| BIC CAMERA | ビックカメラ各店 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー（ビックカメラポイントカード会員様限定・事前抽選） | 2026-09-06T22:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'announcement': 1, 'summary': 1} | 出ない（配布に無い） |
| BIC CAMERA | ビックカメラ各店 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1BOX（ビックカメラポイントカード会員様限定・事前抽選） | 2026-09-06T22:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'announcement': 1, 'summary': 1} | 出ない（配布に無い） |
| EDION | エディオン | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-30T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 3件 {'unofficial': 3} / 役割 {'summary': 2, 'unknown': 1} | 出る |
| EDION | エディオン | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」BOX | 2026-08-30T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 2件 {'unofficial': 2} / 役割 {'unknown': 1, 'summary': 1} | 出る |
| EDION | エディオン/トレカキャピタル | 30周年記念BOX | 2026-08-30 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'unknown': 1, 'summary': 1} | 出ない（配布に無い） |
| EDION | エディオン/トレカキャピタル | 拡張パック「30th CELEBRATION」 | 2026-08-30 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 3件 {'unofficial': 2, 'official_unverified': 1} / 役割 {'summary': 2, 'application': 1} | 出る |
| EDION | エディオン/トレカキャピタル | 拡張パック「30th CELEBRATION」 | 2026-08-30T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 3件 {'unofficial': 2, 'official_unverified': 1} / 役割 {'summary': 2, 'application': 1} | 出る |
| EDION | エディオン・トレカキャピタル | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-30T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 3件 {'unofficial': 3} / 役割 {'summary': 2, 'unknown': 1} | 出る |
| GEO | GEO | 30th CELEBRATION | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 2} / 役割 {'announcement': 2} | 出ない（配布に無い） |
| GEO | GEO | 30th CELEBRATION/ストームエメラルダ/世界最強の戦士 | 2026-09-03 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'official_unverified': 1} / 役割 {'announcement': 1} | 出ない（配布に無い） |
| GEO | GEO | 30周年記念BOX / エーフィ&ブラッキー プレミアムデッキセット | 2026-09-03 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 2件 {'unofficial': 1, 'official_unverified': 1} / 役割 {'summary': 1, 'announcement': 1} | 出る |
| GEO | GEO | 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-03 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'official_unverified': 1} / 役割 {'announcement': 1} | 出ない（配布に無い） |
| GEO | GEO | 30th CELEBRATION | 2026-09-03 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 2} / 役割 {'announcement': 2} | 出ない（配布に無い） |
| GEO | GEO | ポケモンカード 30th CELEBRATION BOX / ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-03T17:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 1, 'official_unverified': 1} / 役割 {'summary': 1, 'announcement': 1} | 出ない（配布に無い） |
| GEO | GEO | 30th | 2026-09-03T17:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'announcement': 1, 'summary': 1} | 出る |
| GEO | GEO | 30th | 2026-09-03T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'announcement': 1, 'summary': 1} | 出る |
| Hobby Zone | ホビーゾーン | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-06T21:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'summary': 2} | 出ない（配布に無い） |
| Hobby Zone | ホビーゾーン | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」 | 2026-09-06T21:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'summary': 2} | 出ない（配布に無い） |
| Hobby Zone | ホビーゾーン | 拡張パック「30th CELEBRATION」「30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー」 | 2026-09-06T21:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 5件 {'official_unverified': 4, 'unofficial': 1} / 役割 {'application': 3, 'summary': 1, 'announcement': 1} | 出ない（配布に無い） |
| Joshin | Joshin | 拡張パック「30th CELEBRATION」「30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー」 | 2026-08-27 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 4件 {'official_unverified': 3, 'unofficial': 1} / 役割 {'application': 2, 'summary': 1, 'announcement': 1} | 出ない（配布に無い） |
| Joshin | Joshin | 30周年記念BOX・エーフィ&ブラッキー プレミアムデッキセット | 2026-08-27 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| Joshin | Joshin | 30th CELEBRATION拡張パック | 2026-08-30 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'unofficial': 1} / 役割 {'summary': 1} | 出ない（配布に無い） |
| KIDS REPUBLIC | キッズリパブリック（アプリ） | 30th CELEBRATION | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 1件 {'official_unverified': 1} / 役割 {'announcement': 1} | 出ない（配布に無い） |
| KIDS REPUBLIC | キッズリパブリック（アプリ） | 30th CELEBRATION | 2026-08-27 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 1件 {'official_unverified': 1} / 役割 {'announcement': 1} | 出ない（配布に無い） |
| KIDS REPUBLIC | キッズリパブリック（アプリ） | ポケモンカード 30th CELEBRATION BOX / ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-27T16:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 3件 {'unofficial': 1, 'official_unverified': 2} / 役割 {'summary': 1, 'application': 2} | 出ない（配布に無い） |
| TSUTAYA | TSUTAYA | 30th | 2026-08-30 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 1, 'official_unverified': 1} / 役割 {'summary': 1, 'announcement': 1} | 出ない（配布に無い） |
| YAMADA | ヤマダデンキ | 拡張パック 30th CELEBRATION | 2026-08-19 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'unofficial': 1} / 役割 {'summary': 1} | 出ない（配布に無い） |
| YAMADA | ヤマダデンキ | 30周年記念BOX / 30th CELEBRATIONプレミアムデッキセットエーフィ・ブラッキー | 2026-08-19T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'unofficial': 1} / 役割 {'summary': 1} | 出ない（配布に無い） |
| イエローサブマリン | イエローサブマリン | 30th CELEBRATION | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 1件 {'official_verified': 1} / 役割 {'announcement': 1} | 出ない（配布に無い） |
| イエローサブマリン | イエローサブマリン | 拡張パック 30th CELEBRATION・プレミアムデッキセット エーフィ・ブラッキー | 2026-09-25 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 1件 {'unofficial': 1} / 役割 {'summary': 1} | 出ない（配布に無い） |
| イエローサブマリン | イエローサブマリン各店 | ポケモンカード 30th CELEBRATION BOX / ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-30T20:00 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'unofficial': 1} / 役割 {'summary': 1} | 出ない（配布に無い） |
| イエローサブマリン | イエローサブマリン各店 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー（Livepocket 購入権抽選・2グループ分割販売） | 2026-08-30T20:00 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 4件 {'official_unverified': 3, 'unofficial': 1} / 役割 {'announcement': 3, 'summary': 1} | 出ない（配布に無い） |
| イオンスタイルオンライン | イオンスタイルオンライン | 30周年記念BOX（30th CELEBRATION） | 2026-08-20 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'unofficial': 1} / 役割 {'summary': 1} | 出ない（配布に無い） |
| イオンスタイルオンライン | イオンスタイルオンライン | 30th CELEBRATION / 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-20T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'unofficial': 1} / 役割 {'summary': 1} | 出ない（配布に無い） |
| イオンスタイルオンライン | イオンスタイルオンライン | ポケモンカードゲーム MEGA 30th CELEBRATION カードセット | 2026-08-20T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'unofficial': 1} / 役割 {'summary': 1} | 出ない（配布に無い） |
| イオンスタイルオンライン | イオンスタイルオンライン | ポケモンカードゲーム MEGA 30th CELEBRATION カードセット（フシギダネ・ヒトカゲ・ゼニガメ ほか8種） | 2026-09-04T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| イトーヨーカドー | イトーヨーカドー | 30th CELEBRATION | 2026-09-03 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'official_unverified': 1} / 役割 {'announcement': 1} | 出ない（配布に無い） |
| イトーヨーカドー | イトーヨーカドー各店 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」 | 2026-08-31T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'summary': 2} | 出ない（配布に無い） |
| イトーヨーカドー | イトーヨーカドー各店 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-31T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'summary': 2} | 出ない（配布に無い） |
| イトーヨーカドー | イトーヨーカドー各店 | ポケモンカードゲーム MEGA 30th CELEBRATION FUTURISTIC BOX | 2026-08-31T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 4件 {'official_unverified': 3, 'unofficial': 1} / 役割 {'announcement': 2, 'application': 1, 'summary': 1} | 出ない（配布に無い） |
| イトーヨーカドー | イトーヨーカドー各店 | ポケモンカード 30th CELEBRATION BOX / ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-31T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 4件 {'unofficial': 3, 'official_unverified': 1} / 役割 {'unknown': 1, 'summary': 2, 'announcement': 1} | 出る |
| イトーヨーカドーネットスーパー | イトーヨーカドーネット通販 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」 | 2026-09-03T12:00 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| オレタン | オレタン各店 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー（6,200円税込・お一人様1個まで） | 2026-09-06T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| オレタン | オレタン各店 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」 | 2026-09-06T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| コジマ | コジマ（アプリ） | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー（6,200円税込・おひとり様1個まで） | 2026-09-13T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| シーガル | シーガル各店 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-06T20:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| シーガル | シーガル各店 | ポケモンカードゲーム MEGA 拡張パック 30th CELEBRATION BOX | 2026-09-06T20:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| トレカプラザ55 | トレカプラザ55 | 30th CELEBRATION/プレミアムデッキセット エーフィ・ブラッキー | 2026-09-01 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'summary': 1, 'unknown': 1} | 出ない（配布に無い） |
| トレカプラザ55 | トレカプラザ55通販 | ポケモンカード 30th CELEBRATION BOX / ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-01T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 3件 {'unofficial': 3} / 役割 {'summary': 2, 'unknown': 1} | 出ない（配布に無い） |
| トレカプラザ55 | トレカプラザ55通販店 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」BOX | 2026-09-01T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'unofficial': 1} / 役割 {'summary': 1} | 出ない（配布に無い） |
| トレカプラザ55 | トレカプラザ55通販店 | ポケモンカード 30th CELEBRATION BOX / ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-01T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 4件 {'unofficial': 3, 'official_unverified': 1} / 役割 {'summary': 3, 'application': 1} | 出ない（配布に無い） |
| トレカプラザ55 | トレカプラザ55通販店 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー（6,200円税込） | 2026-09-01T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'unofficial': 1} / 役割 {'summary': 1} | 出ない（配布に無い） |
| ドラゴンスター | ドラゴンスター | 拡張パック 30th CELEBRATION/プレミアムデッキセット エーフィ・ブラッキー | 2026-09-06 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'unknown': 1, 'summary': 1} | 出ない（配布に無い） |
| ドラゴンスター | ドラゴンスター各店 | ポケモンカード 30th CELEBRATION BOX / ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-06T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| ドラゴンスター | ドラゴンスター各店 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1BOXまで（ドラゴンスターモバイル会員限定） | 2026-09-06T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布済み | evidence 3件 {'official_unverified': 2, 'unofficial': 1} / 役割 {'announcement': 1, 'application': 1, 'summary': 1} | 出る |
| ドラゴンスター | ドラゴンスター各店 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー 1個まで（ドラゴンスターモバイル会員限定） | 2026-09-06T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布済み | evidence 3件 {'official_unverified': 2, 'unofficial': 1} / 役割 {'announcement': 1, 'application': 1, 'summary': 1} | 出る |
| ドラゴンスター | ドラゴンスター通販 | 30th CELEBRATION | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 1件 {'official_unverified': 1} / 役割 {'announcement': 1} | 出ない（配布に無い） |
| ドラゴンスター | ドラゴンスター通販 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-03T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| ドラゴンスター | ドラゴンスター通販 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」 | 2026-09-03T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| ファミマオンライン | ファミマオンライン | ポケモンカードゲーム MEGA 拡張パック 30th CELEBRATION BOX | 2026-09-10T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| フルコンプ | フルコンプ | 30th CELEBRATION/プレミアムデッキセット エーフィ・ブラッキー | 2026-08-30 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'unknown': 1, 'summary': 1} | 出ない（配布に無い） |
| フルコンプ | フルコンプ | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー（「30th CELEBRATION」1BOX とのセットコースのみ） | 2026-08-30T11:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 4件 {'unofficial': 3, 'official_unverified': 1} / 役割 {'unknown': 1, 'summary': 2, 'announcement': 1} | 出ない（配布に無い） |
| フルコンプ | フルコンプ | 30th | 2026-08-30T11:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 1, 'official_unverified': 1} / 役割 {'summary': 1, 'announcement': 1} | 出ない（配布に無い） |
| フルコンプ | フルコンプ | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1BOX | 2026-08-30T11:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 3件 {'unofficial': 3} / 役割 {'unknown': 1, 'summary': 2} | 出ない（配布に無い） |
| フルコンプ | フルコンプ(一部店舗) | 30th CELEBRATION | 2026-08-30 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'unknown': 1, 'summary': 1} | 出ない（配布に無い） |
| フルコンプ | フルコンプ各店 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー（「30th CELEBRATION」1BOX とのセットコースのみ） | 2026-08-30T11:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'unknown': 1, 'summary': 1} | 出ない（配布に無い） |
| フルコンプ | フルコンプ各店 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1BOX | 2026-08-30T11:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'unknown': 1, 'summary': 1} | 出ない（配布に無い） |
| ペリカン | おもちゃのペリカン | 30周年記念BOX（30th CELEBRATION） | 2026-08-23 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| ペリカン | おもちゃのペリカン | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-23T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 4件 {'official_unverified': 1, 'unofficial': 3} / 役割 {'announcement': 1, 'unknown': 2, 'summary': 1} | 出ない（配布に無い） |
| ペリカン | おもちゃのペリカン | ポケモンカードゲーム 拡張パック 30th CELEBRATION | 2026-08-23T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 3件 {'unofficial': 3} / 役割 {'unknown': 1, 'summary': 2} | 出ない（配布に無い） |
| ポケモンカードストア | ポケモンカードストア | 30th | 2026-09-08T23:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカード 30th CELEBRATION BOX / ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー / ポケモンカード 30th CELEBRATION カードセット各種 | 2026-08-31T16:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 1, 'official_unverified': 1} / 役割 {'summary': 1, 'application': 1} | 出ない（配布に無い） |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」BOX（追加抽選販売） | 2026-08-31T16:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 3件 {'official_unverified': 2, 'unofficial': 1} / 役割 {'application': 2, 'summary': 1} | 出ない（配布に無い） |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA「30th CELEBRATION カードセット (9種セット)」 | 2026-08-31T16:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出る |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA「30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー」（追加抽選販売） | 2026-08-31T16:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 3件 {'official_unverified': 2, 'unofficial': 1} / 役割 {'application': 2, 'summary': 1} | 出る |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA「30th CELEBRATION カードセット」9種（第3回追加抽選） | 2026-09-16T16:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」BOX（追加抽選販売） | 2026-09-16T16:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 3件 {'official_unverified': 2, 'unofficial': 1} / 役割 {'application': 2, 'summary': 1} | 出ない（配布に無い） |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA「30th CELEBRATION FUTURISTIC BOX」（追加抽選販売） | 2026-09-16T16:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA「30th CELEBRATION カードセット（9種セット）」（追加抽選販売） | 2026-09-16T16:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」BOX（第3回追加抽選） | 2026-09-16T16:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| ポケモンセンターオンライン | ポケモンセンターオンライン | ポケモンカードゲーム MEGA「30th CELEBRATION FUTURISTIC BOX」（第3回追加抽選） | 2026-09-16T16:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| ヤマシロヤ | ヤマシロヤ | 30th CELEBRATION/エーフィ・ブラッキー | 2026-08-29 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'unknown': 1, 'summary': 1} | 出ない（配布に無い） |
| ヤマシロヤ | ヤマシロヤ オンラインショップ | ポケモン30周年/ストームエメラルダ/スタートデッキ100/メガブレイブ/メガシンフォニアなど | 2026-08-28 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| ヤマシロヤ | ヤマシロヤ オンラインショップ | ポケモンカード 30th CELEBRATION BOX / ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-29T21:30 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 4件 {'official_unverified': 2, 'unofficial': 2} / 役割 {'application': 2, 'summary': 2} | 出ない（配布に無い） |
| ヤマシロヤ | ヤマシロヤオンライン | 拡張パック「30th CELEBRATION」 | 2026-08-29 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'summary': 1, 'unknown': 1} | 出ない（配布に無い） |
| ヤマシロヤ | ヤマシロヤ通販 | 30th CELEBRATION/プレミアムデッキセット エーフィ・ブラッキー | 2026-08-29 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'summary': 1, 'unknown': 1} | 出ない（配布に無い） |
| 三洋堂書店 | 三洋堂書店 | 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-01 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'official_unverified': 2} / 役割 {'announcement': 2} | 出ない（配布に無い） |
| 三洋堂書店 | 三洋堂書店 | 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー/MEGAドリームex/ストームエメラルダ/ニンジャスピナー | 2026-09-01 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 1件 {'official_unverified': 1} / 役割 {'announcement': 1} | 出ない（配布に無い） |
| 三洋堂書店 | 三洋堂書店 | ポケモンカード 30th CELEBRATION BOX / ポケモンカード 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-01T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 3件 {'unofficial': 1, 'official_unverified': 2} / 役割 {'summary': 1, 'application': 2} | 出ない（配布に無い） |
| 古本市場 | 古本市場 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-06T23:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い／落ちた:not_reviewed_ec | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'announcement': 1, 'summary': 1} | 出ない（配布に無い） |
| 古本市場 | 古本市場 | ポケモンカードゲーム MEGA 拡張パック 30th CELEBRATION BOX | 2026-09-06T23:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い／落ちた:not_reviewed_ec | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'announcement': 1, 'summary': 1} | 出ない（配布に無い） |
| 平和堂 | 平和堂 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」 | 2026-09-03T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 3件 {'unofficial': 2, 'official_unverified': 1} / 役割 {'summary': 2, 'application': 1} | 出る |
| 平和堂 | 平和堂 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-03T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布済み | evidence 3件 {'unofficial': 2, 'official_unverified': 1} / 役割 {'summary': 2, 'application': 1} | 出る |
| 晴れる屋2 | 晴れる屋2 通販 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-07T18:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い／落ちた:not_reviewed_ec | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| 晴れる屋2 | 晴れる屋2 通販 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」 | 2026-09-07T18:00 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'application': 1, 'summary': 1} | 出ない（配布に無い） |
| 楽天ブックス | 楽天ブックス | 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー/スタートデッキ100 バトルコレクション/MEGAドリームex/スターターセットex | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 8件 {'official_unverified': 8} / 役割 {'announcement': 8} | 出ない（配布に無い） |
| 楽天ブックス | 楽天ブックス | 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー/スタートデッキ100 バトルコレクション/MEGAドリームex/スターターセットex | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 8件 {'official_unverified': 8} / 役割 {'announcement': 8} | 出ない（配布に無い） |
| 楽天ブックス | 楽天ブックス | 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー/スタートデッキ100 バトルコレクション/MEGAドリームex/スターターセットex | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 8件 {'official_unverified': 8} / 役割 {'announcement': 8} | 出ない（配布に無い） |
| 楽天ブックス | 楽天ブックス | 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー/スタートデッキ100 バトルコレクション/MEGAドリームex/スターターセットex | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 8件 {'official_unverified': 8} / 役割 {'announcement': 8} | 出ない（配布に無い） |
| 楽天ブックス | 楽天ブックス | 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー/スタートデッキ100 バトルコレクション/MEGAドリームex/スターターセットex | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 8件 {'official_unverified': 8} / 役割 {'announcement': 8} | 出ない（配布に無い） |
| 楽天ブックス | 楽天ブックス | 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー/スタートデッキ100 バトルコレクション/MEGAドリームex/スターターセットex | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 8件 {'official_unverified': 8} / 役割 {'announcement': 8} | 出ない（配布に無い） |
| 楽天ブックス | 楽天ブックス | 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー/スタートデッキ100 バトルコレクション/MEGAドリームex/スターターセットex | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 8件 {'official_unverified': 8} / 役割 {'announcement': 8} | 出ない（配布に無い） |
| 楽天ブックス | 楽天ブックス | 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー/スタートデッキ100 バトルコレクション/MEGAドリームex/スターターセットex | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 8件 {'official_unverified': 8} / 役割 {'announcement': 8} | 出ない（配布に無い） |
| 楽天ブックス | 楽天ブックス | 30周年記念BOX | 2026-08-30 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 8件 {'official_unverified': 6, 'unofficial': 2} / 役割 {'application': 6, 'summary': 1, 'unknown': 1} | 出ない（配布に無い） |
| 楽天ブックス | 楽天ブックス | 30th | 2026-08-30T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 10件 {'unofficial': 5, 'official_unverified': 5} / 役割 {'unknown': 4, 'application': 5, 'summary': 1} | 出ない（配布に無い） |
| 竜のしっぽ | 竜のしっぽ各店 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」 | 2026-09-06T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'announcement': 1, 'summary': 1} | 出ない（配布に無い） |
| 竜のしっぽ | 竜のしっぽ各店 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-09-06T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'announcement': 1, 'summary': 1} | 出ない（配布に無い） |
| 竜星のPAO | 竜星のPAO各店 | ポケモンカード 30th CELEBRATION BOX | 2026-08-30T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'unknown': 1, 'summary': 1} | 出ない（配布に無い） |
| 竜星のPAO | 竜星のPAO各店 | ポケモンカードゲーム MEGA 30th CELEBRATION プレミアムデッキセット エーフィ・ブラッキー | 2026-08-30T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'unknown': 1, 'summary': 1} | 出ない（配布に無い） |
| 竜星のPAO | 竜星のPAO各店 | ポケモンカードゲーム MEGA 拡張パック「30th CELEBRATION」1BOX（7,200円・LivePocket抽選） | 2026-08-30T23:59 | 候補 review_status=pending / lifecycle=expired / round=pending／配布に無い | evidence 2件 {'unofficial': 2} / 役割 {'unknown': 1, 'summary': 1} | 出ない（配布に無い） |
| 竜星のPAO | 竜星のPAO各店 | ポケモンカードゲーム MEGA「30th CELEBRATION カードセット」9種類 | 2026-09-30T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'announcement': 1, 'summary': 1} | 出ない（配布に無い） |
| 駿河屋 | 駿河屋 | 30th CELEBRATION | （空） | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 1件 {'official_unverified': 1} / 役割 {'announcement': 1} | 出ない（配布に無い） |
| 駿河屋 | 駿河屋 | 30th CELEBRATION | 2026-09-06T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 1件 {'official_unverified': 1} / 役割 {'announcement': 1} | 出ない（配布に無い） |
| 駿河屋 | 駿河屋 | ポケモンカード 30th CELEBRATION BOX | 2026-09-06T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 3件 {'unofficial': 1, 'official_unverified': 2} / 役割 {'summary': 1, 'application': 2} | 出ない（配布に無い） |
| 駿河屋 | 駿河屋 通販 | ポケモンカードゲーム MEGA 拡張パック 30th CELEBRATION BOX | 2026-09-06T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い／落ちた:not_reviewed_ec | evidence 6件 {'official_unverified': 5, 'unofficial': 1} / 役割 {'announcement': 2, 'application': 3, 'summary': 1} | 出ない（配布に無い） |
| 駿河屋 | 駿河屋通販 | 30th | 2026-09-06T23:59 | 候補 review_status=pending / lifecycle=active / round=pending／配布に無い | evidence 2件 {'official_unverified': 1, 'unofficial': 1} / 役割 {'announcement': 1, 'summary': 1} | 出ない（配布に無い） |

### 別枠: M1g に対応付かないが、店名がチェーン全体を指しているもの — 96行 / 51種

| 店名 | 行数 |
| --- | --- |
| 八文字屋北店（Cardbox） | 7 |
| ヨドバシ・ドット・コム | 6 |
| カードボックス通販（CBトレコロ） | 5 |
| イオン九州 | 3 |
| TSUTAYA フレスタモール岩国店（フタバ図書） | 3 |
| トレカ専門店Vidaway白河立石店（TSUTAYA白河立石店内） | 2 |
| 晴れる屋2各店（店舗） | 2 |
| ポケモンカードラウンジ渋谷店（SHIBUYA TSUTAYA） | 2 |
| ［トレカ］三次店（フタバ図書TSUTAYA） | 2 |
| トレカ専門店Vidaway函館白鳥店（TSUTAYA函館白鳥店内） | 2 |
| フルコンプ（八王子本店・立川南口店・町田店・吉祥寺店・新宿南口店・大阪日本橋店・仙台駅前店・福岡天神店・札幌駅前店） | 2 |
| TSUTAYA一部店舗 | 2 |
| ドン・キホーテ／アピタ・ピアゴ／ロビンフッド（majica対象店舗） | 2 |
| カードボックス岡崎店（本の王国＆すまいるキング） | 2 |
| ドン・キホーテ（一部店舗） | 2 |
| HMV各店舗（HMVトレカショップ） | 2 |
| お宝創庫・プレイズ・おじゃま館・メディオ！各店 | 2 |
| TSUTAYA400号西那須野店トレカ売場 | 2 |
| TSUTAYA森町店トレカコーナー | 2 |
| キディランド | 2 |
| Bee本舗各店（大阪本店・秋葉原店・名古屋大須店・福岡天神店・バトルタワー店） | 2 |
| TSUTAYA神明店トレカ | 2 |
| イオン北海道（iAEONアプリ） | 2 |
| TSUTAYA BOOKSTORE 福島南 | 2 |
| TSUTAYA浜田山店トレカ | 2 |
| イオン九州（iAEONアプリ） | 2 |
| TSUTAYA17号北浦和店トレカ売場 | 2 |
| TSUTAYA那覇新都心店 カードスタジアム | 2 |
| TSUTAYA Trading Card 北千住 | 2 |
| ［トレカ］広店（フタバ図書TSUTAYA） | 2 |
| トレカ専門店Vidaway佐沼店（TSUTAYA佐沼店） | 2 |
| 三洋堂書店（三洋堂トレカ館） | 1 |
| ポケモンカードストア（イオンモール旭川駅前／イオンモール川口前川／イオンモール四條畷／イオンモール大牟田／ららぽーと沼津） | 1 |
| ヤマダデンキ（ヤマダデジタル会員アプリ） | 1 |
| TSUTAYA六高台店 NICトレカ部 | 1 |
| ビックカメラ AKIBA | 1 |
| TSUTAYA カードスタジアム小禄店（沖縄） | 1 |
| ブックオフプラス新宿駅西口 | 1 |
| ドン・キホーテ（majicaアプリ・対象店舗限定） | 1 |
| イエローサブマリン千葉ゲームショップ | 1 |
| ビックカメラ店舗 | 1 |
| 三洋堂書店（トレカ取扱店舗・トレカ館含む） | 1 |
| カードスタジアムTSUTAYA首里店内 | 1 |
| ［トレカ・ゲーム］GIGA防府店（フタバ図書TSUTAYA） | 1 |
| ブックオフ フォレオ広島東店（トレカ） | 1 |
| カードラボ 販売買取センターNAMBA | 1 |
| ジョーシン（アプリ） | 1 |
| 駿河屋 新天町店トレカ館 | 1 |
| ドン・キホーテ(一部店舗) | 1 |
| イオンスタイル | 1 |
| ジョーシン | 1 |

## そのほか（数だけ）

```
配布データで M1g に対応付かない   158行
候補台帳で M1g に対応付かない    715行
   → その大半は支店名（TSUTAYA◯◯店・ブックオフ◯◯店 など）です。
     全件は根拠データ（reports/data/2026-09-06-celebration30-rounds.json）に入れました。
```

## 根拠データ

`reports/data/2026-09-06-celebration30-rounds.json`
（配布181行・候補831行の全件。各行に event_id / round_id / candidate_event_id /
url_status / channel / conflict_status / apply_url_status / apply_url_reason /
sale_channel まで入れています）

## 状態

- **読み取りのみ。** マスタもコードも変更していません。PR も出していません。
- **外部データとの比較はしていません。**
- 値は補完・推測していません。空欄は「（空）」と書いています。
- 外部への通信はありません。課金もありません。
