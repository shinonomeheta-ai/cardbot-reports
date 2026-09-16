# 本社全件のポストとサイトを一周した（2026-09-17）

## 指示文（本人 2026-09-17）

> 前回、本社の収集手順を修正して、これまでやっている本社全件のポストとサイトを収集する
> やつを実行したい。一旦、今あるデータを更新できるようにしたい。可能ですか？前回実行して
> いたのですが、Windowsの再起動によってデータが失われてしまった可能性があります。
> 現在の状態を確認してから作業を始めてください。

## 先に結論

* **失われていたものは無い。** 前回の直しは2か所に分かれて残っていた。
  コミット済みの分は `fix-x-next-always-assemble`（GitHub に push 済み・同じSHA）、
  未コミットの分は `D:\cardbot` の作業ツリーのファイルとして残っていた。再起動でも消えない。
* **ただし配信データは止まっていた。** 原因は再起動ではなく、巡回の関門。
  `web/public/data/latest.json` の `generated_at` が **2026-09-16T13:02:37+09:00** で固まっていた（約18時間）。
* 収集は一周させた。**候補台帳 3,381 → 3,409（+28）**。

## 1. データが止まっていた原因（再起動とは無関係）

`nyuka-watch` の「データ契約（通知の前）」= `python -m unittest test_data_contract`。
**落ちるとその回は push しない。** 収集自体は走るので run の中身は普通に見えるが、
`lotteries.json` が main へ出ない。

`#1600`（本人指示「Pythonテストはお願いした時だけ回す」）で `python-test.yml` から
`schedule` を外したのに、関門の `test_全件は1日2回mainで走る` が「schedule が2本ある」ことを
まだ求めていた。現 `origin/main`（281ffffb1）で手元実行しても、この1件だけ FAIL する。

同じ直しの **PR #1603** が別セッションから先に出ていた（2026-09-17 06:40 JST）。
こちらでも同じ直しを出しかけたが（#1604）、重複なので閉じた。
**#1603 がマージされて次の `nyuka-watch` が緑になるまで、配信データは動かない。**

## 2. 持ち込んだ直し（未コミットで残っていた分・2026-09-16 作業）

| ファイル | 中身 |
| --- | --- |
| `golden_intake_accounts.py` | 本店の口を複数持てるようにする（`hq_handles`）。通販は台帳の店名かつ本店と同じ公式Xのときだけ本店。支店形（秋葉原店）は `store_keys` や同じ公式Xでも本店にしない |
| `official_site_watch.py` | 一覧そのものが告知ページの社（`self`）と、既知の告知ページ（`pages`）を毎回見る |
| `official_site_sources.json` | YAMADA・HMV&BOOKS online・ヨドバシカメラを追加。ポケモンセンター(実店舗)を検索経由へ |
| `ec_lottery_sources.json` | ヤマダ電機・あみあみ・イオンスタイルオンラインの入口を実測へ合わせる |
| `test_golden_intake_accounts.py` | 上の規則の試験 |

本店の口は、この直しを入れると **8口 → 21口**（`origin/main` の台帳だけでは8口しか歩かない。
残りは `fix-x-next-always-assemble` の台帳確定分）。

## 3. 一周の結果（2026-09-17 06:55〜07:25 JST・通信のみ・AIは使っていない）

```
公式X（本店21口）   開いた 21 ／ 新しい投稿 50 ／ 告知 3 ／ 新規候補 3
公式サイト S2b      18社 ／ リンク  87 ／ 読んだ 63 ／ 抽選 26（締切つき 7）
EC一覧   S1        44社 ／ リンク 142 ／ 読んだ 61 ／ 抽選 14（締切つき 7）
```

候補台帳（`shadow_candidates.json`）は **3,381 → 3,409（+28）**。

公式Xで新しく拾った3件:

```
ドラゴンスター    蒼海の七傑                        〜2026-09-17
ヨドバシカメラ    （商品名未取得）                    〜2026-09-22
イエローサブマリン  「30th CELEBRATION プレミアムデ…」   締切未取得
```

X のタイムライン（syndication）は21口中17口が **429** を返し、描画経路へ落ちた。
4口はタイムラインで取れた。既知の挙動で、取りこぼしではない（全21口を開いている）。

## 4. 置いた場所

* ブランチ **`run/hq-intake`**（commit `b117b03a5`）。土台は `fix-x-next-always-assemble`（3f5a7b51c）。
* 手元の試験: `python -m unittest test_golden_intake_accounts test_official_site_watch
  test_official_x_intake test_publish_verdicts` → **172件 OK**。CI は起こしていない。

## 5. 判断が要ること

1. **`fix-x-next-always-assemble` に PR が無い。** `origin/main` との差は 20コミット・40ファイル
   （LivePocket、GIRAFULL、商品マスタ、M1g への追加、`sweep_m1g_intake.py` など）。
   このブランチが main へ入らないと、本店21口の台帳も今回の+28件も配信に乗らない。
   main を取り込むと `web/app/admin/x-next-panel.js` など7ファイルで衝突する
   （#1601・#1602 のポスター作業と重なる）。
2. **PR #1603 のマージ。** これが入るまで配信データは 09-16 13:02 で止まったまま。

## 6. 数え方

* 時点: 2026-09-17 07:25 JST（実行時刻）
* 母数: 公式X＝本社台帳で確定した本店の口21、S2b＝`official_site_sources.json` の18社、
  S1＝`ec_lottery_sources.json` の44社
* 定義: 「抽選」は `official_page_intake` が抽選と判定した記事。「新規候補」は
  `shadow_candidates.json` に無かった鍵
* 比べ方: 同じ作業ツリーの実行前後（`git show HEAD:shadow_candidates.json` と実物）
