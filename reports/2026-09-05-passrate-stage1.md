# T（通過率の計測）段1の実装: PR #1312 と、見張りの狼少年を止める PR #1311

セッション名: metrics
日付: 2026-09-05（JST）
区切り/依頼名: T の実装・段1（P と S2）＋判断2の先行 PR
対象: `origin/main` = 24ab5f77 から切った枝（`feat/passrate-stage1` / `fix/collection-watch-retired-sources`）。専用 worktree で作業し、共有の作業ツリーは触っていない。

## 受けた指示（原文）

> # 判断
>
> ## 設計を承認します
> 「1つの記録関数・1つの置き場・1 run 1 ファイル」の方針に同意。
> 特に「部品の出口でその部品がもう持っている数を書くだけ。台帳を読み直さない」が正しい。
> 読み直すと所要が増え、しかも判定を写すことになって U に反する。
>
> 期待表（この workflow のこの段ではこの部品の行が出るはず）で配線の欠落を
> 異常として捕まえる設計も、今日「仕組みはあるが配線の1か所で死んでいる」を
> 何度も見た経験に対する直接の対処です。
>
> ## 判断1: v14 の §0 / §10 をリポジトリの設計書へ入れる → T の実装 PR に含めてください
> 記号の正本がリポジトリに無いまま記号で記録を書くと U に反する、という指摘が正しい。
> docs セッションに別途依頼していましたが、そちらは動いていないので、
> metrics が T の実装と同じ PR で入れてください。
>
> ただし設計書全体の差し替えではなく、§0（部品記号の一覧）と §10（通過率の計測）の
> 2節を足す形で。他の節は他セッションが触る可能性があるので変更しない。
>
> ## 判断2: check_collection.py は置き換え（外す）
> 毎回鳴っている狼少年を止める。並走させると通知が二重になります。
> ただし置き換えの PR は、T の check が実際に鳴ることを確認してから。
> 順番: T の record → daily → check が動く → check_collection を外す。
>
> ## 実装の順番: 提案どおり
> 1. passrate.py（record / daily / check）＋ vocab ＋ test_passrate_wiring ＋ 持ち帰り6件
>    部品は P と S2 の2つだけ先に通す
> 2. L・L2・V7・V3・F・H1/H2（nyuka-watch 内で完結）
> 3. S1・S3/V4・V5・D1・N・N2
> 4. check を health-watch へ配線、check_collection を外す
>
> 1 の PR を出してください。P と S2 だけで、記録が持ち帰られることまで確認して。
>
> ## 付記の事故2件
>
> ### nyuka-watch が5回連続失敗中
> これは ci へ渡します。`lottery_io.台帳が壊れている` で、別名整備の後に出ている。
> L2 の「拒否回数」を数えていれば1回目で見えた型、という指摘のとおりです。
>
> ### health-watch の狼少年
> 判断2 で対処します。それまでの間、KNOWN_SOURCES から4ソースを外す小さな PR を
> 先に出してもらえますか。T の実装を待たずに止められます。
>
> ## 記録として
> 「§10-1 の形で残っている部品は1つも無い」「持ち帰っていない記録が6つ」——
> この2つは設計書 §10 に「なぜこの部品が要るか」の実例として足してください。

## 指示と過去の報告の食い違い

なし。

## 報告

### 0. 出した PR（2本）

| PR | 内容 | 状態 |
|---|---|---|
| [#1311](https://github.com/shinonomeheta-ai/cardbot/pull/1311) `fix/collection-watch-retired-sources` | `source_stats.KNOWN_SOURCES` から 08-31 に止めた4ソースを外す（`RETIRED_SOURCES` へ）。健全性の試験は見本名を patch で戻す | CI 済み（赤は main と同じ2件の実データ試験だけ・PR 由来の赤なし）。**マージ待ち** |
| [#1312](https://github.com/shinonomeheta-ai/cardbot/pull/1312) `feat/passrate-stage1` | `passrate.py`（record / daily / check / --write）・P と S2 の記録・語彙・期待表と配線試験・持ち帰り6件・設計書 §0 / §10 | CI 済み（python test の赤は main と同じ2件・vocab 緑・web build の赤は main のデータのずれ〔下の 5〕）。**マージ待ち** |

2本は同じファイルを触らない（#1311 は `source_stats.py` と試験だけ）。

### 1. #1312 で入れたもの

**`passrate.py`（新規・約 400 行）**

- `record(part, in, out, dropped=None, held=0, reasons=None, extra=None, ms=None)`: 1 部品 × 1 run を 1 行。`in == out + dropped + held` を検査し、合わなくても書いて `extra.mismatch` の印。未登録の語（`extra.unknown_reasons`）・未登録の記号（`extra.unknown_part`）も同じ扱い。**失敗しても呼び出し元を止めない。**
- 置き場: `history/passrate/<日付>/<workflow>-<run_id>[-<attempt>].jsonl`。workflow 名は `GITHUB_WORKFLOW_REF` のファイル名から取る（`GITHUB_WORKFLOW` は表示名でファイル名と違うことがある）。段は `PASSRATE_LANE`（nyuka-watch の `Decide lane` が env に出す）。`GITHUB_ACTIONS` が無い手元は `history/passrate/local/`（gitignore）。
- `daily(days)`: 日 × 部品。flow（S1〜S4・D1・V2・V4・V5・L2・F）は合計、snapshot（それ以外）はその日の最後の run。行が無い日も空で出す。`extra` の整数は flow で合計する（`save_failed` を日で数えるため）。
- `check()`: §10-2 の判定5つ。① 通過率0（24h の全 run で入力 ≥ 10・出力 0）② 配線切れ（期待表の部品の行が無い。workflow ごと無ければ弱い合図）③ 前日比の急変（±30pt または 1/3・3倍。**flow は完全な2日で比べる**——今日の途中の合計と昨日を比べると朝は必ず急減に見える）④ 保留の増加（H1 が3日連続増・3日前比 +20%）⑤ N2 の表が +10 なのに引けた数が伸びない。`check` は `alert.send_alert` で鳴らす（段4で `alert_incident` へ配線）。
- 期待表 `EXPECTED`: 段1は `nyuka-watch(fast/roundup/full) → P`・`update-data → P`・`official-x-intake → S2`。

**P**: `publish_reviewed_only.main` の「配布 N 行 → 配る M 行 ／ 落とす K（内訳）」をそのまま1行に。`extra` に `no_candidate_mapping`・`platform_owner_unregistered`・`applied`。数え直しは無い（`判定表` を dry-run でも組むようにしただけ）。

**S2**: `official_x_intake.main` の集計 `r` を流す（in=取得した投稿・out=告知と判定・reasons `not_announcement`・extra に accounts / opened / new_candidates / misses / stopped_early）。速度制限で開けなかったぶんは「落ちた」ではなく `stopped_early` の印。再適用 `merge_intake_artifacts` は **`save_failed=1` の印だけの 0 件行**（本体の行が件数を持つので二重に数えない）。

**語彙**: `vocab_master.PASSRATE_S2_REASON`（`not_announcement`）＋ `vocab_history.jsonl` に init。P は `PUBLISH_VERDICT_REASON` をそのまま使う（試験で同一を固定）。

**持ち帰り（棚卸し 1-3 の6件）**

| 記録 | 直し |
|---|---|
| `history/passrate/`（新） | nyuka-watch・update-data・official-x-intake が add |
| `publish_dropped.json` | nyuka-watch・update-data が add |
| `history/source_stats.jsonl`（まとめ収集の行） | nyuka-watch が add |
| `history/date_sanitize.jsonl` | nyuka-watch・update-data・resolve-dates・audit-dates（`verify_lotteries` を呼ぶ4本）が add |
| `history/deadline_updates.jsonl`・`history/channel_dedupe.jsonl` | nyuka-watch・update-data が add |
| `collection_watch_state.json` | **KV へ**（health-watch はコミットしないので、ファイルでは runner と一緒に消えて「週1」の生存確認が毎回送られていた）。KV が無い手元はファイルのまま |

**試験**: `test_passrate.py`（record / daily / check の 27 件）と `test_passrate_wiring.py`（記録を書く script を呼ぶ workflow が `history/passrate` を add しているか・持ち帰り6件・gitignore・`PASSRATE_LANE`）。`test_writers_lf` の書き手一覧に `passrate.py` を追加。`test_passrate` は `PARTS` と設計書 §0 の表を突き合わせる。

**設計書**: `docs/target-architecture.md` に §0「部品記号の一覧」を足し（既存の原則は §0-1 へ。§8-1 が既に §0-1 を参照していたので、これで参照が通る）、§10 を書き直した（§10-1 の表・記録の形・**棚卸しの実例2つ**・§10-2 の判定5つ・段の順番）。他の節は触っていない。

### 2. 確認したこと

- `python -m unittest test_passrate test_passrate_wiring test_writers_lf test_vocab_master` → 39 OK
- 直接触るモジュールの試験 20 本（`test_publish_verdicts` `test_publish_summary_only` `test_official_x_intake` `test_merge_intake_artifacts` `test_source_stats` `test_health_watch` `test_alert_incident` `test_data_push_retry` `test_line_endings` ほか）→ 387 tests。この PR に由来する赤なし。`test_dedupe_channel.実データ` が一括では赤・単独では緑（実行順に依る既存の型・この PR は触っていない）
- `pyflakes` → この PR 由来の指摘なし（`publish_reviewed_only.py:99` の未使用変数は既存）
- 手元 E2E ①: `python publish_reviewed_only.py`（数えるだけ）→ `history/passrate/local/2026-09-05/local-<pid>.jsonl` に

  ```json
  {"part": "P", "run": {"workflow": "local", "lane": "", "run_id": 0, "attempt": 0}, "kind": "snapshot",
   "in": 283, "out": 269, "dropped": 14, "held": 0,
   "reasons": {"date_conflict_unresolved": 11, "ai_not_run": 3},
   "extra": {"no_candidate_mapping": 8, "platform_owner_unregistered": 38, "applied": 0}, "ms": 19225}
  ```

  （手元の枝は 24ab5f77 時点の配布データ 283 行。CI のログ「511 → 287」とは時点が違う）
- 手元 E2E ②: `GITHUB_ACTIONS=true GITHUB_WORKFLOW_REF=…/official-x-intake.yml@… GITHUB_RUN_ID=0` で S2 を1行 → `history/passrate/2026-09-05/official-x-intake-0.jsonl` に入り、`python passrate.py` の表と `passrate.py check --report` が読めた（確認後に削除・コミットしていない）
- **Actions で持ち帰られること**は、この PR の中では確かめられない。マージ後の最初の nyuka-watch と official-x-intake の run で、コミットに `history/passrate/<日付>/` が含まれるのを見て確認する（下の「状態」）。

### 3. 影響

1 run あたり +1 秒未満（record 1 ms 未満・P は `判定表` を dry-run でも組む分だけ）。1 ファイル ≤ 7KB・1 日 ≤ 130KB。Actions の枠は増えない。

### 4. CI の赤の切り分け（docs/compare-with-main.md の型）

| 検査 | #1311 | #1312 | main（9899268c・run 33955330775） |
|---|---|---|---|
| python test | `test_lottery_overrides` 2件（控え 281≠282）＋`test_dedupe_channel.実データ` | 同じ顔ぶれ（7,353 tests） | 同じ顔ぶれ（7,322 tests） |
| vocab | — | 初回赤 → `tools/gen_vocab_js.py` で `vocab.gen.mjs` を作り直して緑 | — |
| web build | — | `candidate-view.test.mjs` 3件「`shadow_candidate_health.json` の rounds が台帳と合いません（1938 / 実際 1939）」 | main のデータそのもの。806508f0（ec-lottery-watch）が `shadow_candidates.json` を更新し health を更新していない。素の base で同じ試験を回しても同じ赤 |

**PR 由来の赤は 2 本ともなし。** web build の赤は nyuka-watch の full 段が health を作り直せば消えるが、nyuka-watch はいま `台帳が壊れている` で落ちている（ci へ渡した件）。

### 5. マージについて

`gh pr merge` はこのセッションの自動モードの許可で止められた。マージは本人の操作でお願いしたい（順番は #1311 → #1312。同じファイルは触っていない）。

**持ち帰りの確認はマージ後**: 最初の official-x-intake の run（Vercel 起動 JST 20:00 か cron 23:10）で `history/passrate/<日付>/official-x-intake-<run_id>.jsonl` がコミットに入るのを見る。nyuka-watch は `台帳が壊れている` が直るまで commit ステップに届かない（P の行は書かれるが持ち帰れない）ので、その修正の後に確認する。

### 6. 気づいたこと

- 期待表の「workflow ごと行が無い」は弱い合図にした。走っていないのか配線切れかは区別できず、走っていないほうは `check_workflows` が既に見ている。
- `check` の呼び出し先はまだ無い（段4で health-watch へ）。段1のいま鳴るのは手元の `python passrate.py check` だけ。

## 根拠データ

- [2026-09-05-passrate-inventory.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-passrate-inventory.json) — 棚卸し（設計報告と同じ）

## 状態

マージ待ち（#1311・#1312・PR 由来の赤なし）。マージ後の official-x-intake の run で持ち帰りを確認して追記する。nyuka-watch 側は ci の修正後。
