# T（通過率の計測）段2の実装: PR #1317（L2・L・V7・V3・F・H1/H2）

セッション名: metrics
日付: 2026-09-05（JST）
区切り/依頼名: T の実装・段2（L2 → L → V7 → V3 → F → H1/H2）
対象: `origin/main` = 81231543（段1の持ち帰りを確認したコミット）から切った枝 `feat/passrate-stage2`。専用 worktree で作業し、共有の作業ツリーは触っていない。

## 受けた指示（原文）

> ## 段2へ
> #1312 がマージされて持ち帰りが確認できたら、段2
> （L・L2・V7・V3・F・H1/H2）に進んでください。
> L2 の registry_refusal は、今日の事故の型なので早めに。
>
> （続報）
> 確認しました。段2の呼ぶ場所を先に読み終えているので、
> 持ち帰りが確認できたらすぐ着手できる状態ですね。
>
> #1311・#1312 のマージは本人が操作します。
> official-x-intake の次の run（JST 20:00 か cron 23:10）で持ち帰りを確認してください。
>
> 段2の順は L2 → L → V7 → V3 → F → H1/H2 で。L2 の registry_refusal が今日の事故の型なので最初に。

## 指示と過去の報告の食い違い

なし。持ち帰りは official-x-intake より先に nyuka-watch（#1314 で復帰）の run 33959434793 で確認できたので、その時点で着手した（段1の報告に追記済み）。

## 報告

### 0. 出した PR

[#1317](https://github.com/shinonomeheta-ai/cardbot/pull/1317) `feat/passrate-stage2`（head 878ef656）— CI 待ち。

### 1. 部品ごとの記録（どこで・何を）

どれも、その部品がもう持っている数を流すだけ。台帳を読み直さない。

| 部品 | 呼ぶ場所 | in → out ／ dropped・held | reasons ／ extra |
|---|---|---|---|
| **L2** | `lottery_io.save` の出口（本番の `lotteries.json` を書くときだけ）。`守る()` が `応募回を決める` の理由を控える | 行数 → 当てた（持ち越し＋台帳の一致＋発番）／ ambiguous・no_deadline・no_event_id | `issued`・`matched`・`carried`・`caller`・素性の `identity_appended`・`orphan_merged`・`identity_held`（#1314 の案B/C）。**`台帳が壊れている` は再送出の前に `registry_refusal=1` の行**（入力ぜんぶ落ちた形）を残す。今日の5回連続失敗の型は、これで1回目に「拒否 1」として見える |
| **L** | `build_candidates_shadow.main`（health を書いたあと） | input_rows → 新規＋既存 ／ skipped | `not_target`・`not_lottery`（内訳は `extra.not_lottery:*`）・candidates・rounds・active・provisional・conflicts |
| **V7** | `promote_candidate_decisions.main`（監査の直後・dry-run でも） | 刻んだ＋食い違い → 刻んだ ／ store_mismatch | `links_total`・`migrated_from_rows`・**`mismatched_existing`＝`食い違う刻印()` を本番でも呼んだ数**（これまで試験からしか呼ばれていなかった）・`applied` |
| **V3** | `verify_lotteries.main` の末尾 | 読んだ行 → 残った行 ／ boundary_duplicate・deadline_moved・channel_duplicate | `date_sanitized`・`store_fixed`・`conflicts`・`conflict_resolved`・`deadline_multi`・`result_multi`・`apply_url_over` |
| V3/dup | `collapse_open_duplicates.main` | 前 → 後 ／ open_duplicate | — |
| V3/similar | `mark_similar_rounds.main` | 行数 → 行数 | `pairs`・`marked` |
| V3/official_url | `finalize_official_urls.main` | 対象 → ok ／ url_dropped・held＝未確定 | `fixed` |
| **F** | `publish_reviewed_only.main`（既定値のあと） | 配る行 → 配る行 | `apply_start`・`prefecture_default`・`prefecture_from_store`・`announcement_is_entry`・`sns_apply_url`・`game_rounded`・`official_source_url` |
| F/receive | `fill_receive_method.main` | 行数 → 行数 | 埋めた内訳（`ship:vendor` 等） |
| F/methods | `fill_round_methods.main` | 応募回数 → 応募回数 | 埋めた内訳・`applied` |
| **H1** | `publish_reviewed_only`（`判定表` の直後） | 落とした回 → 0 ／ held＝全部 | 理由は関門の語彙そのまま・`pending_review`（人の判定待ち）・`no_candidate_mapping` |
| **H2** | 同上。前回の `publish_verdicts.json` と突き合わせ | 前回落とした回 → 今回配った（解消） ／ dropped＝配布行から消えた（`removed`）・held＝まだ落としている | `resolved:kept_human` / `resolved:kept_ai` |

### 2. `passrate.py` の変更

- 小部品 `sub`: 日次の表と語彙の鍵が「部品/小部品」（`V3/dup` など）。`part` は §0 の記号のまま。
- `PASSRATE_DISABLE=1`: 行は組むが書かない。コミットしない試行（ec-roster-pilot）と AI 成果物だけ押す経路（candidate-ai-review。`data_push.py --ai` の許可リストに入れないため）に付けた。**持ち帰れない記録は無いのと同じなので、書かないと宣言する。** 配線試験が「DISABLE を付けたのにコミットする workflow」を落とす。
- 語彙5つ（`passrate_l_reason` / `l2` / `v3` / `v7` / `h2`）を `vocab_master`・`vocab_history.jsonl`・`vocab.gen.mjs` へ。H1 の語彙は関門（`publish_verdict_reason`）と同じ。
- 期待表: nyuka-watch の全段と update-data に P・L2・V3・V3/dup・V3/similar・V7・F・F/receive・F/methods・H1・H2、full と update-data に L・V3/official_url、resolve-dates / audit-dates に V3、promote-now に V7。official-x-intake は取り込み0件だと候補台帳の作り直しへ進まないので L を期待しない。

### 3. 持ち帰り

resolve-dates / audit-dates（`verify_lotteries` を呼ぶ）に `history/passrate` の add を足した。promote-now は `git add -A`。nyuka-watch / update-data / official-x-intake は段1で追加済み。

### 4. 確認したこと

- `python -m unittest test_passrate test_passrate_stage2 test_passrate_wiring` → 42 OK。
- 段2の影響範囲 42 モジュール（845 tests）: この PR 由来の赤なし。赤3件は素の `origin/main`（ba1fdb41 の detached worktree）で同じ試験を回しても同じ（`test_lottery_overrides` の控え、`test_overrides_touch_identity` の 7→10、`test_dedupe_channel.実データ` は一括のときだけ）。
- 手元 E2E（Actions の外なので `history/passrate/local/` に書かれる）: verify_lotteries → collapse → mark_similar → finalize → fill_receive → fill_round_methods → promote（dry-run）→ publish_reviewed_only（数えるだけ）→ build_candidates_shadow を順に回し、**14 行**が書けた（L2×2＝verify と finalize の save・L・V7・V3・V3/dup・V3/similar・V3/official_url・F・F/receive・F/methods・H1・H2・P）。

  ```
  L2               in=286 out=284 drop=2   reasons={ambiguous:0, no_deadline:0, no_event_id:2} extra={issued:0, matched:10, carried:274, registry_refusal:0, identity_appended:0, orphan_merged:0, identity_held:0}
  L                in=286 out=85  drop=201 reasons={not_target:201, not_lottery:0} extra={new:0, existing:85, candidates:1888, rounds:2095, active_rounds:1083, provisional:471, conflicts:63}
  V7               in=47  out=47  drop=0   reasons={store_mismatch:0} extra={links_total:240, migrated_from_rows:0, mismatched_existing:8, existing_rows:186, applied:0}
  V3               in=286 out=286 drop=0   reasons={boundary_duplicate:0, deadline_moved:0, channel_duplicate:0} extra={date_sanitized:0, conflicts:110, conflict_resolved:0, deadline_multi:25, result_multi:1}
  V3/dup           in=286 out=283 drop=3   reasons={open_duplicate:3}
  V3/similar       in=286 out=286          extra={pairs:62, marked:106}
  V3/official_url  in=0   out=0            （手元に対象なし）
  F                in=267 out=267          extra={apply_start:1, prefecture_default:20, sns_apply_url:1, …}
  F/receive        in=286 out=286          extra={(空のまま):8}
  F/methods        in=2095 out=2095        extra={apply_start:AI観測:2, result_date:AI観測:2, receive:pickup:1}
  H1               in=22  held=22          reasons={start_too_old:2, date_conflict_unresolved:20} extra={pending_review:766, no_candidate_mapping:11}
  H2               in=27  out=0   drop=27  reasons={removed:27}
  P                in=286 out=267 drop=19  reasons={start_too_old:1, date_conflict_unresolved:15, ai_not_run:3}
  ```

  手元の H2 が「27 件 removed」なのは、前回の刻印（main の 19:13 の run・配布 647 行）に対して手元の配布データがすでに関門を通った後の 286 行だから。本番では materialize / promote が落ちた回を毎回作り直すので「まだ落としている」に入る。
- E2E が触った配布データ（`lotteries.json`・候補台帳・health 等）は戻した。この PR にデータの変更は無い。

### 5. 読むときの注意（設計書には書いていない運用上の癖）

- L2 は `save` のたびに1行（1 run に複数。`extra.caller` で区別）。`carried` は保存ごとに同じ行を数え直すので日次は runs で割って読む。`issued` / `matched` / `registry_refusal` は出来事の数なので合計でよい。
- H2 の `removed` は「配布行から消えた」であって締切超過とは限らない（畳まれた・手で落とした・材料が変わった）。打ち切り（§9-2）を数えるには、消えた回の締切を見る必要があり、段3以降で `extra.expired` を足す。
- V7 の `mismatched_existing`（既にある刻印の店の食い違い）は手元で 8。#1261 で直した3件の後も残っている表記ゆれの組（別名台帳に無いだけのもの）で、別支店の吸収ではない（`round_links.同じ店と言えるか` の docstring の実測 9 件と同じ性質）。段3の N（正規化）の材料になる。

### 6. 事故と学び

- E2E の後始末で「保つファイル」の正規表現を `^(\.github/|…)$` と書き、`.github/` 直下しか当たらなかったため、ワークフロー4本の編集を `git checkout` で戻してしまった。配線試験（`test_passrate_wiring`）が落ちて気づき、4本だけ再適用した。**戻す側の一覧も試験と同じ名前の集合で作るべきだった。**

## CI の結果（追記）

head e84b206a（§10 の「運用上の癖」3点を足したコミット）。

| 検査 | 結果 |
|---|---|
| vocab | 緑 |
| build（web） | 緑（main のデータのずれが直ったので段1のときの赤も消えた） |
| python test | 赤3件＝`test_lottery_overrides` の控え2件＋`test_overrides_touch_identity` の 7→10。どちらも素の `origin/main`（ba1fdb41 の detached worktree）で同じ。`test_dedupe_channel.実データ` は一括のときだけ。**PR 由来の赤なし**（7,373 tests） |

手元の全件（7,373 tests）も同じ顔ぶれ＋Windows 固有の `relpath` ERROR 1件で、PR 由来の赤なし。

## 持ち帰りの確認（2026-09-05 20:40 JST・追記）

#1317 は本人操作で 20:01 JST にマージ（63706954）。20:00 に始まった nyuka-watch（run 33962172034）はマージ直前の main を取り出していたので P だけだったが、次の run（33962540752・fast 段）のコミット 491bf2e4 に段2の行が入った:

```
history/passrate/2026-09-05/nyuka-watch-33962540752.jsonl
  parts = F, F/methods, F/receive, H1, H2, L2, P, V3, V3/dup, V3/similar, V7
```

fast 段なので L と V3/official_url は出ない（期待表どおり）。マージ直後の official-x-intake（run 33962171096・コミット 9817bc5d）にも S2（本体＋再適用の `save_failed=1` の行）と L（候補台帳の作り直し）が入っており、**再適用の行が実際に出た**（最初の push が競合して押し直した回）。

段2完了。段3（V5 を最初に）へ。

## 根拠データ

- [2026-09-05-passrate-inventory.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-passrate-inventory.json) — 棚卸し（設計報告と同じ）

## 状態

段2完了（マージ済・持ち帰り確認済）。次は段3。
