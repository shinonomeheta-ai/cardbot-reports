# T（通過率の計測）の棚卸し・設計・影響見積もり

セッション名: metrics
日付: 2026-09-05（JST）
区切り/依頼名: T（通過率の計測）の実装: 設計から（1〜3 の報告）
対象: `origin/main`（ファイルの値は 62efe3a4〜9899268c、GitHub API の値は 17:00〜17:40 JST。詳細は末尾「数字の時点」）。すべて `git show origin/main:` で読んだ。作業ツリーとコードは触っていない。

## 受けた指示（原文）

> ## 前提（新規セッション）
> 設計の正本は docs/target-architecture.md（部品記号つき・v14）です。作業前に読んでください。
> 特に §0（部品記号の一覧）と §10（通過率の計測）。
> 報告は cardbot-reports の reports/ に書き、INDEX に絶対URLで行を足してください。
> 根拠データは reports/data/ に JSON で添えてください。
> チャットには報告の raw URL を書いてください。
> このセッションは「metrics」と名乗ってください。
>
> # T（通過率の計測）の実装: 設計から
>
> ## 背景
> 2026-09-04〜05 の調査で、以下がいずれも数週間〜数ヶ月気づかれていなかった。
> - S2 が rebase の失敗を握り潰し、83%の実行で成果を捨てていた（捕捉率3.9%）
> - M1 の公式X表の66%が、鍵の形の不一致で構造的に引けなかった
> - V5 が画像を読まないため、締切の66%が「書かれていない」と判定されていた
> - event_id 台帳の作り直しが24時間止まっていた
> - N の欠落で店名でないものが店名として台帳に入り、汚染が蓄積した
>
> いずれも「動いているように見えて壊れていた」。部品ごとの通過率を見ていれば
> 翌日に気づけたものです。
>
> ## やること（この順で）
>
> ### 1. 現状の計測の棚卸し
> 既に記録されているもの（source_stats.jsonl・build_evidence_cache.health()・
> shadow_candidate_ai_health.json・publish_dropped.json / publish_verdicts.json 等）を
> 部品記号（S1〜P・H）に対応づけて一覧にする。
>
> 各部品について:
> - いま何が記録されているか（件数・理由・時系列の有無）
> - 記録されていないもの
> - 記録はあるが履歴が無い（スナップショットのみ）もの
>
> ### 2. 設計
> 設計書 §10-1（記録する最低限）を満たす形を設計する。
>
> - 記録先: 1か所に集約するか、既存の記録を使い回すか
> - 形式: 部品記号・日時・入力件数・出力件数・落ちた件数・落ちた理由の内訳
> - タイミング: 巡回のどこで記録するか（各部品の出口）
> - 履歴: 日ごとに残す。前日比が取れる形
> - 異常の判定（§10-2）: 通過率0・前日比の急変・保留の増加を検知して Discord へ
>
> ### 3. 影響の見積もり
> - 記録を足すことで巡回の所要がどれだけ増えるか
> - 記録ファイルのサイズの増え方（1MB超で事故があった履歴があるので注意）
>
> 実装は設計を見てから指示します。1〜3 の報告を出してください。
>
> ## 注意
> - D:\cardbot の作業ツリーは使わず git show origin/main: で読む
> - 共有 worktree で git add -A を使わない
> - 他セッション（store-name-a・ci・x-intake・roundup）が触っているファイルは変更しない
> - 設計段階なので、コードは変更しない

## 指示と過去の報告の食い違い

1. **「docs/target-architecture.md（部品記号つき・v14）」は origin/main に無い。** リポジトリの `docs/target-architecture.md` は v12 相当で、§0 は「設計の原則」、§10 に §10-1/§10-2 の小節は無く、部品記号（S1〜Y）も出てこない。記号つきの v14 は本人の Downloads にある『収集機構 部品設計書』（`収集機構_部品設計書.md`・図 `torecanavi_collection_parts_v14.png`）だけ。本報告はその v14 を読んで書いた。**T を実装するとき記録の語彙（部品記号）はリポジトリ内の文書を正本にしなければならない**（U: 語彙の正本を1か所に）ので、v14 の §0 と §10 をリポジトリの設計書へ入れる作業が実装の前に要る。
2. 背景の数字は、確認できた範囲で過去の報告と一致する。「83%」＝12 run 中 10 run が成果を捨てた（#1268 の報告）。「66%」＝公式X表 1,347 行中 882 行。「締切の66%」＝V5 の基準測定（`2026-09-05-v5-baseline-before.json`）で apply_end の missing が 768/1169＝66%。「event_id 台帳 24 時間停止」と「N の汚染」は該当報告を今回は読み直していない。

## 報告

### 0. 結論を先に

- **記録は散らばっているが、§10-1 の形（入力→出力→落ちた数→理由）で残っている部品は1つも無い。** いちばん近いのは P の実行ログ「配布 511 行 → 配る 287 行 ／ 落とす 224（理由の内訳）」だが、ログにしか無い。
- **時系列があるのは S2 と旧まとめ収集の `history/source_stats.jsonl` だけ**（158 行・8/7〜）。それ以外は全部「上書きのスナップショット」で、前日比が取れない。
- **書いているのに持ち帰っていない記録が 6 つある**（下の 1-3）。`publish_dropped.json` はどの workflow も git add していないので 09-02 の 1 行のまま。まとめ収集の source_stats 行は nyuka-watch が git add しないので 08-30 で途絶している。**記録を足すだけでは足りず、「持ち帰る」まで同じ PR で通す必要がある**（`field-only-no-wiring` と同じ型）。
- 既存の見張り `check_collection.py` は、**08-31 に止めた4ソースを毎回「取れていません」と鳴らしている**（health-watch 1日2回・run 33947840699 で実測）。見張りの語彙が部品と合っていない状態で、狼少年になっている。T はこれを置き換える形にする。
- 設計は「**1つの記録関数・1つの置き場・1 run 1 ファイル**」。追加コストは 1 run あたり 1 秒未満・120KB/日で、1MB を超えるファイルは作らない（§3）。

### 1. 現状の計測の棚卸し

部品記号は v14 §0。「履歴」は「前日比が取れる形で残っているか」。

| 部品 | 実装（origin/main） | いま記録されているもの | 履歴 | 記録されていないもの（§10-1 に対して） |
|---|---|---|---|---|
| **S1** 店の公式サイト巡回 | `official_page_intake.py`（ページ単位の読み取り）と `ec_lottery_watch.py`（登録 42 社の一覧・3回/日） | `ec_lottery_watch_state.json`（見た記事URLの控え・件数なし）。ログ「候補台帳へ N 行（新規 M）」「読めた N/M」「本文を入れた N/M」 | なし | 訪問数・取得件数・告知判定数・保存失敗数のすべて。**M1 の `store_sites.json`（131 店）を巡回する部品は無い**（一覧巡回は EC 42 社だけ） |
| **S2** 公式X取り込み | `official_x_intake.py`・`merge_intake_artifacts.py`（再適用） | `official_x_intake_health.json`（accounts 232 / opened 30 / posts / announcements / new_candidates / misses / stopped_early・上書き）。`history/source_stats.jsonl` source=official_x（fetched=開いた数・new=新規候補・errors=速度制限・detail{posts, announcements}・17 行/8 日） | **あり**（source_stats のみ） | **保存に失敗した件数**（rebase 競合→再適用の回数はログのみ）。告知判定の落ち理由の内訳（not_a_lottery 等） |
| **S2b** 公式サイトの過去分巡回 | 未実装 | なし | なし | 全部 |
| **S3** 公式EC・応募ページ収集 | `build_evidence_cache.py`・`seed_official_source_texts.py`・`resolve_urls.py`（展開） | `shadow_candidate_evidence_cache_health.json`（total_unique_sources 1,250 / fetched / failed 113 / stale 73 / fresh 1,031 / reused / skipped_by_limit 223 / source_text_missing 12 / unsafe 4・上書き） | なし | 理由別の失敗内訳（HTTP/描画/403 の別）。V4 と同じ器で数えていて S3 と V4 が分かれていない |
| **S4** 外部フィード | `build_lotteries_nyuka.py` | `history/source_stats.jsonl`（fetched/new/errors） | あり（08-30 まで） | 08-31 に `COLLECT_AGGREGATORS` OFF。以後の記録は無いのが正しいが、見張りは「取れていません」と鳴らし続けている |
| **D1** まとめからの発見 | まとめ収集2本（roundup 段）・`discover_official_x_web.py`（8回/日）・`register_x_from_evidence.py`・`discover_store_hosts.py`・`discover_store_aliases.py`・`store_registry.py` | `history/source_stats.jsonl`（まとめ2系統の fetched/new・**08-30 で途絶**）。`official_x_web_state.json`（状態）。`store_registry.json` の `notified`（新着店・未確認X）。`source_apply_candidates.json`（発見台帳・件数なし）。ログ「対象/この回/登録」「見送り：ハンドルが複数 N 店」「積んだ N 件」 | 途絶 | **記事数 → 発見した店/公式X/URL → M1 へ登録** の連鎖。現状は末端の「登録した数」がログにあるだけ |
| **M1〜M5** マスタ | `store_x_accounts.json` 1,387 行・`store_sites.json` 131・`store_platforms.json` 61 店・`golden_chains.json` 52・`store_aliases.json` canonical 36（806508f0 では 39）＋learned 1・`source_names.json` hosts 7・`ec_lottery_sources.json` 42 | 表そのもの（行数は数えれば出る） | git 履歴のみ | 表の行数の時系列（N2 の「表に登録があるのに引けない」を見るには要る） |
| **N** 名前の正規化 | `store_canon.canonical_store`（L の手前で呼ぶ側が使う） | なし。`dropped_concat_names.json` は 09-04 の掃除 1 回分の記録 | なし | 入力の種類数・正規名に寄った数・未知語の数 |
| **N2** 引きの鍵（索引） | `store_x_match.official_handle_map`（09-04 cdcea71a で1本化・衝突は落とす） | なし | なし | 表の行数・引けた数・衝突で落とした数 |
| **L** 候補台帳 | `build_candidates_shadow.py`・`candidate_ledger` | `shadow_candidate_health.json`（input_rows 365 / candidates 1,736 / rounds 1,938 / active 928 / provisional 470 / conflicts 59 / skipped 87 / by_medium / by_authority / by_apply_url / apply_url_reasons 19 語 / x_hop・上書き・nyuka-watch が持ち帰る） | なし | **新規・既存への統合**の内訳（総数だけ） |
| **L2** 同一性の鍵と発番 | `lottery_io.素性を引き継ぐ`・`lottery_round_registry.json`（1,428・追記専用）・`event_id_registry.json`（2,483・redirects 191・blocked 2） | 台帳そのもの | 台帳のみ | 新規発番数・既存へ寄せた数・曖昧で寄せなかった数・**拒否（`台帳が壊れている`）の回数**。今日 05:58Z から nyuka-watch がこの例外で 5 回連続失敗中（run 33954377139）。数えていれば「拒否 1→5」で見える型 |
| **V1** 公式根拠の取得 | `candidate_ai_cache` / `build_evidence_cache` | 同 health の excerpt_ready_official_rounds 905 / unofficial 301 / excerpt_missing 427 / no_eligible 20（上書き） | なし | 対象数→公式根拠が付いた数→**H1 へ回った数**（保留へ回った数はどこにも無い） |
| **V2** URL展開・正規化 | `resolve_urls.py`（fast/full 段で 77〜458 秒） | `url_resolve_state.json`（当日 1 回分の counts{ok, source, unverified, dead, none}・上書き）。ログ「ok N 件（%）・解決できていない内訳」 | なし（当日分のみ） | 理由別の失敗数の時系列 |
| **V3** 品質検査 | `verify_lotteries.py`・`collapse_open_duplicates.py`・`mark_similar_rounds.py`・`shadow_url_owner.py`・`finalize_official_urls.py` | `lottery_conflicts.json`（食い違い一覧）・`similar_round_suspects.json`（62 組）・`shadow_url_owner.json`（counts{match, foreign, unknown} / by_route / reasons・持ち主不一致はここ）・`history/date_sanitize.jsonl`（**未追跡・消える**）。ログ「日付補正/締切2ソース一致/矛盾解消」「ok N（直した/落ちた）」 | なし | 通過数・落ちた数（理由別）の時系列。持ち主不一致は数があるが上書き |
| **V4** 応募ページの本文取得 | `build_evidence_cache.py`・`seed_official_source_texts.py`（ai-read・535 秒） | S3 と同じ health（fetched_sources / failed_sources） | なし | 理由別の失敗。S3 と分けて数える |
| **V5** 応募ページ確認AI | `candidate_ai_haiku_review.py`（candidate-ai-daily/review） | `shadow_candidate_ai_health.json`（checked 1,166 / error 18 / pending 772 / stale 1,164 / fresh 2 / 費用 / batches 87・上書き・141KB）。`shadow_candidate_ai.json` の各回に checks{項目: confirmed/missing/conflict/unreadable}（1,169 件）。`shadow_candidate_ai_sonnet_runs.jsonl`（11 行・ok/error/費用）。`candidate_ai_receipts.jsonl`（87）。`xai_call_log.jsonl`（2,135・1.4MB）。`sonnet_read_log.jsonl`（547・1.5MB） | run 単位の費用はあり。**項目別の確定数は無し** | **送信数→項目ごとの確定数→食い違い数**の時系列。別セッションが手で集計した `2026-09-05-v5-baseline-before.json` がその形で、機械は毎回これを出していない |
| **V6** 店頭のみの例外 | `fill_round_methods.py`・`official_x_intake` の店頭判定 | ログ「埋まる数 {…}」 | なし | 店頭のみと判定した数 |
| **V7** 刻印 | `round_links.py`・`shadow_round_links.json`（192） | 対応表そのもの。`食い違う刻印()` は**試験からしか呼ばれない** | なし | 刻印数・身元と食い違った数・上書きした数 |
| **F** 既定値 | `publish_reviewed_only.py`・`fill_receive_method.py` | ログ「既定値（開始日＝告知日／都道府県＝全国）: {'prefecture': 16, 'apply_start': 13}」「受け取りの空欄を埋めた {…}」 | なし | 項目ごとの件数の時系列（ログには毎回出ている） |
| **P** 配信の関門 | `publish_reviewed_only.py`（17〜19 秒） | `publish_verdicts.json`（354 回: kept_human 253 / kept_ai 70 / dropped 31・reason 語彙 rejected / date_conflict_unresolved / not_reviewed_ec / ai_not_run / no_official_evidence・platform_owner_unregistered 40・no_candidate_mapping 202・上書き・nyuka-watch が持ち帰る）。`publish_dropped.json`（**git add されず 09-02 の 1 行のまま**）。ログ「配布 511 行 → 配る 287 行 ／ 落とす 224（{'not_reviewed_ec': 31, 'ai_not_run': 159, 'date_conflict_unresolved': 21, …}）」 | なし | 対象数→配信数→落ちた数（条件別）の時系列。**ログの1行が §10-1 の形そのもので、これを残していないのが現状** |
| **H1 / H2** 保留と解消 | 人の台帳 `shadow_candidate_ai_human.json`（reviews 1,208: pending_review 766 / corrected_ok 321 / rejected 121）・AI health の pending_rounds 772・`publish_verdicts` の dropped 31・`lottery_publish_queue.json`（旧ゲート・500 件で頭打ち） | 保留の数は 4 つの器に散在 | なし | **保留の総数（1 本の数）・解消数・打ち切り数**。解消も打ち切りもどこにも数えていない |
| **T** 見張り（既存） | `check_collection.py`・`check_workflows.py`・`check_health.py`・`check_delivery.py`・`alert_incident.py` | 「走ったか」「新しいか」「連続失敗か」は見ている | — | 「部品を通過した数」は S2 の source_stats 以外見ていない。`collection_watch_state.json` が**未追跡**で、生存確認が週 1 でなく毎回送られている |
| **U** 語彙 | `vocab_history.jsonl`（17 行） | 語彙の変更履歴 | あり | — |

#### 1-2. 「記録はあるが履歴が無い（スナップショットのみ）」の一覧

上書き型で前日比が取れないもの: `official_x_intake_health.json`・`shadow_candidate_health.json`・`shadow_candidate_evidence_cache_health.json`・`shadow_candidate_ai_health.json`・`shadow_official_x_health.json`・`url_resolve_state.json`・`date_resolve_state.json`（08-13 で止まっている）・`shadow_url_owner.json`・`publish_verdicts.json`・`publish_dropped.json`・`similar_round_suspects.json`・`lottery_conflicts.json`。git の履歴を掘れば前日の値は取れるが、見張りが読める形ではない。

#### 1-3. 「書いているのに持ち帰っていない」記録（実装のとき同じ PR で直すもの）

| ファイル | 書く側 | 状態 |
|---|---|---|
| `history/source_stats.jsonl`（まとめ2系統の行） | nyuka-watch の roundup/full 段 | nyuka-watch が git add しない → その段の行は消える（最終行 08-30。update-data と official-x-intake だけが持ち帰る） |
| `publish_dropped.json` | `publish_reviewed_only.py` | どの workflow も git add していない。ログは 224 行落としているのにファイルは 09-02 の 1 行 |
| `history/date_sanitize.jsonl` | `verify_lotteries.py` | 未追跡 |
| `history/deadline_updates.jsonl` | `deadline_update.py` | 未追跡 |
| `history/channel_dedupe.jsonl` | `dedupe_channel.py` | 未追跡 |
| `collection_watch_state.json` | `check_collection.py` | 未追跡 → 生存確認の間隔（7 日）が効かず毎回送る |

### 2. 設計

#### 2-1. 方針（3つ）

1. **記録関数は 1 本、置き場は 1 か所。** 既存の `source_stats.py` は「ソース別に取れた数」の器で、部品の入出力を持たない。使い回さず、`passrate.py`（仮名）を新設して、既存の health/state ファイルはそのまま残す（読む側が多く、消すと別の物が壊れる）。`source_stats.record` の呼び出し 6 か所は、S2/S4/D1 の記録として `passrate.record` へ寄せ、`source_stats` は互換のため残すが見張りからは外す（2-5）。
2. **部品の出口で、その部品がもう持っている数を書くだけ。** 台帳を読み直して数え直さない（読み直す設計は所要とサイズを増やし、しかも「判定を写す」ことになって U に反する）。P の「配布 511 → 287 ／ 224 の内訳」のように、いま print している数をそのまま記録へ流す。
3. **1 run 1 ファイル。** `history/passrate/YYYY-MM-DD/<workflow>-<run_id>.jsonl`。追記専用の 1 本にすると、別の並列グループ（official-x-intake・ec-lottery-watch・ai-read・candidate-ai は nyuka-watch と別の concurrency group）が同じファイルへ追記して rebase 競合になり、`-X theirs` でどちらかの行が消える（source_stats.jsonl が今そうなり得る形）。ファイルを run で分ければ競合が起きない。1 ファイル ≤ 7KB、1 日分のディレクトリ ≤ 130KB で、1MB を超える器は作らない。

#### 2-2. 形式（1 行＝1 部品 × 1 run）

```json
{"at": "2026-09-05T14:02:37+09:00",
 "part": "P",
 "run": {"workflow": "nyuka-watch", "lane": "fast", "run_id": 33947227726, "attempt": 1},
 "kind": "snapshot",
 "in": 511, "out": 287, "dropped": 224, "held": 0,
 "reasons": {"not_reviewed_ec": 31, "ai_not_run": 159, "date_conflict_unresolved": 21, "rejected": 12, "no_official_evidence": 1},
 "extra": {"no_candidate_mapping": 200, "platform_owner_unregistered": 40},
 "ms": 18400}
```

- `part`: v14 §0 の記号そのまま（S1 / S2 / S2b / S3 / S4 / D1 / N / N2 / L / L2 / V1 / V2 / V3 / V4 / V5 / V6 / V7 / F / P / H1 / H2）。M は N2 の行の `extra.table_rows` として持つ（表の行数）。
- `in / out / dropped / held`: `in == out + dropped + held` を記録側で検査し、合わなければ `extra.mismatch=true` を付けて**それでも書く**（記録のために巡回を落とさない。`source_stats.record` と同じ流儀）。
- `reasons`: 落ちた理由の内訳。**語彙は M5（`vocab_master`）に部品ごとに登録し、未登録の語は試験で落とす**（3 点セット: 定義・書く側・読む側）。P は既存の `publish_verdicts` の reason 語彙をそのまま使う。
- `kind`: `flow`（その run で処理した数。日次は合計）か `snapshot`（台帳全体に対する数。日次は最後の run の値）。部品ごとに固定表で持つ。flow＝S1〜S4・D1・V2・V4・V5・L2・F、snapshot＝N・N2・L・V1・V3・V7・P・H1・H2。
- `extra`: 部品固有の数（§10-1 の「項目ごとの確定数」「持ち主不一致」「表の行数」など）。
- `ms`: その部品の所要。所要の急変も異常の合図になる。

#### 2-3. タイミング（各部品の出口・呼ぶ場所）

| 部品 | 呼ぶ場所（既存の関数の末尾） | in → out → dropped/held | reasons / extra |
|---|---|---|---|
| S1 | `ec_lottery_watch.main`・`official_page_intake` の呼び手（`page_ai_read`・`seed_official_source_texts`） | 訪問 → 取得 → 告知と判定 → 保存 | not_lottery / fetch_failed / render_failed / **save_failed** |
| S2 | `official_x_intake.main`（`r` の dict をそのまま）＋ `merge_intake_artifacts.main`（再適用は `extra.replayed=1`・最初の push 失敗を `save_failed` に数える） | accounts → opened → posts → announcements → new_candidates | rate_limited / not_lottery / no_store / save_failed |
| S2b | 未実装。実装されるまで行は出ない。**期待表（2-4）に載せないので「記録なし」の異常にもならない** | — | — |
| S3 / V4 | `build_evidence_cache.main`（`数` dict）・`seed_official_source_texts` | unique_sources → fetched → failed | http_error / render_failed / unsafe / skipped_by_limit（S3 は URL 単位、V4 は応募回単位で 2 行） |
| S4 | `build_lotteries_nyuka`（OFF の間は行が出ない） | fetched → new | fetch_error |
| D1 | まとめ収集 2 本（記事数 → 抽選行 → **新しい店/URL の発見数**）・`discover_official_x_web.main`（対象 → 候補 → 登録）・`register_x_from_evidence.main`（対象 → 登録 / 見送り：複数・使い回し）・`store_registry.main`（新着店・未確認X） | 記事 → 発見 → M1 登録 | ambiguous_handle / shared_handle / no_candidate |
| N | `build_candidates_shadow`（L の手前で `canonical_store` を通した結果）と `official_x_intake`（店判定） | 入力の種類数 → 正規名に寄った数 → 未知語 | unknown / not_a_store（応募方法・受取場所が店名欄に入った数） |
| N2 | `store_x_match.official_handle_map` の呼び手（`official_announce`・`official_x_intake`）。表を作ったときに `extra.table_rows`・衝突数を返す | 引いた数 → 当たった数 → 衝突で落とした数 | key_conflict / not_found |
| L | `build_candidates_shadow.main`（`数` dict） | input_rows → candidates（**新規 / 既存へ統合** を分ける）→ skipped | skipped の理由（現状 `skipped` 87 の内訳をここで分ける） |
| L2 | `lottery_io.save`（`素性を引き継ぐ` の結果を戻り値で返し、呼び手 `publish_reviewed_only` / `materialize_official_lotteries` が記録） | 行数 → 既存 ID 再利用 / 新規発番 / 曖昧→新規 → **拒否（`台帳が壊れている`）** | reused / issued / ambiguous_new / **registry_refusal** |
| V1 | `build_evidence_cache`（health の excerpt_ready_official / unofficial / missing から） | 対象回 → 公式根拠あり → held（公式根拠なし＝H1） | no_official_evidence / summary_only |
| V2 | `resolve_urls.main`（`stat` dict） | 対象 → ok → 失敗 | dead / unverified / source / none / expand_failed |
| V3 | `verify_lotteries.main`（日付）・`collapse_open_duplicates`（重複）・`shadow_url_owner`（持ち主。`extra.owner_mismatch`＝counts.foreign）・`finalize_official_urls` | 行数 → 通過 → 落ちた／held | date_order / result_before_end / owner_foreign / owner_unknown / duplicate_folded |
| V5 | `candidate_ai_haiku_review` の collect 相（そのバッチで判定した回の `checks` を集計） | 送信 → 判定できた → error | `extra.fields={apply_end:{confirmed,missing,conflict,unreadable}, …}`・`extra.conflicts`・`extra.usd` |
| V6 | `fill_round_methods.main` | 対象 → 店頭のみと判定 | — |
| V7 | `publish_reviewed_only` / `promote_candidate_decisions` が `round_links` を書いた直後に `食い違う刻印()` を**本番でも呼んで**数える | 刻印数 → 一致 → 食い違い | store_mismatch / branch_mismatch・`extra.overwritten` |
| F | `publish_reviewed_only`（いま print している dict）・`fill_receive_method` | 対象 → 埋めた | `extra.filled={prefecture:16, apply_start:13, receive_method:…}` |
| P | `publish_reviewed_only.main`（「配布 → 配る ／ 落とす（内訳）」の行） | 配布行 → 配る → 落とす | 既存の verdict 語彙 5 つ＋`extra.no_candidate_mapping`・`extra.platform_owner_unregistered` |
| H1 / H2 | P の直後。**前回の `publish_verdicts.json`（87KB）と今回を突き合わせる**: dropped の総数＝H1、前回 dropped → 今回 kept＝解消、dropped のまま締切超過＝打ち切り候補。人の台帳の pending_review も `extra.pending_review` に足す | 保留総数 → 解消 → 打ち切り | resolved_by_evidence / resolved_by_human / expired |

`run.lane` は nyuka-watch の `Decide lane` ステップが決めているので、そこで `PASSRATE_LANE` を env に出して記録側が読む。`run.workflow` / `run_id` / `attempt` は `GITHUB_WORKFLOW` / `GITHUB_RUN_ID` / `GITHUB_RUN_ATTEMPT` から取る。手元実行は `workflow="local"` で書き、`GITHUB_ACTIONS` が無いときは `history/passrate/local/` へ書いて git には載せない（`tests-must-not-touch-real-data` と同じ自衛）。

**持ち帰り（同じ PR で必ず通すもの）**: 記録を書く script を呼ぶ全 workflow の commit ステップに `history/passrate/` を足す。対象は nyuka-watch・update-data・official-x-intake（＋再適用）・ec-lottery-watch・ai-read・official-x-web-discovery・candidate-ai-review/daily（`data_push.py --ai` の `AI_ARTIFACTS` 許可リストにも足す。足さないと fail-closed で押せない）・promote-now・resolve-urls・resolve-dates・audit-dates。**workflow が記録 script を呼んでいるのに `history/passrate/` を add していなければ落ちる試験**（`test_passrate_wiring.py`。`test_data_push_retry` が action.yml と突き合わせるのと同じ型）を置く。あわせて 1-3 の 6 件（`publish_dropped.json` など）も同じ PR で add する。

#### 2-4. 履歴と日次集計

- 生の行は `history/passrate/<日付>/<workflow>-<run_id>.jsonl`（LF 固定・`newline="\n"`・`test_writers_lf.py` の書き手一覧へ追加）。
- `passrate.py daily --days N` が直近 N 日のディレクトリを読んで **日 × 部品** の表を作る。flow は合計、snapshot はその日の最後の run の値。行が 1 つも無い日は空欄として出す（`source_stats.daily` と同じ。「走らなかった日」と「0 件の日」を区別する）。
- 管理画面用に `web/public/data/passrate.json`（14 日分の日次表・約 50KB）を update-data と nyuka-watch の full 段で書く。生の行は配らない。
- **期待表**: 「この workflow のこの段では、この部品の行が出るはず」を `passrate.py` の中に 1 つ持つ（nyuka-watch fast＝V2・V3・L2・V7・F・P・H1/H2、full＝＋D1・N・L・V1・V6、official-x-intake＝S2・N・N2・L、ec-lottery-watch＝S1・L、ai-read＝S1・S3/V4、candidate-ai＝V5、official-x-web-discovery＝D1）。走ったのに行が無い＝**配線の欠落**を異常として捕まえるため。

#### 2-5. 異常の判定（§10-2）と Discord

`passrate.py check` を health-watch（JST 10:10 / 22:10・巡回と別の基盤）から呼ぶ。判定は 5 つ。

| # | 判定 | 条件（初期値・緩め） | 出し方 |
|---|---|---|---|
| 1 | 通過率 0 | 直近 24 時間、その部品の全 run で `in ≥ 10` かつ `out = 0` | 鳴らす |
| 2 | 記録なし | 期待表にある部品の行が、その workflow が走った日に 1 つも無い | 鳴らす（配線切れ） |
| 3 | 前日比の急変 | 通過率（out/in）が前日比 ±30 ポイント、または `in` が 1/3 以下・3 倍以上。`in < 20` の日は判定しない | `in ≥ 50` なら鳴らす、未満は弱い合図として本文に添える |
| 4 | 保留の増加 | H1 の総数が 3 日連続で増え、3 日前比 +20% 以上 | 鳴らす |
| 5 | 引けない表 | N2 の `table_rows` が 7 日で +10 以上なのに当たった数が増えていない | 弱い合図 |

- 通知は `alert_incident`（KV・障害単位に 1 回）へ乗せる。指紋は `passrate:<部品>:<判定#>`。同じ部品の同じ異常が続く間は数えるだけ、直ったら「復旧」を 1 回。
- 生存確認は週 1 で、状態は KV に置く（`collection_watch_state.json` が未追跡で効いていない件の再発を避ける）。
- `check_collection.py` の見張りは T に置き換える。少なくとも `KNOWN_SOURCES` から 08-31 に止めた 4 ソースを外す（いまは毎回鳴っている）。

#### 2-6. 実装の順番（提案）

1. `passrate.py`（record / daily / check / --write）＋ vocab 登録＋ `test_passrate_wiring.py` ＋ 1-3 の持ち帰り 6 件。**部品は P と S2 の 2 つだけ**先に通す（P はログの 1 行を流すだけ、S2 は health の dict を流すだけで、どちらも数え直しが無い）。
2. L・L2・V7・V3・F・H1/H2（nyuka-watch の中で完結する部品）。L2 の `registry_refusal` は今日の事故の型なので早めに。
3. S1・S3/V4・V5・D1・N・N2（別 workflow の部品）。
4. `check` を health-watch へ配線し、`check_collection` を外す。

#### 2-7. 設計上の判断と、判断していただきたいこと

- **既存の health/state ファイルは消さない**（読む側が多い）。T は「横に足す」。
- **KV でなく git** に置く。理由は「履歴を後から読める」「手元で再現できる」「KV 障害と独立」。KV は alert の状態だけ。
- **1MB の事故**は「GitHub Contents API で全体を読む台帳」で起きた。T の生の行は Python が checkout から読み、配る要約は 50KB なので同じ道を通らない。
- 判断していただきたいこと（2 つ）:
  1. **v14 の §0 / §10 をリポジトリの `docs/target-architecture.md` へ入れる**のを T の実装 PR に含めてよいか（記号の正本がリポジトリに無いまま記号で記録を書くと U に反する）。別セッションが設計書を触っていれば、そちらに寄せる。
  2. `check_collection.py` の見張りを T で**置き換える**（外す）か、並走させるか。推奨は置き換え（いま毎回鳴っている狼少年を止めるため）。

### 3. 影響の見積もり

#### 3-1. 所要（巡回が増える時間）

実測（origin/main の直近 run・ジョブ API の step 所要）: nyuka-watch fast＝239 秒（うち Resolve apply URLs 77 秒・Publish reviewed only 18 秒・データ契約 3 回 41 秒）、full＝784 秒（Resolve 458 秒・スクショ 150 秒）、official-x-intake＝2,094 秒、ec-lottery-watch＝654 秒、update-data＝525 秒、ai-read＝939 秒、web-discovery＝1,558 秒。

足す処理の所要（手元で測定）:

| 処理 | 所要 |
|---|---|
| `record` 1 回（1 行 298 バイトの追記） | 0.6 ms |
| 1 run の記録（最大 25 部品） | < 20 ms |
| H2 の前回 `publish_verdicts.json`（87KB）読み比べ | 数 ms |
| V7 の `食い違う刻印()`（192 件） | 数 ms |
| `daily`（30 日＝11,700 行＝3.4MB を読む） | 71 ms |
| `check`（daily の上に判定） | < 100 ms |
| `git add history/passrate/`（1 ファイル ≤ 7KB） | 誤差 |

**1 run あたりの増加は 1 秒未満（fast 段 239 秒の 0.4% 未満）。** 台帳を読み直す設計にしないのが条件。Actions の枠は増えない（既存の workflow に相乗りし、専用の定期実行を作らない）。

#### 3-2. サイズ

- 1 行＝298 バイト（上の例の JSON）。
- 行数/日: nyuka-watch fast 約 41 run × 8 部品 ＝ 328、full 3 run × 22 部品 ＝ 66、他の workflow 合計 約 15 → **約 410 行/日 ≒ 120KB/日、3.6MB/月、44MB/年**（作業ツリー上の合計）。
- 1 ファイル（1 run）は最大 25 行 ≒ 7KB。1 日のディレクトリは ≒ 130KB。**1MB に近づく器は無い。** 月まとめの 1 本にすると 3.4MB/月で 1MB を超えるので、それは作らない（作るなら 90 日過ぎの圧縮として別途）。
- 管理画面へ配る要約 `passrate.json` は 14 日 × 25 部品 ≒ 50KB。
- git の履歴: 1 日 41 コミットに 7KB ずつ足す。比較として nyuka-watch は毎 run `shadow_candidates.json`（3.9MB）と `shadow_current_events.json`（760KB）の差分を積んでおり、T の増分はその 0.3% 未満。コミット回数は増えない（09-04 は成功 30 run に対しコミット 30。成功した run は既に毎回コミットしている）。
- 半年で 22MB を超えたら `history/passrate/YYYY-MM.tar` 等に畳む。判断は半年後でよい。

#### 3-3. 副作用の見積もり

- nyuka-watch の「新規なし（コミットしない）」の回は、T の行が毎回新しいので必ずコミットになる。実測では成功した run は既に毎回コミットしているので実質の差は無い。
- 記録の失敗で巡回を止めない（`source_stats.record` と同じく例外は握って続行し、標準エラーに 1 行）。
- 収集元の名前は行に入れない（`part` と語彙だけ）。要約 JSON も同様なので、収集元名の漏洩検査に当たらない。

### 4. 付記（作業中に観測した現行の事故・触っていない）

1. **nyuka-watch が 09-05 05:58Z から 5 回連続で失敗中**（run 33954377139 ほか）。落ちる場所は Publish reviewed only の `lottery_io.台帳が壊れている: 素性の鍵が別の案件を指しています: 鍵=北国書林辰口店cardbox|dragonball|…`。別名整備（store-name-a）の後に出ているように見える。L2 の「拒否回数」を数えていれば 1 回目で見える型。
2. **health-watch が毎回、止めた 4 ソースについて「情報が取れていません」を Discord へ送っている**（run 33947840699）。`check_collection.py` の `KNOWN_SOURCES` が 08-31 の収集 OFF に追従していない。同じ run で「生存確認を送りました」も毎回出ている（状態ファイル未追跡）。

## 数字の時点（2026-09-05 夜・追記）

ci と roundup が手動で巡回を回している（nyuka-watch・candidate-ai-daily）との補足を受けて、どの数字がいつの値かを明記する。

- **ファイルから取った値**（棚卸しの件数・health の中身・マスタの行数・台帳の件数）: `git show origin/main:` で読んだ。読んでいる間に origin/main が 62efe3a4（16:53 JST 取得）→ 9d1befbd（17:00）→ 9899268c（17:20）と動いたが、この 3 つの間で変わったのは alias 関係のコードと試験・`docs/target-architecture.md`（§11-1-1 の追加）だけで、**本報告が数字を引いたデータファイルは 3 つの時点で同一**（`publish_verdicts.json`・`shadow_candidate_health.json`・`shadow_candidate_ai*.json`・`official_x_intake_health.json`・`history/source_stats.jsonl`・`shadow_url_owner.json`・台帳・マスタ各表を突き合わせて確認）。各ファイルの `updated` はそのファイルの中の値（例: `publish_verdicts.json` 14:29:07 JST・`shadow_candidate_ai.json` 16:51:58 JST）で、根拠 JSON に写してある。
- 追記時点の origin/main は 806508f0（17:39 JST・ec-lottery-watch の更新）。62efe3a4 との差は `shadow_candidates.json`・`linked_page_cache.json`・`ec_lottery_sources.json`・`ec_lottery_watch_state.json`・`store_aliases.json`（canonical 36→39）。本文の数字は 62efe3a4 時点のまま（訂正は alias の行数だけ。初版は top-level の鍵数 4 を書いていたので canonical 36 に直した）。部品記号が設計書に無い件は 806508f0 でも変わらない。
- **GitHub API から取った値**（run の一覧と step 所要・1 日の run 数・health-watch のログ・nyuka-watch の連続失敗）: 17:00〜17:40 JST の間に読んだ。run 番号で固定してあるので後から同じものを引ける。「5 回連続失敗」は 17:10 JST 時点の数で、その後の手動巡回で変わりうる。
- **手元のベンチ**（1 行 298 バイト・読み書きの所要）: この PC で 17:30 JST 頃に測った。
- 設計と見積もり（§2・§3）は時点に依存しない。

## 根拠データ

- [2026-09-05-passrate-inventory.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-passrate-inventory.json)
  — origin/main 04e7102c の記録ファイル一覧（項目・件数・最終更新・持ち帰りの有無）、持ち帰られていない 6 件、マスタの行数、run ごとの step 所要、1 日の run 数、手元ベンチ（1 行のバイト数・読み書き所要）、サイズ予測。

## 状態

判断待ち（2-7 の 2 点）。コードは変更していない。2026-09-05 夜に「数字の時点」を追記。
