# T（通過率の計測）段3の実装: PR #1320（V5・S1・S3/V4・D1・N・N2）

セッション名: metrics
日付: 2026-09-05（JST）
区切り/依頼名: T の実装・段3（V5 を最初に）
対象: `origin/main` = 19bd8755 から切った枝 `feat/passrate-stage3`（head 4d89ce7a）。専用 worktree で作業し、共有の作業ツリーは触っていない。

## 受けた指示（原文）

> #1317 をマージしました。
>
> nyuka-watch の次の run で段2の行（L2・L・V7・V3・F・H1/H2）がコミットに入るのを
> 確認してください。確認できたら段3（V5 を最初に）へ進んでください。
>
> 段3の V5 は、roundup が画像の効果を測っているところなので、
> 項目ごとの確定数（apply_end / result_date / apply_start … の confirmed / missing / conflict）が
> 記録に入ると、roundup の「後」の測定が自動化されます。
> roundup の報告（2026-09-05-v5-extra-runs.md）にある数え方と揃えてください。

## 指示と過去の報告の食い違い

なし。段2の持ち帰りは nyuka-watch run 33962540752（コミット 491bf2e4）で確認した（段2の報告に追記済み）。

## 報告

### 0. 出した PR

[#1320](https://github.com/shinonomeheta-ai/cardbot/pull/1320) `feat/passrate-stage3`（head 4d89ce7a）— CI 待ち。

### 1. V5（応募ページ確認AI）— roundup の「後」の測定を自動化する

`candidate_ai_haiku_review` の collect 相の**前後**で数える。

- 前: `V5の前()` が、その batch の `round_ids` の前の答え（`shadow_candidate_ai.json` の results）と、画像の枚数（`images_for(対象を組み直す(行))`・保存済みのX投稿台帳から。通信なし）を控える。
- 後: `V5の集計()`（純関数）が `extra` を作る。数え方は roundup の [2026-09-05-v5-extra-runs](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-v5-extra-runs.md) §3 の表に揃えた。

| roundup の表の行 | 記録の `extra` |
|---|---|
| 前: 締切 missing | `before_end_missing`（前の答えで締切の check が missing / unreadable、または未判定で observed が無い） |
| 後: 締切 observed あり | `obs_end` |
| 後: 締切 confirmed | `apply_end:confirmed` |
| 後: 当選発表 observed あり | `obs_result` |
| 前が missing → 後に締切が入った | `end_filled_from_missing` |
| 画像あり／なしの分け | `with_image`・`with_image:before_end_missing`・`with_image:end_filled_from_missing` |
| `ai_note` に画像への言及 | `note_mentions_image` |
| 後: `ai_status` | `status:insufficient_evidence` / `status:likely_valid` / `status:conflict` … |
| 基準測定の5欄 | `apply_start / apply_end / result_date / store / product` × `confirmed / missing / conflict / unreadable / not_applicable`（`v5-baseline-before.json` の `checks` と同じ） |

行は in＝送った回・out＝ok・dropped＝error（`ai_error`）、`extra` に `batch_id`・`reserved_usd_micro`。Sonnet 直接の経路（`candidate_ai_sonnet_direct.run`）も同じ `V5の集計` で `V5/sonnet`（画像は 0）。

**これで「後」を測るときは、`passrate.py daily` の V5 の `extra` を日で合計すれば、roundup が手で集計した表と同じ数字が出る。** 母集団は「その日に collect した回」なので、全体の確定率（`v5-baseline-before` の `all`）を出すには結果台帳を数え直す必要がある（それは今までどおり）。

### 2. そのほかの部品

| 部品 | 呼ぶ場所 | in → out ／ dropped・held | reasons ／ extra |
|---|---|---|---|
| S1 | `ec_lottery_watch.main` | 読んだ記事 → 抽選と判定 ／ not_lottery | sources・links・with_end・applied |
| S1/ai_read | `page_ai_read.main` | 本文あり → 読めた ／ unreadable | rows・applied |
| S3 | `build_evidence_cache.main`（`数`） | 固有URL → 取れた ／ fetch_failed・unsafe・held＝使い回し等 | fetch_calls・reused_fetches・skipped_by_*・source_text_missing・stale_sources |
| V4 | 同上 | 応募回 → 抜粋あり ／ excerpt_missing | official / unofficial の抜粋・no_eligible・borrowed |
| V4/seed | `seed_official_source_texts.main` | 対象 → 本文を入れた ／ fetch_failed | todo |
| D1/<収集元> | まとめ収集2本の `_stats` | 取れた行 → 新しく合流 ／ held＝既知 | errors |
| D1/xweb | `discover_official_x_web.main` | 対象店 → 登録 ／ rejected・no_candidate | noted・blocked・targets・retry |
| D1/evidence | `register_x_from_evidence.main` | 候補店 → 登録 ／ multiple_handles・other_store・shared_handle・name_mismatch | applied |
| D1/registry | `store_registry.main` | 見えた店 → 新規 ／ held＝既知 | before・after・added・x_new・dormant・revived・new_stores・unverified_x |
| N | `official_x_intake.main` | 告知 → 店を決められた ／ unmapped | — |
| N2 | 同上（`official_accounts_by_key(dropped=…)`） | 公式X表の行 → 引ける鍵 ／ key_conflict | table_rows・handles_watched（§10-2 判定⑤の材料） |

### 3. 持ち帰り

- **`data_push.py --ai` の許可リストに前置き一致 `AI_ARTIFACT_PREFIXES = ("history/passrate/",)`** を足した。1 run 1 ファイルで名前が毎回違うので名前の一覧では書けない。配布データ・候補台帳は相変わらず通らない（試験）。
- candidate-ai-review: 段2で付けた `PASSRATE_DISABLE` を外し、根拠キャッシュのコミットと AI 成果物のコミットの両方で `history/passrate` を add（「書かない」と宣言した経路を、V5 を持ち帰るために「書いて押せる」経路へ）。
- ec-lottery-watch / ai-read / official-x-web-discovery も add。
- 期待表: candidate-ai-review→V5、ec-lottery-watch→S1、ai-read→S1/ai_read・V4/seed、official-x-web-discovery→D1/xweb、official-x-intake→S2・N・N2、update-data→D1/registry。まとめ収集の D1/<収集元> は `sources.json` で止められる経路なので期待しない（止めた経路を期待すると狼少年になる）。

### 4. 確認したこと

- `python -m unittest test_passrate test_passrate_stage2 test_passrate_stage3 test_passrate_wiring test_vocab_master test_writers_lf test_line_endings` → 63 OK。
- 段3の影響範囲 44 モジュール（1,333 tests）: 初回 `candidate_ai_sonnet_direct` で私の関数内 `import … as HR` がモジュール上部の `HR` を隠す UnboundLocalError 2件 → 局所 import を外して緑。ほか PR 由来の赤なし。
- 手元 E2E（`history/passrate/local/`）:

  ```
  D1/evidence  in=40   out=0    drop=40  reasons={multiple_handles:10, other_store:22, shared_handle:5, name_mismatch:3}
  D1/registry  in=808  out=44   held=764 extra={before:3312, after:3356, x_new:29, revived:33, new_stores:2518, unverified_x:490}
  S3           in=1642 out=1206 drop=114 held=322 reasons={fetch_failed:110, unsafe:4} extra={reused_fetches:2176, skipped_by_limit:386, stale_sources:135, …}
  V4           in=2095 out=1439 drop=656 reasons={excerpt_missing:656} extra={excerpt_ready_official_rounds:1129, unofficial:318, no_eligible:26, borrowed:18}
  ```

  触った根拠キャッシュ2ファイルは戻した。
- V5 は通信を伴うので手元では回さず、`V5の集計` を合成データで試験した（前 missing → 後に入った を画像あり／なしで分ける・5欄・行の形・許可リストの前置き）。
- **Actions で持ち帰られること**はマージ後に確認する: candidate-ai-daily の collect（JST 21:40）→ candidate-ai-review のコミットに V5、official-x-intake の次の run に N・N2、ec-lottery-watch（JST 7:40）に S1、ai-read（JST 8:10）に S1/ai_read・V4/seed。

### 5. 読むときの注意

- V5 の母集団は「その日に collect した回」。plan の並びが「前が missing の回を先頭に」（#1313）なので、`before_end_missing` の割合は全体より高く出る。全体の確定率は結果台帳を数える（`v5-baseline-before` の型）。
- D1/evidence の手元の 40 店が全部見送りなのは、2026-09-04 に登録できる分（8 店）を登録済みだから。残りは根拠の書き手が別の店・複数・使い回し・表示名不一致で、**登録しないのが正しい**回。

## 根拠データ

- [2026-09-05-passrate-inventory.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-passrate-inventory.json) — 棚卸し（設計報告と同じ）

## 状態

CI 待ち（#1320）。緑（PR 由来の赤なし）になったらマージは本人操作。マージ後の各 workflow の run で持ち帰りを確認して追記する。
