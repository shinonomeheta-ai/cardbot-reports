# トピックのX切り抜きの並べ替え — マージ完了（PR #1593）

前の報告: https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-16-x-clip-reach-rank.md

## 指示文（本人・2026-09-16）

> レビュー担当の承認は不要です。

## マージした

| | |
| --- | --- |
| PR | #1593 |
| merge commit | `6f54c9ae2eaaa9f7719e043c8b52e92bfdb9f70e` |
| 方式 | squash |
| マージ時刻 | 2026-09-16 20:06 JST |

```
6f54c9ae2 トピックのX切り抜きを、反応の多い順に選んで最大を先頭に置く (#1593)
```

変更は8ファイル（`x_post_reach.py` 新規・`rerank_news_posts.py` 新規・`build_news.py`・試験2本・`docs/assumptions.md`・workflow 2本）。

## マージ条件の確認

| 条件 | 状態 |
| --- | --- |
| CI で PR 固有の赤が0件 | ✅ `main` の基準と突き合わせて差分0件（顔ぶれも一致） |
| Vercel プレビューが成功 | ✅ `Deployment has completed` |
| レビュー担当の承認 | ✅ **本人指示により不要**（2026-09-16） |
| merge commit を報告に追記 | ✅ この報告 |

`main` に残る赤10件（`test_dedupe_channel` 実データ・`test_wayback_backfill` 3件・`test_official_site_watch`・`test_jst_single_home`・`test_deadline_update` 系）は**マージ前から main にあったもの**で、この変更では増えていない。`test_jst_single_home` は `official_site_watch.py:97` が自前でJSTを作っていることを指している。

## 画面に出るのはいつか

**`news.json` はPRに含めていない**（データは巡回が持つ）。並べ替えは `build_news.py` の中で走るので、**次の `update-data`（06:00 JST）で自動的に適用される**。手元の `--dry` では、適用後の先頭は 29,281 / 8,618 / 463 / 191 / 89 反応の投稿になる。

急ぐ場合は `rerank_news_posts.py` を回して `news.json` だけを別PRで出せる（AIは呼ばないので無料）。

## 次に見ること

* **15件以上を実際に満たせるか。** これまでの実測では1話題7〜10件しか返っていない。AIに聞く数を40件へ上げたときの歩留まりは、次の収集で分かる
* 足切り（反応5件）は15件を超えた話題にしか効かないので、いまは1件も落ちない
