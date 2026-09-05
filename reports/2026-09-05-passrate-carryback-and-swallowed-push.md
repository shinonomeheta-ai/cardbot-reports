# 段3の持ち帰りの確認と、T が最初に捕まえた事故: rebase の競合を握り潰す push（PR #1329）＋ S2 の経路（PR #1326）

セッション名: metrics
日付: 2026-09-05（JST・23:05 時点）
区切り/依頼名: 段3の持ち帰り確認 → 段4 ／ S2 に取得経路を足す（x-intake の分離に備える）

## 受けた指示（原文）

> #1320 をマージしました。
>
> 各 workflow の run で持ち帰りを確認してください。
> - candidate-ai-daily の collect（JST 21:40）→ V5
> - official-x-intake の次の run → N・N2
> - ec-lottery-watch（JST 7:40）→ S1
> - ai-read（JST 8:10）→ S1/ai_read・V4/seed
>
> 全部揃ったら段4（check を health-watch へ配線、check_collection を外す）へ。
> 段4が入れば T は完成です。

> x-intake が公式X の取得経路を Vercel（読む役）+ runner（取る役）に分けます。
> S2 の記録に「どの経路で取ったか」（KV から / 描画に落ちた）を足してください。
> 経路ごとの件数が残れば、Vercel が塞がれたときも数字で分かります。

## 指示と過去の報告の食い違い

なし。

## 報告

### 0. 結論を先に

- **段3の持ち帰りは途中。** nyuka-watch の full 段で D1（まとめ2本・根拠からの登録）・L・V3/official_url を含む 16 部品を確認した。**V5・D1/xweb は当該時刻の run が起きず**（GitHub の schedule 遅れ）、N/N2 は 23:10 待ち、S1 は走ったのに **push が競合で消えた**（下の 2）。
- **T が最初に捕まえた事故**: ec-lottery-watch の `git pull --rebase … || true` が競合を握り潰し、直近 14 回の緑のうち 4 回で候補台帳の更新と通過率の行を緑のまま捨てていた。official-x-intake で #1268 が直した型と同じで、ai-read（払った AI の結果）・candidate-ai-ab・official-x-ingest にもあった。4 本を fail-closed にする [#1329](https://github.com/shinonomeheta-ai/cardbot/pull/1329) を出した。
- S2 に取得経路の件数を足す [#1326](https://github.com/shinonomeheta-ai/cardbot/pull/1326) を出した（x-intake は `route="kv"` を刻むだけで乗れる）。
- 段4（`check` を health-watch へ配線・`check_collection` を外す）は手元でコミットまで済ませ（8b7a3e99）、持ち帰りが揃ったら push する。実データで `check --report` を回して、H1（保留＝全部 held）が判定①に毎回当たる誤報を見つけて直した。

### 1. 段3の持ち帰り（23:05 JST 時点）

| 部品 | 状態 | 根拠 |
|---|---|---|
| D1/cardchusen・D1/meli_melo・D1/evidence・L・V3/official_url（＋段2の11部品） | **確認** | nyuka-watch full 段のコミット 6b9c07de（22:01）・3c0e2169（22:33） |
| V5 | 未 | candidate-ai-daily の 21:40 の collect が起きていない（run が無い）。次は 12:40 JST。手起動なら早い |
| D1/xweb | 未 | official-x-web-discovery の 22:20 の run が起きていない。次は 00:20 JST |
| N・N2 | 未 | official-x-intake の cron 23:10 JST 待ち（20:00 の run は段3のマージ前） |
| S1 | **走ったが消えた** | ec-lottery-watch run 33969135230（22:31）は緑。ログに `create mode … ec-lottery-watch-33969135230.jsonl` のあと `CONFLICT (content): Merge conflict in shadow_candidates.json` → `could not apply`。main に無い |
| S1/ai_read・V4/seed | 未 | ai-read 08:10 JST |

### 2. T が捕まえた事故: rebase の競合を握り潰す push

`ec-lottery-watch.yml` の commit step は

```
git commit -m "chore: ec-lottery-watch update [skip ci]"
git pull --rebase origin "${GITHUB_REF_NAME}" || true
git push origin HEAD:"${GITHUB_REF_NAME}"
```

競合すると rebase が途中で止まり、HEAD が相手側（origin/main）に戻った状態で `push HEAD:main` が「変化なし」で通る。**run は緑、成果は消える。** official-x-intake で #1268 が直した型（12 run 中 10 run 破棄）と同じ。

実測（直近 14 回の緑の run のログを読んだ）: **4 回が同じ競合で成果を捨てていた**（33969135230・33932714507・33575567873・33492922905。全部 `shadow_candidates.json` の競合）。段3の S1 の行が無いことで気づいたが、事故そのものは 8/30 から続いていた。

同じ形: ai-read（**払った AI の結果**が消える）・candidate-ai-ab・official-x-ingest。`-X theirs` で「生成物はこの回のもの」と決めている set-heat / set-images は意味で解決できるので対象外。digest-preview（X の下書きの行列。競合すると下書きが静かに消える）も同じ形だが X 投稿の経路なので**直さず一覧に明記**した。

**#1329 の直し**: 競合したら `git rebase --abort` → 失われる変更を patch にして artifact（lost-commit・14 日）へ → `exit 2` で赤。ec-lottery-watch と ai-read に `alert_incident` の failure / recovery を足した（無かった）。`test_push_not_swallowed` が `pull --rebase … || true` を置かせない。再適用して押し直す（#1268 の `merge_intake_artifacts` の型）は入れていない——候補台帳の再適用は意味で行う必要があり、この PR は「捨てない・止まる・知らせる」まで。

**T の観点**: 期待表の判定②は「workflow ごと行が無い」を弱い合図にしていた。今回のように commit ごと消えると行も消えるので、run は緑・行は無し、になる。段4の `check` は弱い合図として毎回出すが、**`check_workflows`（最終成功の古さ）と組み合わせて「走った（緑）のに行が無い」を鳴らす**方が正しい。段4の追加項目にする。

### 3. S2 の経路（#1326）

`fetch_posts_any` の返り値に `route` を刻む（`timeline` 埋め込みタイムライン／`render` プロフィール描画／`none`）。**読む役（KV）は `official_x_intake.ROUTE_KV = "kv"` を刻む**（x-intake が足す。刻まない fetch は `unknown`）。`run()` が経路ごとに開けたアカウント数（`route`）と取れた投稿数（`route_posts`）を数え、S2 の行の `extra` に `route:<経路>`・`route_posts:<経路>` が写る（再適用の行も）。取得の本体は1行も変えていない。試験 115 OK。

### 4. 段4の準備（手元・未 push）

- health-watch の「Check collection」→「Check passrate」（`python passrate.py check`）。判定は §10-2 の5つ。通知は `alert_incident`（`workflow=passrate / job=<部品>`・障害単位に1回・12 時間ごとの再通知・復旧）。段階 `passrate` を STAGES へ（見出し「通過率に異常があります」。巡回は止まっていないので「止まっています」と言わない）。週1の生存確認は KV。
- update-data が `passrate.py --write` で日次表（`history/passrate_daily.json`）を書いて持ち帰る。
- `check_collection.py` を削除。見張りの試験を外し、note と管理画面の説明を直した。
- **実データで `check --report` を回した結果**: H1（保留＝全部 held・出力は常に0）が判定①「通過率0」に毎回当たる誤報 → ①を「出力0かつ保留なし」に直して試験を足した。残った指摘は「official-x-intake に N・N2 の行が無い」（20:00 の run が段3のマージ前・23:10 で消える見込み）で、配線切れの判定が想定どおり働いている。
- 試験 150 OK（stage1〜4・配線・source_stats・health_watch・alert_incident・LF）。

### 5. そのほか気づいたこと

- update-data は 09-04 04:00Z から連続失敗（直近は データ契約（push直前）の `test_data_contract / test_event_id_registry / test_shadow_url_owner`）。段1〜3 のマージ前からで metrics の変更とは無関係だが、未対応のまま（ci の領分）。
- 22:40 JST 時点で 21:40（candidate-ai-daily）・22:20（web-discovery）の schedule が起きていない。nyuka-watch の schedule は起きているので停止ではなく間引き。V5 は手起動の collect が無ければ明日 12:40 になる。

## 根拠データ

- [2026-09-05-swallowed-push.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-swallowed-push.json) — ec-lottery-watch 直近 14 回の緑の run ログを読んだ結果（消えた 4 回・コミットした 10 回）、同じ形の workflow、持ち帰りの状態、update-data の連続失敗

## 状態

判断待ち: #1329（fail-closed）と #1326（S2 の経路）のマージ。段4は持ち帰りが揃ったら push（V5 は 12:40 JST の collect か手起動）。
