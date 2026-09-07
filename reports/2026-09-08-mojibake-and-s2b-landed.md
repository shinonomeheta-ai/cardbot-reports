# 化けた保存本文の無効化（HMV 0→5件）と、S2b の着地

セッション名: store-name-b
日付: 2026-09-08（JST）
区切り/依頼名: 今日の2件
対象: `origin/main` = `0104d2ea`

**画面 7社（M1g 本部・受付中）／上流 24社。** 前回（09-07 23:20）から変化なし。
今日取れた HMV の5件は締切済みなので、**社数は増えていない**（指示のとおり）。

## 受けた指示（原文）

> 【今日やること・2つ】
> 1. 化けた保存本文17本（うち HMV 11本）を無効化すること。
>    api-customer が「HMV は取り直せば5件すべて通るが、保存済みの化けた本文を先に使うため本番は0」と
>    報告している。無効化すれば HMV が通る。HMV は M1g の本部。
>    取れた5件は締切済みなので今日は社数が増えないが、安くて確実に効く。
> 2. S2b の rows を押し直すこと。2回とも rebase 競合で控えに入っている。
>    巡回は止めていないので、競合しにくい時間帯を選ぶこと。

## 1. 化けた保存本文の無効化 → PR #1450

### 直した場所

`linked_page_cache.text_of()` が、使えない本文のときは空を返すようにした。
判定は **`candidate_evidence_fetch.text_problem()` の1本**（§11-1）で、規則を
書き写していない。判定が読めなければ「問題なし」に倒す——判定が落ちたせいで
捨てると、取り直しが毎回走るため。

**消さない。** 行は残し、次の巡回で `読む()` が取り直して上書きする。

### なぜ `text_of` なのか

`fetch_status` は HTTP の話なので、文字コードを読み違えた本文も `ok` で保存される。
読む側（`official_page_intake.読む`）は `if not t` でしか取り直さないので、
**一度化けて保存されると、取り方を直しても永久に化けたまま**になる。
ここを塞げば、17本を手で消さなくても次の巡回で入れ替わる。

### 実測（HMV・M1g の本部）

```
直す前   links 5 → read 5 → lottery 0
直した後 links 5 → read 5 → lottery 5   （締切も5件とも取れた）
```

| | 本文 | U+FFFD | `ページは抽選か` |
|---|---|---|---|
| 保存済み | 7,987字 | 401 | False |
| 取り直し | 4,146字 | 0 | **True** |

### 効く範囲（保存済み 663本）

```
無効化される 20本
  mojibake        17  hmv 11 / r10.to・a.r10.to 6 / cardmax 1 /
                      otakarasouko 1 / dmp-ranking 1
  cdn_error_page   3  楽天短縮URLのCDNが HTTP 200 で返すエラー参照番号
正常な本文 477本はそのまま残る
```

指示の「17本」に、`cdn_error_page` 3本が加わって **20本**になった。どちらも
`text_problem` が同じ関門で見ているもので、規則を足してはいない。

### 試験

`test_linked_page_cache` に5件追加（化けた本文／bot確認／**正常は落とさない**／
判定は1本／判定が読めなくても本文を捨てない）。

### CI

| | 件数 | failures | errors |
|---|---|---|---|
| #1450（run 34134398037） | 7,812 | 4 | 2 |
| **素の main（run 34135177989）** | 7,807 | 4 | 2 |

**落ちている試験の名前まで完全に一致。新規の赤なし。**
（`test_candidate_ai_runner`×2 / `test_lottery_overrides`×2 /
`test_store_logo_manual` / `test_url_candidate`）

`test_store_logo_manual` と `test_url_candidate` は今日の基準に初めて出たが、
**素の main でも同じく落ちている**ので私の変更ではない。

## 2. S2b の rows が着地した → `bf312fb`

3回目で通った。**nyuka-watch が終わった直後の窓**を選んだ（前2回はその窓を
外していた）。

```
run 34133142765  success
  S2b: sources 3 / skipped 1 / links 22 / read 22 / lottery 3
       候補台帳へ 3 行（新規 2）
  Commit artifacts: a39f1c5..bf312fb  HEAD -> main
    shadow_candidates.json +170 / official_site_watch_state.json +12（新規）
    history/passrate/2026-09-07/ec-lottery-watch-34133142765.jsonl +2
```

### 期待表と実物の不一致が解消した

`passrate` に **S2b の実物の行**が入った。

```json
{"part": "S2b", "in": 22, "out": 3, "dropped": 19,
 "reasons": {"not_lottery": 18, "unreadable": 1},
 "extra": {"sources": 3, "skipped": 1, "links": 22, "with_end": 0,
           "applied": 1, "m1g": 3, "m1g_branch": 3}}
```

**拾った3件は全部 M1g の本部**（`m1g: 3`）。`official_site_watch_state.json` も
初めて main に入り、`seen` に 古本市場1 / 晴れる屋2 2 / 駿河屋0 が記録された。

### 押し直しの提案について

3回目が通ったので**急ぎではなくなった**。ただし構造は変わっていない
（`ec-lottery-watch` は `git pull --rebase` 1回で諦める・`nyuka-watch` は
取り込み直して作り直す段を持つ）。**窓を選べば通る／外すと落ちる**という運用に
なっている。前の報告に書いた提案はそのまま残す。

## 根拠データ

- [2026-09-08-mojibake-and-s2b-landed.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-08-mojibake-and-s2b-landed.json)
  — `origin/main` 0104d2ea。無効化される20本の内訳、HMV の前後、S2b の着地した
  commit と passrate の行、CI の基準比較。

## 次（そのあと、と言われたもの）

- 条件B の違反5件のうち**残り4件（抜粋の混入）** — ミント仙台店・お宝創庫・
  TCバトロコ小山駅前・ポケモンカードストア。次に着手する
- エディオン ⇔ トレカキャピタルの1件は ci が回答する（承知した）

## 未着手（持っていてよい、とされたもの）

- 429 の記録を見た4社の再分類（**HMV は今日で決着**——文字コード＋キャッシュ。
  残るはイエローサブマリン・iAEON・トイザらス）
- 17社の一覧特定
