# 大手30社の「行が1本も無い」を直す — 1. 鍵のずれ（PR #1426）／2. 21社の一覧／3. 読めないサイトの手元測定

セッション名: api-customer
日付: 2026-09-07（JST）
区切り/依頼名: 大手30社の「行が1本も無い」を直す（1→2→3）
対象: `origin/main` = `a0565540`（台帳 `golden_chains.json` 54社・配布 `lotteries.json` 310行・候補台帳 2,360件・T の店の次元 `history/passrate/m1g/2026-09-07.json`）

## 受けた指示（原文）

> # 大手30社の「行が1本も無い」を直す
> ## 1. 鍵のずれ（今すぐ）
> 配布データにある行が、M1g の鍵に当たっていない:
> - ヨドバシ・ドット・コム（配布2行）→ M1g の鍵は「ヨドバシカメラ」。extra_store_keys に足す
> - ビックカメラ通販 → 支店の行はあるが通販の鍵に当たらない。通販の名前を extra_store_keys に
> link_golden_chains.py を再実行して、2社がカードに紐づくことを確認。
> ## 2. 30社の1社ずつの状態
> 「公式Xと公式サイトの両方が登録されているのに行が1本も取れていない21社」について、1社ずつ:
> - 公式X の直近の投稿に抽選の告知があるか（無ければ「時期」）
> - あるのに取れていないなら、S2 で取れなかった理由（6件の窓・KV に無い・告知判定で落ちた）
> - 公式サイトに告知があるか
> - あるのに取れていないなら、S1 で取れなかった理由（読めない・登録が違う・抜粋が作れない）
> 一覧で出す。「時期」と「取得の入口」と「関門」に分ける。
> ## 3. 機械で読めない公式サイト
> Joshin・ビック・あみあみ・ヤマダ・しまむら について:
> - runner から読めるか（HTTP の状態・本文の長さ）
> - Vercel から読めるか（x-intake の診断ルートの手順で1社ずつ）
> - 読めるなら、S1 の対象にする方法
> 読めないサイトは、その旨を M1g の intake_routes に記録して「取れない店」として明示。
> ## 順番
> 1 → 2 → 3。1 は今日中。2 は一覧を出してから判断。3 は測定の結果次第。

## 指示と過去の報告の食い違い

**2点あります。**

1. 「ビックカメラ通販 → 支店の行はあるが通販の鍵に当たらない」の**通販の行は配布データに無い**。あるのは AKIBA 店の店頭 2 行（支店なので設計上入れない）。候補台帳に「ビックカメラ.com」×1（pending・未配布）があるので、その名前を `extra_store_keys` に先に置いた。配られた時点で紐づく。
2. 前便で「30社は収集が届いていない」と書いたが、**21社のうち19社には候補台帳に回がある**（無いのは ToysRus と HMV の2社だけ）。届いていないのは「配布」であって「取得」ではない。取れているのに配られない理由は下の一覧に書いた。

## 結論

- **1（鍵のずれ）は完了**: PR #1426。ヨドバシ・ドット・コム（配布 2 行）とビックカメラ.com（候補 1 件）を `extra_store_keys` に足し、`link_golden_chains.py` 再実行で 対応済み 54／保留 0。今日の配布データで ヨドバシカメラ は 2 行紐づく（9/1 締切・終了済み）。
- **2（21社の一覧）**: 時期 11 社・取得の入口 4 社・関門 6 社。取得の入口が原因なのは ToysRus（登録ハンドルが実物と違う）・HMV（X に抽選投稿なし・サイト経路が 0 件）・しまむら（X で投稿が 0 件・サイト未登録）・Joshin（サイト 403・X に抽選投稿なし）。**関門で止まっているのは 6 社 7 回**で、理由は AI 審査未実行（ai_not_run）4 回・AI が矛盾判定 2 回・AI が根拠不足 1 回。応募URLが取れていない（`source_only`）のは 7 回全部。
- **3（手元の測定）**: この PC から Joshin 403・ビック 接続不可（000）・あみあみ 403（Cloudflare）・しまむら 403・ヤマダ 200 だが本文 1KB（JS の殻）。HMV・トイザらス・ドンキは 200 で本文あり。runner と Vercel からの測定は未実施（判断待ち）。

## 1. 鍵のずれ（PR #1426）

| チェーン | 足した鍵 | 結果 |
| --- | --- | --- |
| ヨドバシカメラ | `ヨドバシ・ドット・コム` | 配布 2 行が紐づく（9/1 締切・web） |
| BIC CAMERA | `ビックカメラ.com` | 配布には無い。候補台帳の 1 件（pending）が配られたら紐づく |

30社の核語で配布・名簿・候補の店名を走査したが、鍵のずれで落ちていた行はヨドバシの 2 行だけ。TSUTAYA 30 店名・ビックカメラAKIBA・キデイランド 2 店（`chain_campaign` で拾う）・お宝創庫（プレイズ側の連結名で束ね済み）は設計どおり。

## 2. 21社の一覧

材料: 公式Xの取得記録（`official_x_intake_state.json` の seen/visited と `shadow_official_x_posts.json`）、サイト経路（`ec_lottery_sources.json`／`ec_lottery_watch_state.json` の seen）、候補台帳（`shadow_candidates.json`・`golden_chain_index.チェーン` で本部一致）、AI 審査（`shadow_candidate_ai.json`）、配信の刻印（`publish_verdicts.json`／`publish_dropped.json`）。

「見た投稿」は S2 が開いた投稿数（seen）、「保存」はそのうち控えに残った投稿、「抽選語」は本文に「抽選」を含む数。「候補」は本部名に当たる候補台帳の件数、「回」はその中の応募回、「今日以降」は締切が今日以降の回。

| # | チェーン | tier | 公式X（seen／保存／抽選語／最新） | サイト経路（EC巡回の seen） | 候補（本部・回・今日以降・最新締切） | 分類 | 理由 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | イエローサブマリン | A | @ys_info 8／6／6／8-31 | 登録・seen 0 | 10・12・1・9/25 | **関門** | 9/25 の回の根拠が**まとめ系の X**（pokecayoyaku）だけ。AI は conflict（unofficial_only）。人の審査は rejected |
| 2 | ドン・キホーテ | A | @donki_donki 44／4／3／9-07 | 未登録 | 1・3・1・9/16 | **関門** | 9/16 の回（公式X の告知 official_unverified）に **AI 審査が走っていない**。応募URLなし（source_only） |
| 3 | Joshin | A | @joshin_info 12／0／0／— | 登録・render・seen 0（403） | 4・4・0・8/30 | **入口** | X に抽選投稿なし。サイトは runner からも手元からも 403 |
| 4 | しまむらパーク | A | @shimamurapark 0／0／0／— | 未登録（403・アプリ内） | 6・7・0・8/30 | **入口** | X で投稿を 1 件も開けていない（seen 0）。サイトは 403。8月までの候補はまとめ由来 |
| 5 | iAEON | A | @aeon_kyushu 5／0／0／— | 登録・seen 0 | 7・7・0・9/6 | 時期 | 30th の回は 8/30 締切で終了（公式 archives/125）。X に抽選投稿なし |
| 6 | セブンネット | A | @7_netshopping 12／2／2／9-01 | 登録・render・seen 1 | 2・3・0・（日付なし） | 時期 | 30th は 8/3 締切で終了。残る候補は締切なしの仮の回 |
| 7 | KIDS REPUBLIC | B | @kidsrepublicjp 9／0／0／— | 登録・render・AI・seen 11 | 10・22・0・8/27 | 時期 | 30th は 8/21 終了（公式 campaign 一覧）。仮の回 11 件は締切なし・応募URL not_carried |
| 8 | YAMADA | B | @yamada_official 11／2／2／9-06 | 登録・seen 1（本文は画像） | 4・4・1・9/13 | **関門** | 9/13 の回は AI が **conflict**（開始日 8/30 が本文に無い・画像は 8/26〜）。応募URLなし |
| 9 | TSUTAYA | B | @shop_tsutaya 14／0／0／— | 登録・seen 4 | 3・5・0・8/30（支店 300） | 時期 | 本部の X に抽選投稿なし。回は支店ごと（設計どおり本部には付けない） |
| 10 | 三洋堂書店 | B | @gogo_sanyodo2 12／0／0／— | 登録・seen 4 | 4・4・0・9/1 | 時期 | 9/1 締切の回まで取れている。次の回待ち |
| 11 | BIC CAMERA | B | @biccamerae 28／8／8／9-07 | 登録（ビックカメラ.com・render）・seen 1 | 7・11・2・9/11 | **関門** | 9/7 と 9/11 の回（公式X 告知）に **AI 審査が走っていない**。応募URLなし |
| 12 | C-labo | B | @cardlabo_info 15／4／4／9-05 ＋ @webshop_labo | 登録・seen 2 | 2・2・0・8/31（支店 92） | 時期 | 抽選は各店の X（設計どおり支店）。本部の回は 8/31 で終了 |
| 13 | イトーヨーカドーネットスーパー | B | 登録なし | 未登録 | 1・1・0・9/3 | 時期 | 9/3 締切の回まで取れている。X 未登録・サイト経路未登録 |
| 14 | ToysRus | B | @toizarasu_0906 0／0／0／— | 登録・render・seen 0 | 0・0・0・— | **入口** | **登録ハンドルが実物と違う**（9/3 の調査は TOYSRUS_JP）。投稿を 1 件も開けていない。候補 0 |
| 15 | HMV&BOOKS online | B | @hmv_japan 9／0／0／— | 登録・seen 0 | 0・0・0・— | **入口** | X に抽選投稿なし。サイト経路が 1 件も見ていない（news 一覧は手元から 200 で読める）。候補 0 |
| 16 | ポケモンセンター(実店舗) | B | @pokemoncenterpr 9／1／1／9-04 | 登録・render・seen 15 | 2・7・0・（日付なし） | 時期 | 7/31 の事前抽選は終了。残る 7 回は締切なしの仮の回（アビスアイ 5 月） |
| 17 | ヨドバシカメラ | B | @yodobashi_x 22／1／1／8-27 | 登録・seen 1 | 5・5・0・9/1 | 時期 | 9/1 締切の回は配信済み（kept_human 2）。鍵のずれは #1426 で解消 |
| 18 | お宝創庫 | C | @otakara_tcg 5／0／0／— | 登録・seen 4 | 3・4・1・9/13 | **関門** | 9/13 の回は AI が **insufficient_evidence**（根拠がお知らせ一覧で商品が無い）。応募URL not_carried |
| 19 | HOBBYSTATION | C | @hbst_event 10／3／3／9-01 | 登録・seen 2 | 9・9・0・9/3 | 時期 | 9/3 締切の回まで取れている |
| 20 | あみあみ | C | @amiami_figure 13／1／1／9-04 | 登録・seen 0（403） | 2・2・2・9/7 | **関門** | 9/7 の回（公式X 告知）に **AI 審査が走っていない**。サイトは Cloudflare 403 |
| 21 | ノジマオンライン | S | @enetjp 10／1／1／9-05 | 未登録 | 1・1・0・（日付なし） | 時期 | 締切のない不定期受付（start_only）。仮の回 1 |

### 分類のまとめ

```
時期        11 社   iAEON・セブンネット・KIDS REPUBLIC・TSUTAYA・三洋堂・C-labo・ヨーカドーネット・
                   ポケセン実店舗・ヨドバシ・HOBBYSTATION・ノジマ
取得の入口   4 社   ToysRus（ハンドル違い）・HMV（サイト経路 0 件）・しまむら（X 0 件・サイト 403）・Joshin（403）
関門        6 社   イエローサブマリン（根拠がまとめ）・ドンキ／BIC／あみあみ（AI 未実行）・YAMADA（AI conflict）・
                   お宝創庫（AI 根拠不足）
```

### S2（公式X）について分かったこと

- 21社中 18社は S2 が投稿を開いている（seen 5〜44 件）。開けていないのは ToysRus（ハンドル違い）としまむら（seen 0）の 2 社。
- 開いた投稿のうち控えに残るのは「抽選」を含む投稿だけで、BIC 8・イエローサブマリン 6・C-labo 4・ドンキ 4 と、告知は取れている。**S2 の告知判定で落ちている形は見当たらない。** 取れた告知は候補台帳に回として入っている（ドンキ 9/16・BIC 9/11・YAMADA 9/13・あみあみ 9/7）。
- 6 件の窓・KV に無い、の切り分けは今日の材料（seen の件数）では「開けた投稿が 0」の 2 社にしか当たらない。

### S1（公式サイト）について分かったこと

- サイト経路（EC 巡回）に登録があるのは 21 社中 15 社。seen が 0 のまま（1 件も読めていない）は Joshin・しまむら（未登録）・イエローサブマリン・iAEON・ToysRus・HMV・あみあみ の 7 社。
- このうち手元から 200 で本文が読めるのは HMV（112KB）・トイザらス（530KB）・ドンキ（107KB・未登録）。読めるのに seen 0 なのは **登録の URL か抜粋の作り方**の問題（3 の「S1 の対象にする方法」）。
- 403 は Joshin・あみあみ・しまむら、接続不可はビック、JS の殻はヤマダ（1KB）。

### 関門の 7 回

| チェーン | 回 | 締切 | 根拠 | AI | 止まっている理由 |
| --- | --- | --- | --- | --- | --- |
| イエローサブマリン | crnd_2e7ec74d0cd4 | 9/25 | x／unofficial／summary（まとめ系） | conflict・unofficial_only | 公式根拠なし（§8-1）。人も rejected |
| ドン・キホーテ | crnd_910bfe24be91 | 9/16 | x／official_unverified／announcement | 未実行 | ai_not_run |
| YAMADA | crnd_466d9e7cbe1f | 9/13 | x／official_verified＋unverified／announcement | conflict（開始日） | date_conflict |
| BIC CAMERA | crnd_1c90301c6ade | 9/11 | x／official_unverified／announcement | 未実行 | ai_not_run |
| BIC CAMERA | crnd_08e0bce0bcca | 9/7 | x／official_unverified／announcement ×3 | 未実行 | ai_not_run |
| お宝創庫 | crnd_d505535150f6 | 9/13 | web／official_unverified／announcement（お知らせ一覧） | insufficient_evidence | 商品・種別が本文に無い |
| あみあみ | crnd_6ff5452fcb3c | 9/7 | x／official_unverified／announcement | 未実行 | ai_not_run |

7 回とも `apply_url_status` は `source_only`（応募URLなし）か `candidate_rejected/not_carried`。刻印（publish_verdicts）にも配信待ち行列にも無い。`publish_dropped` 全体の理由は ai_not_run 340・date_conflict 23・rejected 9・no_official_evidence 3・start_too_old 1 で、**AI 未実行が圧倒的**。

## 3. 手元の測定（runner・Vercel は未実施）

この PC からブラウザの UA で GET（2026-09-07 20:xx JST）:

```
joshinweb.jp/                              403   362B
biccamera.com/bc/c/info/order/lottery.jsp  000     0B（接続不可）
amiami.jp/top/page/t/attention.html        403  4.5KB（Cloudflare）
yamada-denki.jp/information/               200  1.1KB（JS の殻・本文なし）
shop-shimamura.com/info/4/                 403   395B
hmv.co.jp/news/top/4/                      200  113KB
toysrus.co.jp/ja-jp/                       200  530KB
donki.com/                                 200  107KB
```

runner（GitHub Actions）と Vercel からの測定は、判断のあとに 1 社ずつ行う。x-intake の診断ルートの手順は docs に見当たらなかった（`x_read_kv.py`・lpread の経路が該当）。

## 4. 判断してほしいこと

1. **関門の 4 回（ドンキ・BIC×2・あみあみ）に AI 審査を回すか。** 公式X の告知が根拠で、締切も入っている。走れば配れる可能性が高い（課金あり・1 回あたりの単価は既存の枠内）。
2. **ToysRus のハンドル**を TOYSRUS_JP に直すか（本人性の確認が要る）。
3. **HMV のサイト経路**が 0 件の原因（登録 URL か抜粋）を見るか。
4. 3 の runner／Vercel 測定に進むか。

## 5. 実行したこと・していないこと

- 実行: 台帳の鍵 2 本（PR #1426）、読み取りの走査（配布・名簿・候補・X 控え・EC 巡回・AI・刻印）、手元からの HTTP 測定 8 本。
- していない: AI 審査の実行、ハンドルの変更、台帳の `intake_routes` の変更、runner／Vercel からの測定。費用 0 円。
