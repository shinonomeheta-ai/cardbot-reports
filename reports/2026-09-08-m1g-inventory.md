# M1g 55社の棚卸し（1社1行・全社・調整なし）

2026-09-08 ／ ci

> **【この表は使わないでください】22社ぶんが誤りです。**
>
> 候補をまとめた鍵（`GI.チェーン()` ＝ `canonical_name`）と、表を引いた鍵
> （`store_keys[0]`）が違い、**55社中22社が「0行」に化けています**
> （EDION↔エディオン／YAMADA↔ヤマダデンキ／BIC CAMERA↔ビックカメラ ほか）。
>
> 直した表はこちら → **2026-09-08-m1g-inventory-fix.md**

## 受けた指示（原文・抜粋）

> 本部（M1g 55社）の全社について、1社1行で次を並べること。
> 社を絞らないこと。0行の社も「0行」と書いて必ず出すこと。
> この棚卸しは採点の材料になる。正解に近づけるための調整はしないこと。
> いま台帳にあるものをそのまま出すこと。

**調整していません。** 0行の社も、段が「取れていない」の社も、そのまま出しています。

## 時点・母数・定義

```
時点 2026-09-08T19:18:56+09:00（JST・実時刻）
母数 M1g 55 社 ／ 候補の応募回 2993 ／ 配布行 413
定義 社の判定は golden_chain_index.チェーン の1本（既定・支店は本部へ寄せない）。上流B=active・締切で絞らない／上流A=active・締切が実時刻で今以降。
注記 「配布済み」は刻印（round_id→candidate_round_id）で判定する。刻印の被覆は 386/413（94%）なので、刻印の無い行の回は1段手前に出る。
```

**段の順**（左が手前）:
取れていない → 抽選と判定されない → 抜粋なし → V5未実行 → AI判定あり未昇格 → 昇格済み未配布 → 配布済み

## 表（タブ区切り・55行）

```

社名	候補行	上流B	上流A	配布	配布(未来)	いちばん進んだ段	その締切	apply_method	receive_method	応募URLのホスト	announce_type
ポケモンセンターオンライン	14	8	6	4	0	配布済み	2026-08-31T16:59	member/web	ship	pokemoncenter-online.com	both
イエローサブマリン	12	7	1	0	0	AI判定あり未昇格	2026-09-25	-	-	-	official_x
GEO	22	6	0	3	0	配布済み	2026-08-31	web	pickup	geo-online.co.jp	both
ホビーゾーン	0	0	0	0	0	取れていない		-	-	-	unknown
ドン・キホーテ	3	3	3	0	0	V5未実行	2026-09-16	-	-	-	official_x
フルコンプ	15	3	3	3	2	配布済み	2026-08-31T23:59	web	pickup	livepocket.jp	official_x
トレカプラザ55	6	0	0	2	0	AI判定あり未昇格	2026-08-25T23:59	web	ship	docs.google.com	unknown
Joshin	4	0	0	0	0	AI判定あり未昇格	2026-08-30	-	-	-	official_site
しまむらパーク	7	0	0	0	0	AI判定あり未昇格	2026-08-30T23:00	-	-	-	official_site
駿河屋	6	2	0	2	0	AI判定あり未昇格	2026-09-06T23:59	sns/web	ship	x.com	both
ポケモンカードストア	1	1	1	2	2	AI判定あり未昇格	2026-09-08T23:00	web	pickup/ship	shop.pokemon.co.jp	official_site
イオン九州	0	0	0	0	0	取れていない		-	-	-	official_site
おもちゃのペリカン	0	0	0	0	0	取れていない		-	-	-	official_site
竜のしっぽ各店	0	0	0	0	0	取れていない		-	-	-	unknown
ポケモンカードラウンジ	0	0	0	0	0	取れていない		-	-	-	official_x
平和堂	2	0	0	2	0	配布済み	2026-09-03T23:59	app	pickup	-	official_site
セブンネットショッピング	0	0	0	0	0	取れていない		-	-	-	both
エディオン	0	0	0	0	0	取れていない		-	-	-	official_x
イトーヨーカドー	7	1	0	1	0	配布済み	2026-08-31T23:59	store	pickup	livepocket.jp	official_site
楽天ブックス	40	19	3	7	0	配布済み	2026-08-30T23:59	web	ship	books.rakuten.co.jp	both
キッズリパブリック	0	0	0	0	0	取れていない		-	-	-	official_site
ヤマダデンキ	0	0	0	0	0	取れていない		-	-	-	both
晴れる屋2	15	12	2	4	2	AI判定あり未昇格	2026-09-12T23:59	web	ship	hareruya2.com/livepocket.jp	both
イオンスタイルオンライン	6	0	0	0	0	AI判定あり未昇格	2026-08-20T23:59	-	-	-	official_site
TSUTAYA	5	2	0	0	0	AI判定あり未昇格	2026-08-30	-	-	-	both
ヤマシロヤ	10	1	1	1	0	配布済み	2026-09-01T21:30	web	ship	docs.google.com	official_x
三洋堂書店	4	0	0	0	0	AI判定あり未昇格	2026-09-01T23:59	-	-	-	official_site
ドラゴンスター	19	6	2	6	2	配布済み	2026-09-06	web	pickup/ship	dorasuta.membercard.jp	official_x
シーガル	5	1	1	2	0	AI判定あり未昇格	2026-09-06T20:00	web	ship	seagull.membercard.jp**/seagullonline.jp	both
ビックカメラ	0	0	0	0	0	取れていない		-	-	-	both
竜星のPAO	4	1	1	0	0	抜粋なし	2026-08-30T23:59	-	-	-	unknown
カードラボ (C-labo)	0	0	0	0	0	取れていない		-	-	-	both
イトーヨーカドー ネット通販	0	0	0	0	0	取れていない		-	-	-	official_site
KIDDY LAND	0	0	0	0	0	取れていない		-	-	-	official_x
トイザらス	0	0	0	0	0	取れていない		-	-	-	unknown
お宝創庫・プレイズ・おじゃま館・メディオ！各店	0	0	0	0	0	取れていない		-	-	-	official_x
コジマ	2	1	1	1	1	AI判定あり未昇格	2026-09-13T23:59	web	ship	-	official_site
HMV	0	0	0	0	0	取れていない		-	-	-	both
ポケモンセンター	0	0	0	0	0	取れていない		-	-	-	both
ヨドバシカメラ	5	0	0	3	0	配布済み	2026-09-01	web	ship	limited.yodobashi.com	both
お宝創庫	4	2	1	0	0	AI判定あり未昇格	2023-02-12	-	-	-	official_site
古本市場	6	4	0	2	0	AI判定あり未昇格	2026-09-06T23:00	web	pickup	furu1.net	both
オレタン	3	1	0	2	0	AI判定あり未昇格	2026-09-06T23:59	web	ship	oretan.membercard.jp	official_x
ファミマオンライン	1	1	1	1	1	AI判定あり未昇格	2026-09-10T23:59	web	ship	famima-online.family.co.jp	official_site
ゲームアーク/宝島	0	0	0	0	0	取れていない		-	-	-	unknown
ホビーステーション	0	0	0	0	0	取れていない		-	-	-	both
あみあみ	2	0	0	0	0	V5未実行	2026-09-07	-	-	-	both
イオン北海道 eショップ	0	0	0	0	0	取れていない		-	-	-	unknown
Bee本舗	2	0	0	2	0	AI判定あり未昇格	2026-09-06T20:00	web	ship	forms.gle	unknown
ガンギ	0	0	0	0	0	取れていない		-	-	-	official_site
Amazon	0	0	0	0	0	取れていない		-	-	-	unknown
ノジマオンライン	1	1	0	0	0	抜粋なし		-	-	-	official_x
WonderGOO・新星堂・Ganryu各店	0	0	0	0	0	取れていない		-	-	-	official_x
ジラフル各店（なんば店・オタロード店・京都店・広島ドンキ店・名古屋大須店）	0	0	0	0	0	取れていない		-	-	-	unknown
TCG shop193	1	0	0	1	0	配布済み	2026-09-04	web	pickup	docs.google.com	unknown
```
