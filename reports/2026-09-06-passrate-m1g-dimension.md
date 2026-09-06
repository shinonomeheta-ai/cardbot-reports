# T に店の次元を足す（M1g・PR #1352）

セッション名: metrics
日付: 2026-09-06（JST・15:10 時点）
区切り/依頼名: 判断: T に店の次元を足してください（提案6の形で）
対象: PR [#1352](https://github.com/shinonomeheta-ai/cardbot/pull/1352)（枝 feat/passrate-m1g・base 6e46ebb7）

## 受けた指示（原文）

> # 判断: T に店の次元を足してください（提案6の形で）
>
> ## T に店の次元を足す（提案6）
> 実装してください:
> - 各 record の extra に m1g:<数> を足す。判定は link_golden_chains の1本を呼ぶ
> - チェーン別は日次の --write で台帳から作る（行は太らせない）
> - 判定は「まず数だけ日次表に出して、しきい値は1〜2週間見てから」
>
> ## 記録として
> 「M1g の主経路は S1 と EC 一覧」——設計書 §1 に、大手チェーンは公式サイトと EC 一覧が主で、
> 公式X は補助、と明記してください。x-intake の報告（公式X未登録12チェーン）と合わせて。

## 指示と過去の報告の食い違い

1 つ。私の朝の報告（2026-09-06-m1g-in-passrate）は「52 チェーンのうち公式X表にいるのは 6」と書いたが、これは**昼の枠で開けた口を本部名の完全一致で数えた値**で、公式X の登録の有無ではない。x-intake の手集計は 40 チェーン 282 口（未登録 12）。今回の機械の寄せ（支店を含む）では **42 チェーン 317 口（未登録 10）**。設計書には機械の値を書き、x-intake の 12 との差（C-labo・プレイズ・ドン・キホーテ・iAEON・ポケモンセンター(実店舗) に支店や「一部店舗」の口がある）を併記した。朝の報告には追記で訂正した。

## 報告

### 0. 結論を先に

- PR #1352 を出した。**行には M1g の数だけ、チェーン別は日次で台帳から**、判定はまだ入れない——指示の 3 点そのまま。
- 判定の 1 本は `golden_chain_index.チェーン`。**`link_golden_chains` に置くと候補AIの経路から xAI の宛先まで import で辿れてしまう**（試験が赤になった）ので軽いモジュールへ切り出し、`link_golden_chains` は同じ物を使う（名前は残る）。
- 設計書 §1-2b に「大手チェーンの主経路は公式サイトと EC 一覧・公式X は補助」を、§10-1 に店の次元を書いた。

### 1. 行に足した数（`passrate.m1g(店名たち)` → `m1g`＝本部名で一致・`m1g_branch`＝支店を含む）

| 部品 | 足した鍵 | 意味 |
|---|---|---|
| S2 | `m1g_opened` / `m1g` | 開けた口のうち M1g の店／告知のうち M1g の店 |
| L | `m1g_new` | 新規の応募回のうち M1g の店 |
| V5 | `m1g` / `m1g_end_confirmed` | 判定した回のうち M1g／そのうち締切 confirmed |
| P | `m1g` / `m1g_dropped` | 配る行のうち M1g／落とした行のうち M1g |
| S1 | `m1g` | 拾えた抽選のうち M1g の店 |

どれも `_branch` の対を持つ。店名は行に残さない。1 行に足すのは整数 2〜4 個。

### 2. チェーン別（`passrate_m1g.py`）

- `passrate.py --write`（update-data）が同じ時点の台帳から作り、`history/passrate/m1g/<日付>.json` に 1 日 1 ファイル（同じ日は上書き＝その日の最新）。`passrate_daily.json` の `m1g` に直近 14 日を写す。持ち帰りは既存の `git add history/passrate`。
- 52 本すべてを出す（0 の本が「入口に居ない」を示す）。部品ごとに独立して数え、台帳が 1 つ読めなくても他は出す（`errors` に残す）。
- S2 だけ支店を含めて寄せる（公式X の登録は支店名が多い）。L〜P は本部名の一致だけ（カードに支店の回は入れない・§3-1-1）。
- 実データで回した 1 日ぶん（書かずに捨てた）: 12KB。

```
S2  opened 910 / opened_m1g 180 / announcements 123 / announcements_m1g 29
L   new 107 / new_m1g 4 / rounds_m1g 307 / active_m1g 121
V1  official 117 / no_official 4
V5  judged 22 / judged_m1g 2（end:missing 2）/ 累計 177（confirmed 55・missing 112・conflict 10）
P   kept_m1g 37 / dropped_m1g 6（not_reviewed_ec 4・date_conflict 1・no_official 1）/ rows_m1g 37
```

（朝の手集計と数が少し違うのは台帳が進んだためと、S2 が 1 日ぶん・支店込みになったため）

### 3. 判定の 1 本と、途中で見つかった問題

`golden_chain_index.チェーン(店名, 支店も=False)`: 本部名・`store_keys`・`extra_store_keys`・`ec_source_name`（S1 の登録名）と、既知サフィックスを外した形の完全一致。`支店も=True` のときだけ前方一致（長いベース名から。`ポケモンセンターオンライン` が `ポケモンセンター` より先）。**明示の鍵は派生の鍵より先**——`ポケモンセンターオンライン` から `オンライン` を外すと `ポケモンセンター` になるが、それは実店舗の明示の鍵なので実店舗に寄せる（最初の版はここを間違えていて、試験で留めた）。

**見つかった問題**: 索引を `link_golden_chains` に置いたら `test_candidate_ai_haiku_first.test_5（通常実行経路から xAI へ届かない）` が赤になった。`link_golden_chains` → `store_registry` → `build_lotteries_nyuka` → `lottery_conflicts` → … → `x_rewrite` / `resolve_urls`（xAI の宛先）まで import で辿れ、`candidate_ai_haiku_review` → `passrate` → `link_golden_chains` で候補AIの経路に入る。軽いモジュール（import は `store_canon` と標準ライブラリだけ）へ切り出し、`test_passrate_m1g` が「`passrate` から `store_registry` へ辿れない」を留める。

### 4. 設計書

- §1-2b: 「大手チェーン（M1g）の主経路は公式サイト（§1-1・§1-2b）と EC 一覧で、公式X は補助」。公式X 未登録 10 チェーン（機械の寄せ）と x-intake の 12 の差を併記。
- §10-1: 店の次元（上の 1〜2）と、索引を軽いモジュールに置く理由。

### 5. 試験

手元: passrate 系＋golden 系 124 本・候補AI haiku 304 本・触ったモジュール 268 本が緑。赤は `test_link_golden_suffix` の Windows の relpath（C:/D: 越え・手元だけ・main と同じ）1 本のみ。CI は待ち。

### 6. 次

- CI が緑ならマージ（マージの条件を満たせば自分で）。
- 最初の日次は次の update-data。**しきい値はまだ入れない。** 1〜2 週間、`passrate_daily.json` の `m1g` を見て「M1g の新規が n 日続けて 0」「開けた M1g が前日比で減る」のどれを鳴らすか決める。

## 根拠データ

- [2026-09-06-m1g-in-passrate.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-06-m1g-in-passrate.json) — 朝の手集計（比較用）

## 状態

PR #1352 CI 待ち。
