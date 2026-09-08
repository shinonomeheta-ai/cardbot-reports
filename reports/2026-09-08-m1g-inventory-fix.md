# 【訂正】M1g 55社の棚卸し — 前の表は22社ぶんが誤りでした

2026-09-08 ／ ci

## 何を間違えたか

**候補を数えるときの鍵と、引くときの鍵が違っていました。**

```
候補をまとめた鍵   GI.チェーン(店名) の戻り値 ＝ canonical_name
表を引いた鍵       store_keys[0]
```

**55社中22社で、この2つが違います。**

```
canonical='EDION'        store_keys[0]='エディオン'
canonical='YAMADA'       store_keys[0]='ヤマダデンキ'
canonical='BIC CAMERA'   store_keys[0]='ビックカメラ'
canonical='iAEON'        store_keys[0]='イオン九州'
canonical='ペリカン'       store_keys[0]='おもちゃのペリカン'
…（22社）
```

その22社は、**実際に候補があっても表では0行**になります。前の表で「取れていない」に
見えた社の大半がこれです。**採点の土台を狂わせました。**

## 直した数

| | 前の表（誤り） | 直した表 |
| --- | --- | --- |
| 候補0の社 | 多数（22社が0に化けた） | **5社** |

**候補0の5社**: KIDDY LAND ／ トイザらス ／ ゲームアーク/宝島 ／ イオン北海道 eショップ ／ Amazon

さらに **KIDDY LAND は本当は0ではありません**。支店名（カタカナの「キデイランド…」）で
**17回**入っています。store_keys が ['KIDDY LAND'] だけなので、完全一致でも
前方一致でも当たりません。

**したがって本当に候補が0なのは4社**: トイザらス ／ ゲームアーク/宝島 ／
イオン北海道 eショップ ／ Amazon。

## 命中率との食い違いは、これで解けます

metrics は **45/49（92%）・取りこぼし4社（Amazon・GAME ARC宝島・ToysRus・
イオン北海道eショップ）** と出していました。**上の4社と完全に一致します。**

「3倍違う」のは metrics の測り方ではなく、**私の表の誤り**でした。

## 前の表で「失敗8社」とされた社の実際

| 社 | 実際 |
| --- | --- |
| イトーヨーカドー ネット通販 | 候補あり（canonical=イトーヨーカドーネットスーパー で引けていなかった） |
| ヤマダデンキ | 候補あり（YAMADA） |
| イオン九州 | 候補あり（iAEON） |
| エディオン | 候補あり（EDION） |
| ポケモンカードラウンジ | 候補あり（POKÉMON CARD LOUNGE） |
| おもちゃのペリカン | 候補あり（ペリカン） |
| ビックカメラ | 候補あり（BIC CAMERA・店名32種） |
| **KIDDY LAND** | **支店名でのみ17回。本部名では0**（別の問題・下記） |

## 残る本物の問題は2つ

1. **本当に取れていない4社**（トイザらス・ゲームアーク/宝島・イオン北海道 eショップ・Amazon）
2. **KIDDY LAND の store_keys が支店名を拾えない** — 候補は「キデイランド ららぽーと富士見店」
   などカタカナで入るのに、store_keys は ['KIDDY LAND'] だけ。**別名の登録漏れ**

## 直した表

```
時点 2026-09-08T19:24:40+09:00（JST・実時刻）
母数 M1g 55 社 ／ 候補の応募回 2993 ／ 配布行 413
定義 社の判定は golden_chain_index.チェーン の1本（既定・支店は本部へ寄せない）。上流B=active・締切で絞らない／上流A=active・締切が実時刻で今以降。
注記 「配布済み」は刻印（round_id→candidate_round_id）で判定する。刻印の被覆は 386/413（94%）なので、刻印の無い行の回は1段手前に出る。

```

```
社名	候補行	上流B	上流A	配布	配布(未来)	いちばん進んだ段	その締切	apply_method	receive_method	応募URLのホスト	announce_type
ポケモンセンターオンライン	14	8	6	4	0	配布済み	2026-08-31T16:59	member/web	ship	pokemoncenter-online.com	both
イエローサブマリン	12	7	1	0	0	AI判定あり未昇格	2026-09-25	-	-	-	official_x
GEO	22	6	0	3	0	配布済み	2026-08-31	web	pickup	geo-online.co.jp	both
ホビーゾーン	3	0	0	0	0	AI判定あり未昇格	2026-09-06T21:00	-	-	-	unknown
ドン・キホーテ	3	3	3	0	0	V5未実行	2026-09-16	-	-	-	official_x
フルコンプ	15	3	3	3	2	配布済み	2026-08-31T23:59	web	pickup	livepocket.jp	official_x
トレカプラザ55	6	0	0	2	0	AI判定あり未昇格	2026-08-25T23:59	web	ship	docs.google.com	unknown
Joshin	4	0	0	0	0	AI判定あり未昇格	2026-08-30	-	-	-	official_site
しまむらパーク	7	0	0	0	0	AI判定あり未昇格	2026-08-30T23:00	-	-	-	official_site
駿河屋	6	2	0	2	0	AI判定あり未昇格	2026-09-06T23:59	sns/web	ship	x.com	both
ポケモンカードストア	1	1	1	2	2	AI判定あり未昇格	2026-09-08T23:00	web	pickup/ship	shop.pokemon.co.jp	official_site
イオン九州	8	0	0	0	0	AI判定あり未昇格	2026-08-30T23:59	-	-	-	official_site
おもちゃのペリカン	3	0	0	0	0	AI判定あり未昇格	2026-08-23T23:59	-	-	-	official_site
竜のしっぽ各店	8	0	0	2	0	AI判定あり未昇格	2026-08-21T23:59	web	ship	ryuunoshippo.membercard.jp	unknown
ポケモンカードラウンジ	5	1	1	0	0	AI判定あり未昇格	2026-08-24T23:59	-	-	-	official_x
平和堂	2	0	0	2	0	配布済み	2026-09-03T23:59	app	pickup	-	official_site
セブンネットショッピング	3	3	1	0	0	AI判定あり未昇格		-	-	-	both
エディオン	11	2	0	7	0	配布済み	2026-08-30T23:59	web	pickup	edion-cp.com	official_x
イトーヨーカドー	7	1	0	1	0	配布済み	2026-08-31T23:59	store	pickup	livepocket.jp	official_site
楽天ブックス	40	19	3	7	0	配布済み	2026-08-30T23:59	web	ship	books.rakuten.co.jp	both
キッズリパブリック	22	11	0	0	0	AI判定あり未昇格	2026-04-09	-	-	-	official_site
ヤマダデンキ	7	5	3	0	0	AI判定あり未昇格	2026-09-13	-	-	-	both
晴れる屋2	15	12	2	4	2	AI判定あり未昇格	2026-09-12T23:59	web	ship	hareruya2.com/livepocket.jp	both
イオンスタイルオンライン	6	0	0	0	0	AI判定あり未昇格	2026-08-20T23:59	-	-	-	official_site
TSUTAYA	5	2	0	0	0	AI判定あり未昇格	2026-08-30	-	-	-	both
ヤマシロヤ	10	1	1	1	0	配布済み	2026-09-01T21:30	web	ship	docs.google.com	official_x
三洋堂書店	4	0	0	0	0	AI判定あり未昇格	2026-09-01T23:59	-	-	-	official_site
ドラゴンスター	19	6	2	6	2	配布済み	2026-09-06	web	pickup/ship	dorasuta.membercard.jp	official_x
シーガル	5	1	1	2	0	AI判定あり未昇格	2026-09-06T20:00	web	ship	seagull.membercard.jp**/seagullonline.jp	both
ビックカメラ	13	5	2	0	0	AI判定あり未昇格	2026-08-26T20:00	-	-	-	both
竜星のPAO	4	1	1	0	0	抜粋なし	2026-08-30T23:59	-	-	-	unknown
カードラボ (C-labo)	2	0	0	0	0	抜粋なし	2026-08-30	-	-	-	both
イトーヨーカドー ネット通販	1	0	0	0	0	抜粋なし	2026-09-03T12:00	-	-	-	official_site
KIDDY LAND	0	0	0	0	0	取れていない		-	-	-	official_x
トイザらス	0	0	0	0	0	取れていない		-	-	-	unknown
お宝創庫・プレイズ・おじゃま館・メディオ！各店	3	0	0	2	0	AI判定あり未昇格	2026-09-06T23:45	web	ship	otakarasouko.com	official_x
コジマ	2	1	1	1	1	AI判定あり未昇格	2026-09-13T23:59	web	ship	-	official_site
HMV	6	1	1	0	0	抜粋なし	2025-02-28	-	-	-	both
ポケモンセンター	11	9	1	1	1	AI判定あり未昇格		web	pickup	-	both
ヨドバシカメラ	5	0	0	3	0	配布済み	2026-09-01	web	ship	limited.yodobashi.com	both
お宝創庫	4	2	1	0	0	AI判定あり未昇格	2023-02-12	-	-	-	official_site
古本市場	6	4	0	2	0	AI判定あり未昇格	2026-09-06T23:00	web	pickup	furu1.net	both
オレタン	3	1	0	2	0	AI判定あり未昇格	2026-09-06T23:59	web	ship	oretan.membercard.jp	official_x
ファミマオンライン	1	1	1	1	1	AI判定あり未昇格	2026-09-10T23:59	web	ship	famima-online.family.co.jp	official_site
ゲームアーク/宝島	0	0	0	0	0	取れていない		-	-	-	unknown
ホビーステーション	9	3	0	0	0	AI判定あり未昇格	2026-08-27	-	-	-	both
あみあみ	2	0	0	0	0	V5未実行	2026-09-07	-	-	-	both
イオン北海道 eショップ	0	0	0	0	0	取れていない		-	-	-	unknown
Bee本舗	2	0	0	2	0	AI判定あり未昇格	2026-09-06T20:00	web	ship	forms.gle	unknown
ガンギ	20	4	4	3	1	配布済み	2026-09-02T23:59	web	pickup/ship	gangi.co.jp	official_site
Amazon	0	0	0	0	0	取れていない		-	-	-	unknown
ノジマオンライン	1	1	0	0	0	抜粋なし		-	-	-	official_x
WonderGOO・新星堂・Ganryu各店	5	0	0	1	0	AI判定あり未昇格	2026-09-07T20:59	store	pickup	x.com	official_x
ジラフル各店（なんば店・オタロード店・京都店・広島ドンキ店・名古屋大須店）	2	0	0	2	0	AI判定あり未昇格	2026-09-07T23:59	web	ship	livepocket.jp	unknown
TCG shop193	1	0	0	1	0	配布済み	2026-09-04	web	pickup	docs.google.com	unknown
```
