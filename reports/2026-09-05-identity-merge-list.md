# 案Eで統合される200組（目視用）

日付: 2026-09-05（JST）／main 10123e4d 時点

## 読み方

素性の芯は `店｜ゲーム｜商品｜種別`。**`店` が入っているので、統合は必ず
同じ店の中だけで起きる。** 共有基盤（LivePocket 等）で別の店が同じURLを
使っていても、店が違えば芯が違うので混ざらない——構造上そうなる。

URLのホストだけを出してある。まとめ系のホスト名は `（まとめ）` に伏せた。

## 内訳

| | 組 |
|---|---|
| 組 | 200 |
| 締切が同じ（本当の重複） | 182 |
| 締切が違う（同じ商品の別の回） | 18 |
| 3件以上が1本になる組 | 5 |
| 配布行が2行以上ある組 | 4 |
| 配布行が0行の組 | 89 |

**89組は配布行が0行**（締切が過ぎて配ることをやめた回）。統合しても
利用者の画面は変わらない。

---

## A. 締切が違う組（18組）

同じ店・同じ商品・同じ種別で、応募回の締切が違うもの。**案件としては同じで、
回が分かれるだけ**——`round_id` は締切を含むので回は統合されない。ここが
いちばん「別の抽選では？」と疑うべき場所なので先に出す。

**cardwings八王子駅前店** ｜ onepiece ｜ onepieceカードゲームブースターパック世界最強の戦士op17 ｜ 抽選

    evt_ae43b7d8e52af2312dce6cfb  URL=livepocket.jp
        rnd_2435a2d3ad752225 締切2026-08-25 配布0行
    evt_f5890cbce2b391269197504a  URL=livepocket.jp
        rnd_c06d58bd979b6284 締切2026-08-18 配布0行

**geo** ｜ yugioh ｜ 遊☆戯☆王originalartworkcollection ｜ 抽選

    evt_2fc94f3b3f930c773417a64a  URL=geo-online.co.jp
        rnd_47ad6080385cf459 締切2026-08-31 配布1行
    evt_5330471108d71f8fba812796  URL=draw.geo-online.co.jp,geo-online.co.jp
        rnd_f63232f3176b76f6 締切2026-08-31,2026-09-03 配布0行

**japantcgcenter錦糸町マルイ店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_7bed15c34f99bf055290f923  URL=livepocket.jp,x.com
        rnd_405e69a6e950b621 締切2026-09-01 配布0行 / rnd_cd8dad7e827d8b7a 締切2026-09-05 配布1行
    evt_8d06b119405bf87bc814a776  URL=livepocket.jp
        rnd_e56d862830948d5e 締切2026-09-01 配布0行
    evt_8ef4892112b11085dd9ef34a  URL=livepocket.jp
        rnd_18a7b390ff264327 締切2026-08-23 配布0行

**japantcgcenter錦糸町マルイ店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationboxシュリンク付 ｜ 抽選

    evt_71f01035793f0e4a29d57299  URL=livepocket.jp
        rnd_408e121d3d9b361f 締切2026-08-23 配布0行 / rnd_497ea2f299b7c3b3 締切2026-09-01 配布0行
    evt_74def613ab5cb0238e44646b  URL=livepocket.jp
        rnd_2060193223ad4f01 締切2026-09-01 配布1行 / rnd_f9205895ae1f10fd 締切2026-08-23 配布1行

**お宝創庫プレイズおじゃま館メディオ!各店** ｜ onepiece ｜ onepieceカードゲームブースターパック世界最強の戦士op171box ｜ 抽選

    evt_4a4b9abe9d6383d42d802831  URL=playze.jp
        rnd_9c7f07b50e71f344 締切2026-08-16 配布0行
    evt_d430ab4249df31a84d9b398f  URL=（まとめ）
        rnd_ff1ccc36dd57bcbb 締切2026-08-18 配布0行

**しまむらパーク** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ ｜ 抽選

    evt_131aab22270b124cea713bbc  URL=www.shop-shimamura.com
        rnd_75a7e222d8e36896 締切2026-08-23 配布0行
    evt_da2a345ce0786995ab5c10c1  URL=www.shop-shimamura.com
        rnd_74fb1db703999516 締切2026-08-18 配布0行

**カードゲームショップりらい福島** ｜ pokemon ｜ ポケモンカードストームエメラルダ ｜ 抽選

    evt_20d43c93aa6ebb72fa898570  URL=（まとめ）
        rnd_94039ddb6b712add 締切2026-08-27 配布0行
    evt_f10ed9b5808a37e8deeb2209  URL=x.com
        rnd_fca2266fe7abd5c2 締切2026-08-27,2026-08-28 配布0行

**カードショップクラクラ** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキーフォロー&リポストキャンペーン第27弾 ｜ 抽選

    evt_a25ff8484e0fad427710eb0d  URL=x.com
        rnd_7c84395d2ca7144e 締切2026-09-13 配布0行
    evt_c1b17214b887e76642bd32c0  URL=livepocket.jp,x.com
        rnd_2000505f82868f14 締切2026-09-13 配布0行 / rnd_62838afceacc7c5f 締切2026-09-27 配布1行

**トレカエースイオンタウン水戸南店** ｜ onepiece ｜ onepieceカードゲームブースターパック世界最強の戦士op17 ｜ 抽選

    evt_294c3255dc0ee06878520a0f  URL=（まとめ）
        rnd_d7673a5ca1cdf0f2 締切2026-08-30 配布1行
    evt_6636ca97f1ef4b28c141c898  URL=x.com
        rnd_dae184ce1768e8ff 締切2026-08-16 配布0行
    evt_e40940167733db453bda7fbe  URL=x.com
        rnd_8ef7afcd81d22eaa 締切2026-08-30 配布0行

**トレカショップdandanbase店** ｜ onepiece ｜ onepieceカードゲームブースターパック世界最強の戦士op17 ｜ 抽選

    evt_0e5c48f5035b0b32aaf6fd40  URL=gamesearch.base.ec,（まとめ）
        rnd_24540eeaa6028ea6 締切2026-08-24 配布0行 / rnd_71354dae2ce1bddb 締切2026-08-20 配布0行
    evt_6fa2d4ac54b96af8add5007d  URL=gamesearch.base.ec
        rnd_8318849e9783dca4 締切2026-08-19 配布0行

**トレカショップdandanbase店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationfuturisticbox ｜ 抽選

    evt_e801d2c354d1c0ad4372bb49  URL=gamesearch.base.ec
        rnd_4ea9ed8943b9c85a 締切2026-08-29 配布0行 / rnd_8e318f4240d63d53 締切2026-08-28 配布0行
    evt_f4a1a737c9cfad6a42e1a3e0  URL=（まとめ）
        rnd_ccc256f95ca8d7fa 締切2026-08-29 配布0行

**トレカショップdandanbase店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_403f0e70807ec1999e3b254b  URL=gamesearch.base.ec
        rnd_81e19b7e6e04ee85 締切2026-08-31 配布0行 / rnd_abd40831e7cdfde9 締切2026-09-01 配布0行
    evt_da3f21e1ff4b0623b780a010  URL=gamesearch.base.ec
        rnd_8f7bd6f40ba6d0b2 締切2026-08-24 配布0行

**トレカショップdandanbase店** ｜ pokemon ｜ ポケモンカードゲーム拡張パック30thcelebration ｜ 抽選

    evt_6fceaef2e8fd131367722072  URL=（まとめ）
        rnd_454c6085e601cf67 締切2026-09-01 配布0行
    evt_bd8cf91498b057155255b02c  URL=gamesearch.base.ec
        rnd_2e5e8612f6a5d5b4 締切2026-08-31 配布0行 / rnd_4d71d39f620be14e 締切2026-09-01 配布0行
    evt_c9b7dd7123d64317043584e5  URL=（無し）
        rnd_ccc05426b806c27e 締切2026-09-01 配布0行

**トレカスタイル** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_7a3c813088bac260a4290e84  URL=gamesearch.base.ec
        rnd_55e3fbf219cf624c 締切2026-08-25 配布0行
    evt_d5ebe7fe283d1b745f967262  URL=gamesearch.base.ec
        rnd_cb45105b837560e8 締切2026-09-01 配布1行

**ビックカメラ** ｜ dragonball ｜ brightness ｜ 抽選

    evt_1473563a3132ba54ce103861  URL=x.com
        rnd_0f142651ee9c0a1e 締切2026-09-02 配布0行
    evt_c819cc4a2070780c210a536a  URL=x.com
        rnd_d8a9e71a23ffa41c 締切2026-08-30 配布0行

**ブックオフプラス新宿駅西口店** ｜ pokemon ｜ ポケモンカード30thcelebrationbox ｜ 抽選

    evt_08edcb976e0d4f35257aa460  URL=x.com
        rnd_70c87f40397ec001 締切2026-09-08 配布1行 / rnd_c5665dbdb41a985a 締切2026-09-09 配布0行
    evt_69759163ae63e042e8e1956f  URL=x.com
        rnd_8d7af2cd424398ba 締切2026-09-08 配布0行

**ブックオフ和歌山国体道路店** ｜ pokemon ｜ ポケモンカードストームエメラルダ ｜ 抽選

    evt_5928baada4663e0f5bf255f0  URL=x.com
        rnd_dae4a54c21f2fd37 締切2026-08-31 配布1行
    evt_c564d6003764e06a9b7f83f5  URL=x.com
        rnd_d9966b4912672d01 締切2026-08-30 配布0行

**ブックオフ川崎モアーズ店** ｜ pokemon ｜ ポケモンカード30thcelebrationbox ｜ 抽選

    evt_2422f170c42205168c220dad  URL=x.com
        rnd_3096571f92a17f52 締切2026-09-13 配布1行
    evt_b8cad9e7e72a35e3464ce5ed  URL=x.com
        rnd_0ad243f033289578 締切2026-09-12 配布0行

---

## B. 配布行が2行以上ある組（4組）

**いま利用者に見えている行を含む組。** 統合の影響がいちばん出る。

**japantcgcenter錦糸町マルイ店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationboxシュリンク付 ｜ 抽選

    evt_71f01035793f0e4a29d57299  URL=livepocket.jp
        rnd_408e121d3d9b361f 締切2026-08-23 配布0行 / rnd_497ea2f299b7c3b3 締切2026-09-01 配布0行
    evt_74def613ab5cb0238e44646b  URL=livepocket.jp
        rnd_2060193223ad4f01 締切2026-09-01 配布1行 / rnd_f9205895ae1f10fd 締切2026-08-23 配布1行

**カードショップ黄鶏屋** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_886f6f97c8561954fe2e1b61  URL=docs.google.com
        rnd_83f79c90f23f85a4 締切2026-09-07 配布0行
    evt_a3c3e9e347a29eb10e21ef3f  URL=docs.google.com,x.com,（まとめ）
        rnd_c78605cefba2d454 締切2026-09-07 配布2行

**カードショップ黄鶏屋** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_0fb51ff02b6f9ab72c36ff6f  URL=docs.google.com
        rnd_98dcf16cb805f055 締切2026-09-07 配布0行
    evt_3bd17b68008e805a9de34f00  URL=docs.google.com,x.com
        rnd_ac0ced497a3c4922 締切2026-09-07 配布2行

**ブックオフ川崎モアーズ店** ｜ pokemon ｜ 30thcelebration ｜ 抽選

    evt_8a8c8c6a0d675d9e697fae2b  URL=x.com
        rnd_987692d7568f658b 締切2026-09-13 配布1行
    evt_ad3c0b3acd4c9621c483ce76  URL=（無し）
        rnd_27a4f888f389c79a 締切2026-09-13 配布1行

---

## C. 3件以上が1本になる組（5組）

**japantcgcenter錦糸町マルイ店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_7bed15c34f99bf055290f923  URL=livepocket.jp,x.com
        rnd_405e69a6e950b621 締切2026-09-01 配布0行 / rnd_cd8dad7e827d8b7a 締切2026-09-05 配布1行
    evt_8d06b119405bf87bc814a776  URL=livepocket.jp
        rnd_e56d862830948d5e 締切2026-09-01 配布0行
    evt_8ef4892112b11085dd9ef34a  URL=livepocket.jp
        rnd_18a7b390ff264327 締切2026-08-23 配布0行

**mintgames池袋店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration1box7,200円税込お渡し916〜920 ｜ 抽選

    evt_1e36afd0220f85bcbc7dd562  URL=docs.google.com
        rnd_b4d9625d2844d2a4 締切2026-09-13 配布0行
    evt_673eb5d9f346f1a622623a7b  URL=x.com
        rnd_387b7657bb43ce9e 締切2026-09-13 配布0行
    evt_ef26423f299fd24068fd897f  URL=docs.google.com
        rnd_c5f8f6bdbcb71e2c 締切2026-09-13 配布0行

**トイザらス** ｜ pokemon ｜ 30thcelebration拡張パックbox ｜ 抽選

    evt_b3db8eed45af05779b3395fb  URL=x.com
        rnd_c444048900557d45 締切2026-08-17 配布0行
    evt_b88073bab8d4e36a094358b8  URL=twitter.com
        回なし
    evt_decb43bd569ee229f1a0f6de  URL=t.co
        回なし

**トレカエースイオンタウン水戸南店** ｜ onepiece ｜ onepieceカードゲームブースターパック世界最強の戦士op17 ｜ 抽選

    evt_294c3255dc0ee06878520a0f  URL=（まとめ）
        rnd_d7673a5ca1cdf0f2 締切2026-08-30 配布1行
    evt_6636ca97f1ef4b28c141c898  URL=x.com
        rnd_dae184ce1768e8ff 締切2026-08-16 配布0行
    evt_e40940167733db453bda7fbe  URL=x.com
        rnd_8ef7afcd81d22eaa 締切2026-08-30 配布0行

**トレカショップdandanbase店** ｜ pokemon ｜ ポケモンカードゲーム拡張パック30thcelebration ｜ 抽選

    evt_6fceaef2e8fd131367722072  URL=（まとめ）
        rnd_454c6085e601cf67 締切2026-09-01 配布0行
    evt_bd8cf91498b057155255b02c  URL=gamesearch.base.ec
        rnd_2e5e8612f6a5d5b4 締切2026-08-31 配布0行 / rnd_4d71d39f620be14e 締切2026-09-01 配布0行
    evt_c9b7dd7123d64317043584e5  URL=（無し）
        rnd_ccc05426b806c27e 締切2026-09-01 配布0行

---

## D. 残り（177組・締切が同じ・配布行0〜1行）

**[トレカ]広店フタバ図書tsutaya** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_3903bfae207d3d45f35ecc33  URL=x.com
        rnd_49522d5ce410932f 締切2026-08-30 配布0行
    evt_c7670434c62cedd633d9771f  URL=x.com
        rnd_9c680b5d13e646b4 締切2026-08-30 配布0行

**[トレカ]広店フタバ図書tsutaya** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_4899450442d4f00029096b24  URL=x.com
        rnd_7481d307c0c45118 締切2026-08-30 配布0行
    evt_615aebb71b8f3ab0efcb0431  URL=x.com
        rnd_41c960180599222f 締切2026-08-30 配布0行

**abcパレード博多店ゆめタウン博多** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキーゆめカードクレジット会員限定店頭応募 ｜ 抽選

    evt_a794fd5fb47752089894f417  URL=x.com
        rnd_f687255d2bab6d87 締切2026-09-06 配布1行
    evt_caac369d582ddcf044d9ee55  URL=x.com
        rnd_443feb12385de2a0 締切2026-09-06 配布0行

**bigmagic池袋店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ ｜ 抽選

    evt_bc3ebb832c7caf435ad82760  URL=bigmagic.net
        rnd_89034c71d3b3972f 締切2026-08-27 配布0行
    evt_f99425715425a9a8cc0c561f  URL=livepocket.jp
        回なし

**bigmagic秋葉原店** ｜ yugioh ｜ 遊☆戯☆王originalartworkcollection4boxセット23,760円税込店頭受取のみ ｜ 抽選

    evt_5fd0bcb59167f6773223d4a8  URL=livepocket.jp
        rnd_69541405fb0e1447 締切2026-08-31 配布0行
    evt_a5a21bb48d5c5cf1e1df91a2  URL=livepocket.jp
        rnd_52b58173e62d7fe4 締切2026-08-31 配布1行

**dmmマイカ** ｜ pokemon ｜ ストームエメラルダ ｜ 抽選

    evt_0710e8dcba1287d0d118d53a  URL=（まとめ）
        回なし
    evt_92b78f2d241f250cf0aba6ba  URL=myca.dmm.com
        rnd_c35733ec98db7828 締切2026-09-01 配布1行

**dmmマイカ** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダbox新品未開封定価販売 ｜ 抽選

    evt_490939fa3e273f0e7a96aa05  URL=x.com
        rnd_067d4f322cfa5654 締切2026-09-01 配布0行
    evt_7db3e20a8e3e3515e0555f24  URL=myca.dmm.com
        rnd_3f9a0597e3b8b11c 締切2026-09-01 配布0行

**duelstadeganryuいわき鹿島店** ｜ onepiece ｜ onepieceカードゲームブースターパック世界最強の戦士op17 ｜ 抽選

    evt_3a3878326fa3fa64b21da246  URL=x.com
        rnd_f363fc33ec29eb1c 締切2026-08-21 配布0行
    evt_5e03ac3926317b1e7212be9f  URL=（まとめ）
        回なし

**geo** ｜ onepiece ｜ 世界最強の戦士 ｜ 抽選

    evt_09f229204c4e347f3a011ac0  URL=draw.geo-online.co.jp,geo-online.co.jp
        rnd_232f2902e67d5645 締切2026-09-03 配布1行
    evt_5dfe39235a26d1b351b3a342  URL=geo-online.co.jp
        回なし

**geo** ｜ pokemon ｜ 30周年記念boxエーフィ&ブラッキープレミアムデッキセット ｜ 抽選

    evt_0064e99a22f71a92ed50fdfe  URL=geo-online.co.jp
        rnd_ad34df33eb3e5cbb 締切2026-09-03 配布0行
    evt_a3c992a3785bcf2a05e1f01b  URL=geo-online.co.jp
        rnd_993c40afa87dfc8d 締切2026-09-03 配布1行

**goodgame流山おおたかの森店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_6c4a05d449ca8a58e8c46a8c  URL=x.com
        rnd_365d70d367c864e1 締切2026-09-14 配布0行
    evt_fbe9052603783df787d179c3  URL=x.com
        rnd_056595c6270ac7fb 締切2026-09-14 配布1行

**joshinジョーシン** ｜ pokemon ｜ ストームエメラルダスタートデッキ100 ｜ 抽選

    evt_2ed794afc880bfa9056e5f09  URL=x.com
        回なし
    evt_eb952bde8d6902b50978ee66  URL=shop.joshin.co.jp
        rnd_ca09ea6f6466792a 締切2026-08-17 配布0行

**magi仙台店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ未開封box ｜ 抽選

    evt_2b7b74d0b6abe2b4fddc8163  URL=x.com
        rnd_e8eced8c3c8b96f7 締切2026-08-31 配布0行
    evt_77e244a36ecdbbbd1a4ceeb6  URL=x.com
        rnd_775e2e0647abf345 締切2026-08-31 配布0行

**magi仙台店** ｜ pokemon ｜ ポケモンカードストームエメラルダ ｜ 抽選

    evt_cd16deb139ace8aebf9788a6  URL=x.com
        rnd_53353c14b28a4969 締切2026-08-30 配布0行
    evt_facc0943e94e10865ae1583b  URL=x.com
        rnd_0b58aff4a3c00fc6 締切2026-08-30 配布0行

**magi福岡天神店** ｜ pokemon ｜ ポケモンカード30thcelebrationbox ｜ 抽選

    evt_ae3b4990a226c657355727f5  URL=x.com
        rnd_f20c1dbf79693189 締切2026-09-16 配布0行
    evt_b5d3a4bdaf5228021d057f1f  URL=x.com
        rnd_808f0cf19439537c 締切2026-09-16 配布1行

**magi立川駅前店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationfuturisticbox ｜ 抽選

    evt_5f00592b33b32947c2d0d36d  URL=x.com
        rnd_23e397cf37f13ca7 締切2026-09-16 配布0行
    evt_d96d1fc7e7e04fc7a0e11929  URL=x.com
        rnd_e1221176737a2ee1 締切2026-09-16 配布1行

**mint渋谷店** ｜ onepiece ｜ 世界最強の戦士 ｜ 抽選

    evt_10ecfcac498b1695f323d726  URL=forms.gle
        rnd_923ff9c7b417f108 締切2026-08-20 配布0行
    evt_a7ee9181f7e19d8204f97a3f  URL=x.com
        回なし

**onepieceカードゲーム公式ショップ各店** ｜ onepiece ｜ onepieceカードゲームブースターパック世界最強の戦士op17 ｜ 抽選

    evt_28f01624c1fa680b59c51a41  URL=parks2.bandainamco-am.co.jp
        回なし
    evt_4e84465ee175ed0dd152005e  URL=（まとめ）
        rnd_bbe1a5b44a02d64b 締切2026-08-16 配布0行

**superkabos+ゲオwasse店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ1box9月4日再販分購入権抽選6,000円 ｜ 抽選

    evt_4b48a3e7374ea242575bafb2  URL=shoplottery.e-starbox.com
        rnd_378e887d790fabf1 締切2026-08-31 配布1行
    evt_ebcb6102fd016d1917c8389f  URL=shoplottery.e-starbox.com
        rnd_63a16d75939cf0ee 締切2026-08-31 配布0行

**superkabos+ゲオwasse店** ｜ pokemon ｜ ポケモンカードゲームスターターセットmegaexイーブイexゾロア&ゾロアークexニャオハ&マスカーニャex ｜ 抽選

    evt_6f0fb5478a9a087aa0da31a1  URL=shoplottery.e-starbox.com
        rnd_d945b68b45094556 締切2026-08-31 配布1行
    evt_f1b5e4152b1e60c55dade673  URL=shoplottery.e-starbox.com
        rnd_81eb228f12c6f071 締切2026-08-31 配布0行

**superkabos+ゲオ二の宮本店** ｜ pokemon ｜ ポケモンカードゲームmegaスターターセットex3種イーブイexゾロア&ゾロアークexニャオハ&マスカーニャexいずれか1個購入権抽選 ｜ 抽選

    evt_0f3c3675f303351d9b4cef21  URL=shoplottery.e-starbox.com
        rnd_e44277d59f781ad9 締切2026-08-30 配布1行
    evt_bc31b8ba2fcaeeb1c91c7d42  URL=shoplottery.e-starbox.com
        rnd_40fe91282ab0516e 締切2026-08-30 配布0行

**tierone浜松店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_2dd725ad07860f416498c3a6  URL=x.com
        rnd_fac16c662a827025 締切2026-09-13 配布1行
    evt_31443ed0b2e64e75ad85fdfe  URL=x.com
        rnd_696181059842b169 締切2026-09-13 配布0行

**tierone浜松店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_3dc7c4262fcc2a8a5c617537  URL=x.com
        rnd_717d275dfbb5887c 締切2026-09-13 配布1行
    evt_8a9aa76a086d473a60b3a212  URL=x.com
        rnd_dcb5d24967819ded 締切2026-09-13 配布0行

**tierone渋谷店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_24373cfebc20bf563194b109  URL=x.com
        rnd_00018a4bfb360846 締切2026-09-13 配布0行
    evt_af9abecad0135f2ecbe95996  URL=x.com
        rnd_2842dc54ef7ed959 締切2026-09-13 配布1行

**tierone渋谷店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_6cc21bea9a067fb1fe8751b6  URL=x.com
        rnd_2461826e7502559f 締切2026-09-13 配布0行
    evt_c949e28a7c55ae796cb9f3d4  URL=x.com
        rnd_852a8dab4110df0a 締切2026-09-13 配布0行

**tsutayaavクラブ御領店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_57983702bdbd9d7c28ffe525  URL=x.com
        rnd_37bd1ece17e093a3 締切2026-08-30 配布0行
    evt_dfad025084b21707f3a0cc93  URL=x.com
        rnd_65881a0393bcf3fb 締切2026-08-30 配布0行

**tsutayaaz岡南店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationbox ｜ 抽選

    evt_69216ea41235481adb6eaff4  URL=x.com
        rnd_75fd111bd3acfba3 締切2026-08-30 配布0行
    evt_af98c25a48aed367f439307b  URL=x.com
        rnd_8241c09bb74434ec 締切2026-08-30 配布0行

**tsutayabookstore島原店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_168baf4ef7895e2db70c3562  URL=x.com
        rnd_c359b93ef5dbe61e 締切2026-08-30 配布0行
    evt_b707c546665f2470422a1afc  URL=x.com
        rnd_8a049195aeb654fa 締切2026-08-30 配布0行

**tsutayabookstore川崎駅前店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_4254e599f981b304c6f1e614  URL=（無し）
        rnd_ec63021e89425d70 締切2026-08-30 配布1行
    evt_56526a5ec4f34224b7fdc0ce  URL=x.com
        rnd_e508817c0e99b9ae 締切2026-08-30 配布0行

**tsutayabookstore川崎駅前店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_56794f0ce406b36e2c5d4ae2  URL=x.com
        rnd_ad22ddae776034f3 締切2026-08-30 配布0行
    evt_d5b3c94cb156f60d4b22bfd4  URL=x.com
        rnd_ec1989e90c1594e4 締切2026-08-30 配布0行

**tsutayabookstore福島南** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_12c8a0ec9d3f5c552c567ccb  URL=（無し）
        rnd_e9727181b5309721 締切2026-08-30 配布1行
    evt_163aeac045444bebb3f1f64c  URL=x.com
        rnd_fbd7a7fcaf67e6fb 締切2026-08-30 配布0行

**tsutayajr東所沢駅前店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_68d7ef55751883768f6227ae  URL=x.com
        rnd_c6b540786e588bf2 締切2026-08-30 配布0行
    evt_adf305fef60e3254fe518738  URL=x.com
        rnd_4fdf238fafc52e72 締切2026-08-30 配布0行

**tsutayajr東所沢駅前店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_47a2d58897ef28a1727ede90  URL=x.com
        rnd_b71b6cb77d930d92 締切2026-08-30 配布0行
    evt_80fab3e3c2f885bbe017af81  URL=x.com
        rnd_01373d383d4ff1ee 締切2026-08-30 配布0行

**tsutayatradingcard平塚店** ｜ pokemon ｜ ポケモンカードゲームブラックボルトホワイトフレア ｜ 抽選

    evt_0e99695174587feb0b5f1908  URL=x.com
        rnd_ab546df7c6b2f75f 締切2026-09-09 配布1行
    evt_526f2482c52feda9077c90ad  URL=x.com
        rnd_13558c3d95ab5436 締切2026-09-09 配布0行

**tsutayatradingcard府中駅前** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー店頭掲示qrから事前抽選応募 ｜ 抽選

    evt_244e7d1ed872b7876bf1f046  URL=x.com
        rnd_324ad91ef1c13dc9 締切2026-09-01 配布0行
    evt_46e1d0b3f8ef3f4ad93a9d48  URL=x.com
        rnd_4d476d8ac68ce4f7 締切2026-09-01 配布1行

**tsutayatradingcard府中駅前** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration店頭掲示qrから事前抽選応募 ｜ 抽選

    evt_7306c731315a9cd2f89ca94f  URL=x.com
        rnd_3e9a12d342dabfa0 締切2026-09-01 配布0行
    evt_ac8d13a8a4cc9b3584c46be2  URL=x.com
        rnd_db2f86ff6b634a22 締切2026-09-01 配布1行

**tsutayaあべの橋店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ ｜ 抽選

    evt_1a272f7b80d495c76c3eb7eb  URL=x.com
        rnd_56bd315099adcc86 締切2026-08-30 配布0行
    evt_2f08902e470529b674c9c9f8  URL=x.com
        rnd_01c45d13569ecc23 締切2026-08-30 配布0行

**tsutayaいまじん白揚瀬戸店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ1box ｜ 抽選

    evt_75e15cba25b12af89b8601eb  URL=shoplottery.e-starbox.com
        回なし
    evt_ee277938f0209eecff22ac31  URL=x.com
        rnd_8bdfbd23ae8e0576 締切2026-08-16 配布0行

**tsutayaイオンタウン郡山店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_507bf4a652d0325faa18c235  URL=x.com
        rnd_9144fef50f259b0e 締切2026-08-30 配布0行
    evt_7c9c902a72b3f08f5dfec471  URL=x.com
        rnd_40b99bd42735597c 締切2026-08-30 配布0行

**tsutayaウイングタウン岡崎店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_7266557e0c13adc2a6e24e1a  URL=x.com
        rnd_d3374ec14158f5dc 締切2026-09-03 配布1行
    evt_c37a3a37bf80643d1a2ff5b7  URL=x.com
        rnd_a8481444a5b35159 締切2026-09-03 配布0行

**tsutayaウイングタウン岡崎店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_2573040da20927f1bcbd862f  URL=（無し）
        rnd_1f0f870e38a2eaaf 締切2026-09-03 配布1行
    evt_82c1dfe759e8bee6cc6336f1  URL=x.com
        rnd_43fda51f3d4c9146 締切2026-09-03 配布0行

**tsutayaココアドバンス大村店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_0b15329a7dd39031e43a7394  URL=x.com
        rnd_dfb695a12280fe21 締切2026-08-30 配布0行
    evt_ce7e210b8abc56e18af764c7  URL=x.com
        rnd_4356cd0e63d1f34d 締切2026-08-30 配布0行

**tsutayaサンリブ宗像店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationバラパックでのお渡しシュリンク箱なし ｜ 抽選

    evt_358eced907c9e0bcd3a126d0  URL=x.com
        rnd_80679c6683b15d0d 締切2026-08-30 配布0行
    evt_d986948e810b605a3c2815df  URL=x.com
        rnd_0b8956656ddbc830 締切2026-08-30 配布1行

**tsutayaフレスタモール岩国店フタバ図書** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_688e4c190367fe1e4b1a9b94  URL=x.com
        rnd_a905f113246dbeea 締切2026-08-30 配布0行
    evt_80c447b4a7e10f17cf559574  URL=x.com
        rnd_12972c1f97972dee 締切2026-08-30 配布0行

**tsutayaリノアス八尾店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_069f7aa9a51040d6df0b63f0  URL=x.com
        rnd_16ce1d6eb02b9909 締切2026-08-30 配布0行
    evt_d60e2be1c380fd1264e00505  URL=x.com
        rnd_8627948d3f73543c 締切2026-08-30 配布0行

**tsutaya中万々店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_43808ee40fd83a08ac10cf4f  URL=x.com
        rnd_0c5a4ad3042d94b3 締切2026-08-30 配布0行
    evt_f4a4bcbb2b26661bee55657f  URL=x.com
        rnd_2d1530bc02c56eb7 締切2026-08-30 配布0行

**tsutaya八戸ニュータウン店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_462117290ff149ed6196806d  URL=docs.google.com
        rnd_88ae1f7165bc2f2c 締切2026-09-11 配布0行
    evt_a76c714885b682bfa5d1e9db  URL=docs.google.com
        rnd_e4dbc1d137f34b6e 締切2026-09-11 配布1行

**tsutaya六高台店nicトレカ部** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_e06328acfd3f923d3b2761a9  URL=x.com
        rnd_51e3a76dbf308c5c 締切2026-08-30 配布0行
    evt_e4f610663a468570095d56d2  URL=x.com
        rnd_cfb52819cd4559da 締切2026-08-30 配布0行

**tsutaya南国店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_c5cfd3a38594ddef52b7da99  URL=x.com
        rnd_bf923b179298cf78 締切2026-08-30 配布0行
    evt_cc571a9d71dea1160f4d1b4b  URL=x.com
        rnd_23b03ef598dd327d 締切2026-08-30 配布0行

**tsutaya合川店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_5bba0548672815a49197e0c9  URL=livepocket.jp
        rnd_e8b3202d269023fd 締切2026-09-02 配布0行
    evt_68a6160ae7c8413db1c580fe  URL=livepocket.jp
        rnd_27efe728486797bf 締切2026-09-02 配布1行

**tsutaya合川店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_07d9ad5647bdf030e2a584d4  URL=livepocket.jp
        rnd_73d0e5d702cea7f4 締切2026-09-02 配布0行
    evt_7fbcf1822ec0f52cb0b02f4e  URL=livepocket.jp
        rnd_41f923d843350d65 締切2026-09-02 配布1行

**tsutaya大垣店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_2051214edc07fb4bf140073b  URL=（無し）
        rnd_e1d189fc1974892d 締切2026-09-03 配布0行
    evt_966269a0b4df7e1367842460  URL=x.com
        rnd_7c5772f3bb9d34db 締切2026-09-03 配布0行

**tsutaya大安寺店** ｜ dragonball ｜ brightness ｜ 抽選

    evt_1c84906e0128a52fa3a65e56  URL=（無し）
        rnd_60f916ebca541d3d 締切2026-09-06 配布1行
    evt_f7a7b90f059972359195fbeb  URL=x.com
        rnd_4c7644f0a070bd38 締切2026-09-06 配布0行

**tsutaya大安寺店** ｜ pokemon ｜ ポケモンカードゲーム拡張パック30thcelebrationbox ｜ 抽選

    evt_aa9512093afbf2540fa2ce3e  URL=x.com
        rnd_dd30e60c950f2761 締切2026-09-06 配布0行
    evt_d178cb2ca0b25f825dc18ec0  URL=（無し）
        rnd_8d3e1d78c3d24b88 締切2026-09-06 配布1行

**tsutaya大安寺店** ｜ yugioh ｜ 遊戯王ocgデュエルモンスターズoriginalartworkcollection ｜ 抽選

    evt_9b4226b8275e7ee02964537c  URL=x.com
        rnd_06eab0182b00723a 締切2026-09-21 配布1行
    evt_feb701be0ce3a3e6145548a1  URL=x.com
        rnd_757e5081e47830ee 締切2026-09-21 配布0行

**tsutaya宇和店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_6e17d45339bf7c69ec03ac3e  URL=x.com
        rnd_b86c422efaff88eb 締切2026-08-30 配布0行
    evt_8b46087b3a728919df246501  URL=x.com
        rnd_553da9fe8d74ac39 締切2026-08-30 配布0行

**tsutaya富士八幡町店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_32bfe137f208102c284f0a4e  URL=x.com
        rnd_15ea06d732e13667 締切2026-08-31 配布0行
    evt_a47f3872a167575468b43f60  URL=（まとめ）
        rnd_a22370cb690905f3 締切2026-08-31 配布1行

**tsutaya富士八幡町店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_7dff8bebd9e1f19d094f470d  URL=（まとめ）
        rnd_ec9185274139f9be 締切2026-08-31 配布1行
    evt_ccc0356005dc34cfdc39ead9  URL=x.com
        rnd_743f00568ef92d4f 締切2026-08-31 配布0行

**tsutaya山陽店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ再販分 ｜ 抽選

    evt_7edc0bed4de623a273201413  URL=livepocket.jp
        rnd_3ed56b8815443488 締切2026-08-31 配布0行
    evt_f05f97a7f96dd6c1f46ef283  URL=livepocket.jp
        rnd_31e8b006f3299edb 締切2026-08-31 配布1行

**tsutaya広田店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_c56276d4b14ee350bb537796  URL=x.com
        rnd_0a192fd56110b995 締切2026-08-30 配布0行
    evt_df96127b50251e2cdc1d9964  URL=（無し）
        rnd_095b0c912fae59d1 締切2026-08-30 配布1行

**tsutaya春日井店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_8a3cd1a0522bef2764874266  URL=x.com
        rnd_431b6742d00fede1 締切2026-09-03 配布0行
    evt_ac4c5c1c964708ee6d29c65d  URL=（無し）
        rnd_a2824918ca6f29f0 締切2026-09-03 配布1行

**tsutaya春日井店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_b13edb525dc0fd4cd15a8db4  URL=x.com
        rnd_f085e6dc16ed7dc0 締切2026-09-03 配布0行
    evt_d44fb7072e4f3c52740d340e  URL=（無し）
        rnd_d49d78553f942188 締切2026-09-03 配布1行

**tsutaya柳川店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_4af6bbc84d73e928b4891d16  URL=x.com
        rnd_da898d6ac0ed15d4 締切2026-08-30 配布0行
    evt_6de23e7fe2e39cdf087fa04f  URL=x.com
        rnd_276fa4550067be5f 締切2026-08-30 配布0行

**tsutaya瀬戸店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_5fda7a5221c9084e48461d02  URL=x.com
        rnd_05ee5b9609463e62 締切2026-09-03 配布0行
    evt_9013fe5cd2c8d2c9b6762ca3  URL=x.com
        rnd_350262d507bd08b0 締切2026-09-03 配布1行

**tsutaya瀬戸店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration1box ｜ 抽選

    evt_c7b3c7a9239cef5cbf8c3d7b  URL=（無し）
        rnd_55ca8aba868b64a6 締切2026-09-03 配布1行
    evt_d00b3d02f2f28d4195fb6789  URL=x.com
        rnd_9d4c608fb76963bb 締切2026-09-03 配布0行

**tsutaya辰巳台店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_6ca0fc263a1b27a441021003  URL=x.com
        rnd_4b4042505982a24c 締切2026-09-06 配布1行
    evt_dc6d8b1c7fd296a04138b44b  URL=x.com
        rnd_6b7291d198a3e83c 締切2026-09-06 配布0行

**tsutaya辰巳台店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_0faf1b900264eaf40c001988  URL=x.com
        rnd_432ea81b6372e89e 締切2026-09-06 配布0行
    evt_3a22bc2fc6f2c2227e03c50b  URL=x.com
        rnd_28f8ab188cafefa7 締切2026-09-06 配布1行

**tsutaya辻店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_9f3778c460ed3926a73b2c26  URL=x.com
        rnd_27d5238400f38b6f 締切2026-08-30 配布0行
    evt_d3966f2206134e0a8426931f  URL=x.com
        rnd_2be0f471c22ddeb4 締切2026-08-30 配布0行

**tsutaya追浜店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_326b58d92186be85c7b4a357  URL=x.com
        rnd_954ccc1018e0985a 締切2026-08-30 配布0行
    evt_9a1f025835428c23c9d55983  URL=x.com
        rnd_04ca6893d2c51732 締切2026-08-30 配布0行

**tsutaya追浜店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_c312a7822f1efc1437a7c08e  URL=x.com
        rnd_c90338d151778ddf 締切2026-08-30 配布0行
    evt_dfcb6efa9c8e837abcd74aa7  URL=（無し）
        rnd_ae41848ec505ee3a 締切2026-08-30 配布1行

**tsutaya追浜店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationバラパックでのお渡しシュリンク箱なし ｜ 抽選

    evt_ac1d65967dace8495b632bd5  URL=（無し）
        rnd_d1650aaa9b688f22 締切2026-08-30 配布0行
    evt_c29072968b4dc7e93d36ba16  URL=x.com
        rnd_35a1504bdff79c94 締切2026-08-30 配布0行

**tsutaya鈴鹿中央通店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_5c8d6a1e261aaad87147a785  URL=x.com
        rnd_c7990992471de366 締切2026-09-03 配布0行
    evt_ea084f18164b501b7cb83859  URL=x.com
        rnd_5caff98425e9d217 締切2026-09-03 配布1行

**tsutaya鈴鹿中央通店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration1box ｜ 抽選

    evt_3e5fb5d52f6e00d7f0bf7253  URL=x.com
        rnd_c3048456817ae18a 締切2026-09-03 配布0行
    evt_644cf441842928e8485c37af  URL=（無し）
        rnd_2508d1525eed0d77 締切2026-09-03 配布1行

**おたいちイオン広店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_8571f36953469c969a3787fe  URL=x.com
        rnd_40780749e8da2143 締切2026-09-14 配布1行
    evt_b1ade0cf826f63db893b168c  URL=x.com
        rnd_841a33309e4039ab 締切2026-09-14 配布0行

**おもちゃのペリカン** ｜ pokemon ｜ 30周年記念box30thcelebration ｜ 抽選

    evt_4190d4e96a652b1350566794  URL=mikeco-room.com
        rnd_2ccb4a99dd76ddad 締切2026-08-23 配布0行
    evt_4aa5d4621308c547802e4d49  URL=x.com
        回なし

**お宝創庫プレイズ** ｜ pokemon ｜ ポケモンカードストームエメラルダポケモンカードスターターセットex各種イーブイex、ゾロア&ゾロアークex、ニャオハ&マスカーニャex ｜ 抽選

    evt_a00ca67e09529385a17a8dbb  URL=playze.jp
        回なし
    evt_e6040ed52428730032012d28  URL=www.otakarasouko.com
        rnd_7c4c052b0d28e4d2 締切2026-08-23 配布0行

**ときわ書房ニューコースト新浦安店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ ｜ 抽選

    evt_361d6202622bfcb4e1dcab2f  URL=shoplottery.e-starbox.com
        rnd_198585e2484c900b 締切2026-09-01 配布0行
    evt_871221b319cbb813504018f6  URL=shoplottery.e-starbox.com
        rnd_7ba8379d13331160 締切2026-09-01 配布0行

**ときわ書房ニューコースト新浦安店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックメガシンフォニア ｜ 抽選

    evt_a4baa3a0a78de607a9200ed4  URL=shoplottery.e-starbox.com
        rnd_aad5d75ae105de1d 締切2026-09-01 配布0行
    evt_d4bc4537a3997c922876a92e  URL=shoplottery.e-starbox.com
        rnd_1da605f378c8c31a 締切2026-09-01 配布0行

**ときわ書房ニューコースト新浦安店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックメガブレイブ ｜ 抽選

    evt_0068d4b87cf7af2439fd71a6  URL=shoplottery.e-starbox.com
        rnd_797a4422ed1ab2a0 締切2026-09-01 配布1行
    evt_36719741a6b048ee682d1b33  URL=shoplottery.e-starbox.com
        rnd_d30deb7ab23a53e6 締切2026-09-01 配布0行

**ふるいちトップブックス横越バイパス店** ｜ pokemon ｜ ポケモンカードゲームmegaハイクラスパックmegaドリームex1box ｜ 抽選

    evt_566fc7cc3029354eb9986ec7  URL=x.com
        rnd_aad5245b5407e4ce 締切2026-08-30 配布0行
    evt_c6d8eef637065eb395daf655  URL=x.com
        rnd_4d1f45566820ead1 締切2026-08-30 配布0行

**イエローサブマリン各店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ8月下旬再販分 ｜ 抽選

    evt_12f475f7a6d66ec704f4b387  URL=（まとめ）
        回なし
    evt_775ff1231f2ea08a38932316  URL=livepocket.jp,shoplottery.e-starbox.com,（まとめ）
        rnd_4c9bfe0ffdf41487 締切2026-08-23 配布0行

**エディオントレカキャピタル** ｜ pokemon ｜ プレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_14cc39565322651bd205037e  URL=x.com
        rnd_445e01931402d3b2 締切2026-08-30 配布0行
    evt_3120678ef7be6331eb0d2ca0  URL=edion-cp.com
        rnd_2ec8916f496ff8d6 締切2026-08-30 配布0行

**カードゲームショップりらい福島** ｜ pokemon ｜ ポケモンカード30thcelebrationbox ｜ 抽選

    evt_2449b1b73735ac2e314c540f  URL=x.com
        rnd_0a76094f91874016 締切2026-09-14 配布0行
    evt_927fd6ec465f4c1679a0b8c4  URL=x.com
        rnd_e68ecc4d569932d1 締切2026-09-14 配布1行

**カードゲームショップりらい福島** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationbox ｜ 抽選

    evt_1776b5f4621e23b201c581f9  URL=x.com
        rnd_c3a52f2a938d860e 締切2026-09-15 配布0行
    evt_ff93f21d132e23cb1edd62b4  URL=livepocket.jp,x.com,（まとめ）
        rnd_5b2b6705eb523682 締切2026-09-15 配布0行

**カードショップ@ほ~む。熊本店** ｜ pokemon ｜ ポケモンカード30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_156904beddfa9617831a4106  URL=docs.google.com
        rnd_b4e88f17b7c52d20 締切2026-09-13 配布0行
    evt_5ccec4440dc1d3ec1a4185d8  URL=docs.google.com
        rnd_3746bf4ff4c48b21 締切2026-09-13 配布1行

**カードショップ@ほ~む。熊本店** ｜ pokemon ｜ ポケモンカード拡張パック30thcelebration ｜ 抽選

    evt_1c11e200a1e809c48b245251  URL=docs.google.com
        rnd_aab3bdef4e3496d4 締切2026-09-13 配布1行
    evt_af91c3230dbb2be7f34aa2ff  URL=docs.google.com
        rnd_74d506e4c2553852 締切2026-09-13 配布0行

**カードショップbahamut** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationbox ｜ 抽選

    evt_c7506c3c22807f241ccb25b3  URL=livepocket.jp
        rnd_52f612d594344076 締切2026-09-11 配布0行
    evt_edeb0064ce37d2b2b583ba19  URL=livepocket.jp
        rnd_4e92259efd5e530e 締切2026-09-11 配布1行

**カードショップlight滋賀県草津市** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration1box ｜ 抽選

    evt_0fa37af292dae6626a123131  URL=x.com
        rnd_b7466430248afa4c 締切2026-09-15 配布1行
    evt_9a5c89aeafc498979b19b7fb  URL=x.com
        rnd_f0355ecfa578987a 締切2026-09-15 配布0行

**カードショップアンカー篠山** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationbox ｜ 抽選

    evt_392d573d50fad13546c9f69e  URL=x.com
        rnd_0458d676ca346dd4 締切2026-09-06 配布1行
    evt_f4d2ef45d81b6bf81918de0c  URL=x.com
        rnd_dc036b72875fcb16 締切2026-09-06 配布0行

**カードショップアンカー豊岡** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationbox ｜ 抽選

    evt_04cbc6b817f7d18025bff6c7  URL=x.com
        rnd_eb2baa894a45a6e9 締切2026-09-06 配布1行
    evt_339170bf0bccbe6b806b5b19  URL=x.com
        rnd_9dde36898081ea57 締切2026-09-06 配布0行

**カードショップクラクラ** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration1箱フォロー&リポストキャンペーン第28弾 ｜ 抽選

    evt_8c4730c9152eafd671fe87fb  URL=x.com
        rnd_7bf6b0aeb50c9086 締切2026-09-13 配布0行
    evt_db80874f822ce53352c521f7  URL=x.com
        rnd_f7e194d635176f36 締切2026-09-13 配布1行

**カードショップディライト** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_2aed2ef6ae8e2d340f9188f3  URL=x.com
        rnd_021e434891542d7d 締切2026-09-14 配布1行
    evt_e1cbe2425d07c9078da77a84  URL=x.com
        rnd_65d267edb02d58bf 締切2026-09-14 配布0行

**カードショップ絆スクイーズ大阪駅前梅田第4ビル店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration1box定価抽選販売 ｜ 抽選

    evt_3452d1a3e0c7d608851b091f  URL=x.com
        rnd_3441ffdde296cc11 締切2026-09-13 配布0行
    evt_4124e41fce396a28dcb9d636  URL=x.com
        rnd_351706f962f53108 締切2026-09-13 配布1行

**カードボックス岡崎店本の王国&すまいるキング** ｜ pokemon ｜ ポケモンカード30thcelebration ｜ 抽選

    evt_16353260934589c88316f3cb  URL=（無し）
        rnd_1a68aba6bdfe65dc 締切2026-09-06 配布1行
    evt_ccb53a47009798c6a1550e89  URL=x.com
        rnd_4b499f148459e351 締切2026-09-06 配布0行

**カードボックス本の王国大垣店** ｜ yugioh ｜ 遊戯王ocgデュエルモンスターズoriginalartworkcollection ｜ 抽選

    evt_999b78626cec41248a5e2b5b  URL=shoplottery.e-starbox.com
        rnd_c9571bbde0341684 締切2026-08-31 配布0行
    evt_9f5b8251dee18508559fbb33  URL=shoplottery.e-starbox.com
        rnd_7ce0fcef7dc6337f 締切2026-08-31 配布1行

**カードボックス通販cbトレコロ** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックメガブレイブ1box ｜ 抽選

    evt_3535674fbe39b17f69255c4f  URL=www.torecolo.jp
        rnd_a854a789c9957e9b 締切2026-09-06 配布0行
    evt_a6ca66cf08469ffd54f1f25d  URL=torecolo.jp,www.torecolo.jp
        rnd_700fa54aeb6ae2b8 締切2026-09-06 配布1行

**カードマックス秋葉原店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_aaa2b2e02de8a70d14b648d9  URL=www.cardmax.jp,x.com
        rnd_ea87a96eae1ed46e 締切2026-09-13 配布1行
    evt_e7d85f0034faea7c20c33e93  URL=www.cardmax.jp,x.com
        rnd_84ecb51f2abe27b0 締切2026-09-13 配布0行

**カードラボ秋葉原ラジオ会館本店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ再販分シュリンク無1box購入券 ｜ 抽選

    evt_4fcd91751329dfc546ee8d9f  URL=x.com
        rnd_32870fa2e360544f 締切2026-08-22 配布0行
    evt_9c7a95c7b5f681cdf69d6627  URL=x.com
        回なし

**カーナベル** ｜ yugioh ｜ 遊☆戯☆王originalartworkcollection1box定価での購入権抽選 ｜ 抽選

    evt_5d9317e86f52a52097fe0cc1  URL=x.com
        rnd_3cdcbf4f64159f0b 締切2026-08-31 配布0行
    evt_ae27f379908110873fe5c746  URL=x.com
        rnd_c5dae73c2d0db7fd 締切2026-08-31 配布0行

**ガンギ** ｜ pokemon ｜ ポケモンカードゲームスカーレット&バイオレットコレクションファイルセットリーリエ ｜ 抽選

    evt_99f7a15736efc4b3d9ec50e0  URL=gangi.co.jp
        rnd_a4df646f1f963367 締切2026-09-02 配布1行
    evt_b8720e1abd7e364a9bb7f530  URL=www.gangi.co.jp
        rnd_4ddf77af2e19f384 締切2026-09-02 配布0行

**キデイランドららぽーと富士見店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ再販分 ｜ 抽選

    evt_3de1fb4a0c22cda0bea347a3  URL=（まとめ）
        rnd_9bf1416ae5a87aa5 締切2026-08-17 配布0行
    evt_5c54e7d672258cfb949afddd  URL=shoplottery.e-starbox.com
        回なし

**キデイランド二子玉川店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ30パック=1box1パック200円税込購入整理券の抽選 ｜ 抽選

    evt_b56d29191f9ffe7b2536d165  URL=livepocket.jp
        rnd_12de0f556ee1722d 締切2026-09-03 配布0行
    evt_f1551272c395dbb51e7c0184  URL=livepocket.jp
        rnd_3b7fd095b25f6920 締切2026-09-03 配布1行

**ゲームプラザ元気302** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ1box30パック6,000円税込第6回抽選店頭販売 ｜ 抽選

    evt_421a42624b5cce6adeaf15db  URL=x.com
        rnd_83e52f45eb75877e 締切2026-09-01 配布0行
    evt_7d1661f068f42c1a4e395ee5  URL=docs.google.com,x.com
        rnd_add9a72341c0438b 締切2026-09-01 配布0行

**シーガル各店** ｜ onepiece ｜ onepieceカードゲームブースターパック世界最強の戦士op17 ｜ 抽選

    evt_5a7f8580b2c2aa9f0ad3a871  URL=livepocket.jp
        rnd_b48169cf71234fa5 締切2026-08-17 配布0行
    evt_e54c8511b0db329277c15b43  URL=seagull.membercard.jp
        回なし

**ジャスティス大阪** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ ｜ 抽選

    evt_3dfb3b7c65cb4d965489804d  URL=justice.membercard.jp
        rnd_ea46db59890f69d4 締切2026-08-31 配布0行
    evt_9104e2905126aee1ef534afe  URL=justice.membercard.jp
        rnd_8737cc3542a94ca3 締切2026-08-31 配布0行

**ジャスティス大阪** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックメガシンフォニア ｜ 抽選

    evt_40204de67d0c2d0d64ee9f87  URL=justice.membercard.jp
        rnd_24a4513f8c47e3dd 締切2026-08-31 配布0行
    evt_ce0c2e3cf285426f36ac4839  URL=justice.membercard.jp
        rnd_baabdf385fc553b2 締切2026-08-31 配布1行

**ジャスティス大阪** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックメガブレイブ ｜ 抽選

    evt_9aa11f5d65b148a3ec8b1ffb  URL=justice.membercard.jp
        rnd_9ac082f966d49dc8 締切2026-08-31 配布0行
    evt_bee59f2ed8c2c6360d271afa  URL=justice.membercard.jp
        rnd_4602bf5b9f0ee64a 締切2026-08-31 配布0行

**スーパーフリークス米子店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration1box ｜ 抽選

    evt_b79c27e7501d5cfa95aee069  URL=x.com
        rnd_a71a2e664f5abb52 締切2026-09-06 配布0行
    evt_e1964be68d653c21cf5d8438  URL=x.com
        rnd_6f265df40750d7fd 締切2026-09-06 配布1行

**スーパーフリークス米子店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_66ed5d3ff475ab72d2a7fcfb  URL=（無し）
        rnd_7663b76de64ec0f6 締切2026-09-06 配布0行
    evt_a32d5c316043f56d8c0519e0  URL=x.com
        rnd_a27e543a232acc97 締切2026-09-06 配布1行

**スーパーブックス新白河店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_ee76a5b218516f2614b45927  URL=x.com
        rnd_5dbf19faf753f167 締切2026-09-02 配布0行
    evt_fb5fd0cfe3e155b22441e245  URL=x.com
        rnd_1ded1a3c055b84de 締切2026-09-02 配布1行

**スーパーブックス新白河店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration1box販売時にシュリンクを外して引き渡し ｜ 抽選

    evt_1f8de6f7aa83242fa9db435c  URL=x.com
        rnd_046395daac943f75 締切2026-09-02 配布1行
    evt_e9d19d2361e9bcc2f7798f95  URL=x.com
        rnd_bbd1f3e40aca9a43 締切2026-09-02 配布0行

**トイザらス** ｜ pokemon ｜ 30周年記念box ｜ 抽選

    evt_d24c1c811d83141d7dc34bb5  URL=x.com
        rnd_5f83750e7da115c9 締切2026-08-17 配布0行
    evt_df90a72a7aed54d5ebc58386  URL=twitter.com
        回なし

**トレカtsutaya竹原店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_6ca63760af355b822b1cb8e4  URL=x.com
        rnd_c54391695ba2aad9 締切2026-08-30 配布0行
    evt_8d2c2282a4d3213f7dd7387a  URL=x.com
        rnd_db63c0ec3d9a1d6a 締切2026-08-30 配布0行

**トレカぷれぞんす新所沢本店トレぷれ** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationbox ｜ 抽選

    evt_06a9660599e060ee8ce2c501  URL=x.com
        rnd_6008b07d63e1ac8b 締切2026-09-07 配布1行
    evt_3eb883efae49a77d354435c6  URL=x.com
        rnd_687d8d25e28cf696 締切2026-09-07 配布0行

**トレカエースそよら成田ニュータウン** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_059f448f013cab73f40fc1ac  URL=x.com
        rnd_bf4a1eb3f4f4efb3 締切2026-08-30 配布0行
    evt_6d59ab0af4d6340967ba5450  URL=（無し）
        rnd_b35e9c441202433c 締切2026-08-30 配布1行

**トレカエース下妻店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_c54007676ec294f842d03fb5  URL=（無し）
        rnd_1b18694536106952 締切2026-08-30 配布1行
    evt_d31789f777466646ab177d00  URL=x.com
        rnd_638fcf5e659c8243 締切2026-08-30 配布0行

**トレカエース勝田東石川店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_117bf4eabe92c3920b9a599d  URL=x.com
        rnd_ebd5de01c8212eee 締切2026-08-30 配布1行
    evt_68f22339115f35cee14c27c7  URL=x.com
        rnd_286f28202ae3d90a 締切2026-08-30 配布0行

**トレカエース小名浜住吉店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_04572d10df4cbae3cbf7bc91  URL=x.com
        rnd_cdec1bea0b5e7d92 締切2026-08-30 配布0行
    evt_99a0d66cd40b023a99a39f60  URL=（無し）
        rnd_d15454ea8c107fbb 締切2026-08-30 配布1行

**トレカエース新取手店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_61d7cfab3f5aa1ef2c413811  URL=x.com
        rnd_54f30e11fac61b5d 締切2026-08-30 配布0行
    evt_67d55540442fccdfc043b00e  URL=（無し）
        rnd_6d40a83fea77f4b8 締切2026-08-30 配布1行

**トレカエース日立鮎川店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_7f6cda15b755664218cdf440  URL=（無し）
        rnd_2754d82c219e4e57 締切2026-08-30 配布1行
    evt_c574dd930c6204f780fd1acf  URL=x.com
        rnd_5b7f5400e4b79b35 締切2026-08-30 配布0行

**トレカエース日立鮎川店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_453cf5c19e338ff0857561da  URL=x.com
        rnd_2e4c122166fcb09f 締切2026-08-30 配布0行
    evt_6d191046a3563748f4e8d0d1  URL=（無し）
        rnd_073dec632ab9e63e 締切2026-08-30 配布1行

**トレカエース茨大前店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_1653f9ebb93f0978549dfe9d  URL=x.com
        rnd_fe0a2e879e154a9f 締切2026-08-30 配布0行
    evt_83b96fa013ba93c84d046d0d  URL=（無し）
        rnd_6326996b4b0cf2b5 締切2026-08-30 配布1行

**トレカスタイル** ｜ pokemon ｜ ポケモンカードゲーム拡張パック30thcelebration未開封シュリンク付き ｜ 抽選

    evt_5a78f46c04230be220e2e0fd  URL=livepocket.jp
        rnd_5c3ec07b791532fb 締切2026-08-25 配布0行
    evt_a865847a4a4a64026b329372  URL=（まとめ）
        回なし

**トレカステーションtsutayaハレノテラス東大宮店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_3cb8e1cf27ece5c6987747f2  URL=x.com
        rnd_7727b473c9068a5e 締切2026-08-30 配布0行
    evt_54c1b7730dde936e1bde13e2  URL=x.com
        rnd_4e7fed55efd2e12c 締切2026-08-30 配布0行

**トレカステーションtsutayaハレノテラス東大宮店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_10d8eaab2fe553ecec10dae6  URL=x.com
        rnd_583ebf3d0745579a 締切2026-08-30 配布0行
    evt_bd5ed8e5c426d88c014a3b44  URL=x.com
        rnd_fe2f94b9e64ff48d 締切2026-08-30 配布0行

**トレカビッグホーン** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_69f191df00f380c067da0f81  URL=x.com
        rnd_d334d79825014d45 締切2026-09-06 配布0行
    evt_eb8c942e0a264bda65aa2b39  URL=x.com
        rnd_82da5d0a75313773 締切2026-09-06 配布1行

**トレカライザスネットショップ** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキーおひとり様1個まで全国発送可定価6,200円税込 ｜ 抽選

    evt_c064a73e28443bfbd9119fcc  URL=x.com
        rnd_ee2964c2057e19ad 締切2026-09-03 配布1行
    evt_eba6fab325ce3ddd59e1c195  URL=x.com
        rnd_1645caccadd03c4a 締切2026-09-03 配布0行

**ドラゴンスター各店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー1個までドラゴンスターモバイル会員限定 ｜ 抽選

    evt_27cdd02bae27e70fa46b4ca8  URL=dorasuta.membercard.jp
        rnd_e1edd47941bd5e91 締切2026-09-06 配布0行
    evt_ecdbf8aca45a80d0c14d842f  URL=dorasuta.membercard.jp,x.com
        rnd_26c867785946947e 締切2026-09-06 配布1行

**ドラゴンスター各店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration1boxまでドラゴンスターモバイル会員限定 ｜ 抽選

    evt_506dd6e78a11f57ad952fe47  URL=dorasuta.membercard.jp,x.com
        rnd_5550958d562bf67d 締切2026-09-06 配布1行
    evt_c99d7eca3122918b047e34d6  URL=dorasuta.membercard.jp
        rnd_0e2f6f5b5a62e09e 締切2026-09-06 配布0行

**ドンキホーテ一部店舗** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_9ca31df9eb4af89e94b22bde  URL=x.com
        rnd_e2b4e90c203676c4 締切2026-08-31 配布0行
    evt_b694df0c5dee11c3e5aee32c  URL=x.com,（まとめ）
        rnd_c351f07dd72ff598 締切2026-08-31 配布0行

**ハイパートレカ各店駒井沢店彦根店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキーsunカード会員限定店頭応募 ｜ 抽選

    evt_0e1d547708f9aa4aa4d0214d  URL=x.com
        rnd_ca504cb49dc52a95 締切2026-09-02 配布0行
    evt_8a7d45068e75278a48ee46bc  URL=x.com
        rnd_2c5be34154a73a3e 締切2026-09-02 配布1行

**ビックカメラakiba** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ ｜ 抽選

    evt_6fe47d17fad88069a7c53ce8  URL=x.com
        rnd_2478f03e8619b940 締切2026-08-31 配布0行
    evt_a9d72deb9fc4cf9b0e213833  URL=x.com
        rnd_830a129478be7193 締切2026-08-31 配布1行

**ビックカメラakiba** ｜ pokemon ｜ ポケモンカードゲームスタートデッキ100バトルコレクション ｜ 抽選

    evt_7e317caf2f9601a31783e494  URL=x.com
        rnd_20297a31af58a7b2 締切2026-08-31 配布0行
    evt_8ece402c5387ef101ad0a071  URL=（まとめ）
        rnd_45d7abe26ffe949a 締切2026-08-31 配布1行

**フタバ図書tsutayaトレーディングカード戸田店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_efdccdddfba72963625935c9  URL=x.com
        rnd_81e7aa0f7c477b5a 締切2026-08-30 配布0行
    evt_fa931d3efcc649fc4f9eae56  URL=x.com
        rnd_5a30ca391e4932a3 締切2026-08-30 配布0行

**フタバ図書tsutayaトレーディングカード戸田店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_45c3e79e78f66a3700adefb8  URL=x.com
        rnd_477b6c063fb33880 締切2026-08-30 配布0行
    evt_e8a28a438213994f84c21667  URL=x.com
        rnd_1c006b28e555795c 締切2026-08-30 配布0行

**フタバ図書tsutaya可部センター店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_18c6d0bcd6edaf137ddd7d80  URL=x.com
        rnd_9356c3b18184e699 締切2026-08-30 配布0行
    evt_aa99ff3e81676e54eb95b6d0  URL=x.com
        rnd_9da7a02ded82742f 締切2026-08-30 配布0行

**フタバ図書tsutaya海田店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationbox ｜ 抽選

    evt_2c2dc2d5425ac59c1f78e2cb  URL=x.com
        rnd_cf928958a3a5135f 締切2026-08-30 配布0行
    evt_2fe8cbda47031a107e7eaaca  URL=x.com
        rnd_0ca3cf7ede04d498 締切2026-08-30 配布0行

**フルコンプ** ｜ onepiece ｜ onepieceカードゲームブースターパック世界最強の戦士op17 ｜ 抽選

    evt_21a503e394d810c637d2edf1  URL=livepocket.jp
        回なし
    evt_b3915a507283924162baf883  URL=livepocket.jp
        rnd_892d2b64a809e852 締切2026-08-16 配布0行

**ブックオフプラス新宿駅西口店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration1box ｜ 抽選

    evt_50cbef1ee424e10536f84c95  URL=x.com
        rnd_3a0f11bc52de4132 締切2026-09-09 配布0行
    evt_eb859d67e9f65e5b8195a3a9  URL=x.com
        rnd_285e7296b4b6f780 締切2026-09-09 配布0行

**ブックオフプラス新宿駅西口店** ｜ pokemon ｜ ポケモンカードゲームスタートデッキ100 ｜ 抽選

    evt_0b9a43b71215d86404e529ed  URL=（まとめ）
        rnd_bbcd538bbf0dd670 締切2026-08-31 配布1行
    evt_ff43d5815def2362c0de8979  URL=x.com
        rnd_4d04134a60176219 締切2026-08-31 配布0行

**ブックオフ和歌山国体道路店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ1boxシュリンクを外してのお渡し ｜ 抽選

    evt_1beee3067e6b70e5981bc450  URL=x.com
        rnd_9bec5cf31bc8fa49 締切2026-08-31 配布0行
    evt_b1b2b430422bfc9dc40c484b  URL=x.com
        rnd_bd39ea388a4e075c 締切2026-08-31 配布0行

**ブックオフ川崎モアーズ店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration1boxおひとり様1boxシュリンクを外し箱を開封しての販売販売期間91610:00〜92022:00 ｜ 抽選

    evt_71ee787b700c73fd9e33db4e  URL=x.com
        rnd_9b4a6c33c1ffd792 締切2026-09-13 配布0行
    evt_aef67bda5a5c84e7839fb67f  URL=x.com
        rnd_65df3e5800f02a6e 締切2026-09-13 配布0行

**ブックオフ草加セーモンプラザ店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ ｜ 抽選

    evt_8d22dd9605558345654a0079  URL=x.com
        rnd_ac86d8dece6d4ad3 締切2026-08-31 配布0行
    evt_ce9ce67d7ae4f8be19be1937  URL=x.com
        rnd_79be82c37a1e14bc 締切2026-08-31 配布0行

**プラネット西条中央店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_2556c0b943f8c077c25fa7db  URL=x.com
        rnd_c2eb557d5597681d 締切2026-09-05 配布1行
    evt_ea357fef73132d334d1eed85  URL=x.com
        rnd_a89a0f14d7fc8970 締切2026-09-05 配布0行

**プラネット西条中央店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_1cfdc372097b2c9d50c9340c  URL=x.com
        rnd_7b8ba3a886855c54 締切2026-09-05 配布1行
    evt_71375c7672a8be0af8877c14  URL=x.com
        rnd_4bf2d93f28445eea 締切2026-09-05 配布0行

**プレミアムバンダイ** ｜ onepiece ｜ onepieceカードゲームブースターパック世界最強の戦士op17 ｜ 抽選

    evt_094658136d7ef40845eb66d6  URL=p-bandai.jp
        rnd_4006104c9ace4d33 締切2026-08-18 配布0行
    evt_412ac1ac31e3f6b5f37ff5bf  URL=p-bandai.jp
        回なし

**プレミアムバンダイ** ｜ onepiece ｜ プレミアムカードコレクションonepieceday'26 ｜ 抽選

    evt_005ad23818b64298da454b92  URL=p-bandai.jp
        rnd_866a186a143ee289 締切2026-08-22 配布0行
    evt_25e0528aae46fc47d22e0ee2  URL=x.com
        回なし

**ホクノーだいいちもみじ台店** ｜ pokemon ｜ ポケモンカードゲームmegaスタートデッキ100バトルコレクション ｜ 抽選

    evt_abd9c32bb47939ad7ee7b5c4  URL=（まとめ）
        rnd_1fcc7b933da3a289 締切2026-08-31 配布1行
    evt_f2fcf74a31583808921a2b8c  URL=x.com
        rnd_cdc11307ed2d9fbb 締切2026-08-31 配布0行

**ポケカ専門店n** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationbox抽選販売 ｜ 抽選

    evt_901c40e8e2dd5e5ae54a003b  URL=x.com
        rnd_ec7d312bcbfa398d 締切2026-09-13 配布0行
    evt_9d8ac632ad5e45b7d41b5668  URL=x.com
        rnd_de569f83b2313d9d 締切2026-09-13 配布1行

**ポケモンカードストアイオンモール旭川駅前イオンモール川口前川イオンモール四條畷イオンモール大牟田ららぽーと沼津** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationお一人様10パックまで ｜ 抽選

    evt_753fd93f0510146e07b0b498  URL=shop.pokemon.co.jp
        rnd_2eb712020f7ade7b 締切2026-09-08 配布0行
    evt_f273c2f500de81c43ca1bd2d  URL=shop.pokemon.co.jp
        rnd_709dee9521dd77e5 締切2026-09-08 配布0行

**ポケモンカードラウンジ** ｜ pokemon ｜ ポケモンカードスタートデッキ100バトルコレクション ｜ 抽選

    evt_62e5c828c45e5afaa6f65c82  URL=cloud-pass.jp
        回なし
    evt_b1fe9eacae92437a4a4e36ab  URL=cloud-pass.jp
        rnd_be6beffb00d5adf4 締切2026-08-27 配布0行

**ポケモンセンターオンライン** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationカードセット9種セット ｜ 抽選

    evt_00f32c418b8bd4dc70f4f998  URL=www.pokemoncenter-online.com
        rnd_ea8eba6aca56be5f 締切2026-08-31 配布1行
    evt_75da2c899899ed3b5a7916ac  URL=（まとめ）
        回なし

**ポケモンセンターオンライン** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー追加抽選販売 ｜ 抽選

    evt_0b51bc354f9e55fcc306e1f2  URL=www.pokemoncenter-online.com
        rnd_7751c937eeedb4cf 締切2026-08-31 配布0行
    evt_ea3fb99a8cd8067f42646b63  URL=www.pokemoncenter-online.com
        rnd_cc3c248c7e7cde90 締切2026-08-31 配布1行

**ポケモンセンターオンライン** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationbox ｜ 抽選

    evt_71cccde94e67310194c69bd1  URL=（まとめ）
        回なし
    evt_d4d7da1d3408adda53de6a53  URL=www.pokemoncenter-online.com
        rnd_7586efa9ac2be437 締切2026-08-14 配布0行

**ポケモンセンターオンライン** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationbox追加抽選販売 ｜ 抽選

    evt_2ff411a64b4fb2be553fc145  URL=www.pokemoncenter-online.com
        rnd_6a4468862df84a00 締切2026-08-31 配布0行
    evt_476424c6485f626c0e19c832  URL=www.pokemoncenter-online.com
        rnd_0b786f6e5da17311 締切2026-08-31 配布0行

**マナソース** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_20b0ee4dc4b47a253a4da3f8  URL=（無し）
        rnd_c6b41667e4a64297 締切2026-08-30 配布1行
    evt_bfa9b55158e47eae8bc6b8b5  URL=x.com
        rnd_0efdf83bd98b7c22 締切2026-08-30 配布0行

**ヤマシロヤオンラインショップ** ｜ onepiece ｜ onepieceカードゲームブースターパック世界最強の戦士op17 ｜ 抽選

    evt_a545bf1c4fcc761da44562d1  URL=docs.google.com
        回なし
    evt_e13a26c93f3df0b330c48326  URL=docs.google.com
        rnd_d1341d5eb0fd43d7 締切2026-09-01 配布1行

**ヤマダデンキ** ｜ pokemon ｜ 30周年記念box30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_da342dfb12d0d00138284a33  URL=www.yamada-denki.jp
        rnd_2bdc8fb1368c32fb 締切2026-08-19 配布0行
    evt_f6c87912c0e5794f45612ae5  URL=x.com
        回なし

**ヤマダデンキ** ｜ pokemon ｜ 拡張パック30thcelebration ｜ 抽選

    evt_a166e62c084515ef9c31d2e0  URL=www.yamada-denki.jp
        rnd_8ce86608ce2b5525 締切2026-08-19 配布0行
    evt_d69abf6f4f64c3816ec0202a  URL=x.com
        回なし

**ヨドバシドットコム** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_5cb25319b9753d1f58bd7ab1  URL=limited.yodobashi.com
        rnd_651cdff2c55f730a 締切2026-09-01 配布0行
    evt_e5f772004ec76671fa1f144d  URL=limited.yodobashi.com
        rnd_23bf42eeb62ff81c 締切2026-09-01 配布0行

**ヨドバシドットコム** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_20e4d8bec4be6a9de0f76e30  URL=limited.yodobashi.com
        rnd_37882603211d2be0 締切2026-09-01 配布1行
    evt_40264c573101fdf5dae3da4c  URL=limited.yodobashi.com
        rnd_b72a657aad41c298 締切2026-09-01 配布0行

**三洋堂トレカ館穂積店** ｜ pokemon ｜ ポケモンカードゲームmegaスタートデッキ100バトルコレクション ｜ 抽選

    evt_9e8c3d343092bc205a5f236b  URL=x.com
        rnd_34d32332ee95fe68 締切2026-08-30 配布0行
    evt_fe2fecd24be2795d4c00d4a1  URL=x.com
        rnd_72053c181ec0d91d 締切2026-08-30 配布0行

**三洋堂トレカ館穂積店** ｜ pokemon ｜ ポケモンカードゲームmegaハイクラスパックmegaドリームex ｜ 抽選

    evt_07f24e0a1a9313a3e89e6794  URL=x.com
        rnd_bd29469d38cce14a 締切2026-08-30 配布0行
    evt_95bc003518f4a4ff1325ca09  URL=x.com
        rnd_0c1c894d7ecfaea6 締切2026-08-30 配布0行

**三洋堂トレカ館穂積店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックストームエメラルダ ｜ 抽選

    evt_b44fdad49060c7d48691052c  URL=x.com
        rnd_e93a1d0dcf56a29b 締切2026-08-30 配布0行
    evt_c5127a1cc3b3b5082596566e  URL=x.com
        rnd_e1e9f14cfe67bfb3 締切2026-08-30 配布0行

**北国書林辰口店cardbox** ｜ dragonball ｜ brightness ｜ 抽選

    evt_d78499ec07e6b7802291db62  URL=（無し）
        rnd_74c7146615c48b97 締切2026-09-05 配布0行
    evt_ddfb9c84dad059e9c6f9a030  URL=x.com
        rnd_364f45d5105fcb54 締切2026-09-05 配布0行

**平和堂** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_021e53657bcc02e817739f67  URL=www.heiwado.jp
        rnd_c8472341d6f3b517 締切2026-09-03 配布0行
    evt_59711a3bc5ece672323c185b  URL=heiwado.jp,www.heiwado.jp
        rnd_1e30806c4d119df9 締切2026-09-03 配布1行

**平和堂** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_00b1fdbb06822613b1a47717  URL=heiwado.jp,www.heiwado.jp
        rnd_53acb1dc91c5bf72 締切2026-09-03 配布1行
    evt_fb1f8f5dce9b58544c36c060  URL=www.heiwado.jp
        rnd_78ca20264ec0bbb9 締切2026-09-03 配布0行

**文真堂書店上原店** ｜ pokemon ｜ ポケモンカードゲームmega30thcelebrationプレミアムデッキセットエーフィブラッキー ｜ 抽選

    evt_a9da92b56e1bd15fd65f0534  URL=x.com
        rnd_d9515558849f0cd5 締切2026-09-02 配布1行
    evt_d9b2a2a8ddd9de2248ada5cc  URL=x.com
        rnd_7ed1bf6e7c535e8d 締切2026-09-02 配布0行

**文真堂書店上原店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_2b5b0ab03d0f63dbc7745bc7  URL=x.com
        rnd_ae1e059d37630566 締切2026-09-02 配布1行
    evt_4c3706e7f808070a35e2abcf  URL=x.com
        rnd_9934fb4b9ce9b7f8 締切2026-09-02 配布0行

**有隣堂ららぽーと海老名店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebration ｜ 抽選

    evt_4f16de781d9beeee4294c926  URL=x.com
        rnd_7478b1c4c58b1216 締切2026-09-07 配布1行
    evt_73b05cfd516f7c77e46007a9  URL=x.com
        rnd_6eddad031fcb00b7 締切2026-09-07 配布0行

**楽天ブックス** ｜ dragonball ｜ story ｜ 抽選

    evt_45652b47534cca570892dd79  URL=books.rakuten.co.jp
        rnd_88a0677190b88380 締切2026-08-30 配布1行
    evt_84b3175d20b7c174cfe2e1f9  URL=books.rakuten.co.jp
        rnd_86788ede7f8a357b 締切2026-08-30 配布0行

**楽天ブックス** ｜ onepiece ｜ onepieceカードゲームブースターパック決戦の刻op16 ｜ 抽選

    evt_32a6b46fce93df6ffb288049  URL=books.rakuten.co.jp
        rnd_c3a0285367cc2783 締切2026-08-30 配布0行
    evt_9e826b1944c3a63e00729a31  URL=books.rakuten.co.jp
        rnd_ec99c84c9ce2030b 締切2026-08-30 配布0行

**楽天ブックス** ｜ onepiece ｜ onepieceカードゲームブースターパック蒼海の七傑op14 ｜ 抽選

    evt_04421eff5eb9d9cf8d0c8335  URL=books.rakuten.co.jp
        rnd_4944be47aaa020a2 締切2026-08-30 配布0行
    evt_41af8ac445a9312770485fa5  URL=books.rakuten.co.jp
        rnd_af76e639acda4b86 締切2026-08-30 配布1行

**楽天ブックス** ｜ pokemon ｜ ポケモンカードゲームmegaスターターセットex3種イーブイexニャオハ&マスカーニャexゾロア&ゾロアークex ｜ 抽選

    evt_89d970ae6da46f7e1cc29bcc  URL=books.rakuten.co.jp
        rnd_de395b023c28dec4 締切2026-08-30 配布1行
    evt_9894f580e9bda16407b066d1  URL=books.rakuten.co.jp
        rnd_39b041cc2e16c26a 締切2026-08-30 配布0行

**楽天ブックス** ｜ pokemon ｜ メガブレイブ ｜ 抽選

    evt_b1b9907ab77b501b8c29dbc7  URL=a.r10.to,item.rakuten.co.jp
        rnd_cbe0928fd2d23019 締切2026-08-30 配布0行
    evt_ec4e7cc45895e5da568cac74  URL=item.rakuten.co.jp
        rnd_cf10289e195a5f2c 締切2026-08-30 配布1行

**福福トレカ通販店** ｜ pokemon ｜ ポケモンカードゲームmega拡張パックメガブレイブ1box ｜ 抽選

    evt_083aef1367a4c9ad9ee76ec4  URL=pokemon.fukufukutoreka.com
        rnd_e87e307df7116398 締切2026-09-03 配布0行
    evt_fe818953cd38ff63814f58af  URL=pokemon.fukufukutoreka.com
        rnd_c3397b608634a544 締切2026-09-03 配布0行

**駿河屋通販** ｜ pokemon ｜ ポケモンカードゲームmega拡張パック30thcelebrationbox ｜ 抽選

    evt_2093f7cd47ae7fc3df3325be  URL=livepocket.jp,x.com,（まとめ）
        rnd_c1edd48950915cec 締切2026-09-06 配布0行
    evt_e1513fc96cf28abbfd6cd551  URL=ryuunoshippo.membercard.jp,www.suruga-ya.jp
        rnd_cf15672ea7545a02 締切2026-09-06 配布0行

