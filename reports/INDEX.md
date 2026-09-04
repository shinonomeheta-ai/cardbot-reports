# 報告の索引

新しい報告を `reports/` に置いたら、**必ずこの表に1行足す**。
**既存の報告に追記したときも、その行を直す**（状態・判断結果・追記日）。
新しいファイルを作らない追記でも、動きがあれば必ずここへ反映する。

| 日付 | 区切り/依頼名 | 指示の要点 | 報告ファイル | 判断結果 | 状態 |
| --- | --- | --- | --- | --- | --- |
| 2026-09-04 | 監査 | 設計と実装の対応表 | 本文なし（チャットのみ） | 不一致4点を確認 | 完了 |
| 2026-09-04 | 第1区切り | 配信の関門の事前集計 | 本文なし（チャットのみ） | 書き方A・条件②は食い違いのみ・条件③なし | 完了 |
| 2026-09-04 | 公式X登録 | 保存済みリンクから登録 | 本文なし（チャットのみ） | 8店登録・母数の確認待ち | 確認中 |
| 2026-09-04 | 捕捉率の全数測定 | 全1,192アカウントで捕捉率を測り、改善手段を実測比較する | [2026-09-04-x-intake-capture-rate.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-x-intake-capture-rate.md) | §2のrebase修正と--sleep削除を最優先で実施（3〜5は効果測定後に判断） | 実装中 |
| 2026-09-04 | §2 の修正 | rebase の握り潰しを姉妹workflowの型で直し、--sleep を外す | [2026-09-04-intake-push-fix.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-intake-push-fix.md) | 判断待ち | 確認中 |
| 2026-09-04 | 第1区切り | 配信の関門の実装＋刻印3件の修正 | [2026-09-04-gate-impl.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-gate-impl.md) | 承認・#1261 マージ | 完了 |
| 2026-09-04 | 第1区切り | conflict_status の意味の分離（判断への対応） | [2026-09-04-conflict-status-split.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-conflict-status-split.md) | 承認・#1263 マージ。跡の寿命は §9 と一緒／走査テストの拡張は §11 で別途 | 完了 |
| 2026-09-04 | 連結名の削除 | 見出しが前に付いた店名3件を落とす | [2026-09-04-concat-names.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-concat-names.md) | 削除は承認。配布行は消さず「正しい名へ寄せて畳む」で後日。制約は assumptions.md へ記録 | 完了 |
| 2026-09-04 | INDEX 絶対URL化 / §8-1 修正 | INDEX のリンクを絶対URLへ・設計書 §8-1 から「締切が未来」を外す | [2026-09-04-index-urls-and-gate-8-1.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-index-urls-and-gate-8-1.md) | 承認・#1265 マージ。CLAUDE.md へ「push したらチャットに raw URL を書く」を追記 | 完了 |
| 2026-09-04 | 発見と値の分離 | まとめを発見だけにした場合の測定と実装規模 | [2026-09-04-discovery-vs-values.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-discovery-vs-values.md) | 判断待ち | 確認中 |
| 2026-09-04 | CI費用の削減 | python test の実行を減らす調査 | [2026-09-04-ci-cost.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-ci-cost.md) | 判断待ち | 確認中 |
| 2026-09-04 | 報告置き場の運用 | 写しの取得元を origin/main へ／CLAUDE.md を管理下に | [2026-09-04-sync-docs-and-claude-md.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-sync-docs-and-claude-md.md) | 案1で実装の指示（PR #1267 はマージ待ち） | 確認中 |
| 2026-09-04 | 索引検査 | INDEX の報告ファイル列が絶対URLかを機械で検査する | [2026-09-04-index-url-gate.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-index-url-gate.md) | 承認（依頼1のみ実装。依頼2・3は指示側の重複渡しと確認）。以後このセッションは index と名乗る | 完了 |
| 2026-09-04 | 引きの別名対応 | 正規化の正本をどれにするか・店名で引く全経路・直す順番（調査のみ） | [2026-09-04-store-name-normalization.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-store-name-normalization.md) | 判断待ち | 確認中 |
| 2026-09-04 | CI費用の削減 1 | 常駐赤の切り分け（実装なし） | [2026-09-04-ci-red-triage.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-ci-red-triage.md) | 判断待ち | 確認中 |
| 2026-09-04 | CI費用の削減 2 | 巡回の該当段の停止（止める対象の訂正と混入の一覧） | [2026-09-04-identity-key-absorb.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-identity-key-absorb.md) | 止める対象の訂正は妥当・止めずに汚染源の特定へ。**数え方に誤りがあり後続報告で訂正** | 完了 |
| 2026-09-04 | 共有作業ツリーの棚卸し | 作業ツリーを使う処理の一覧（調査のみ・docs） | [2026-09-04-shared-worktree-survey.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-shared-worktree-survey.md) | 判断待ち | 確認中 |
| 2026-09-04 | CI費用の削減 2 | 汚染源の特定＋案1の差し戻し | [2026-09-04-absorb-source.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-absorb-source.md) | 案1を採用・#1271 マージ（b595cd7e）。戻る症状は289行中1行。既存7件は次の巡回で停止を確認してから | 確認中 |
| 2026-09-04 | 引きの別名対応・段1 | 公式Xの表を引く鍵の形を合わせる（docs） | [2026-09-04-official-x-lookup-key.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-official-x-lookup-key.md) | 承認・#1269 マージ（3b05a18f） | 完了 |
| 2026-09-04（追記 09-04） | 引きの別名対応・段1 | 店名の索引を1本にする（実施・PR #1270） | [2026-09-04-official-handle-index.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-official-handle-index.md) | 承認・マージ済（c1a4337c）。本体は #1269 が先に main へ入っていたため #1270 は「登録名の完全一致を先に見る」差分だけに縮小。効果は巡回後に実測 | 完了 |
| 2026-09-04 | 引きの別名対応・段1の後始末 | 衝突する TSUTAYA 5店のどちらのハンドルが本物か（調査のみ・store-name） | [2026-09-04-tsutaya-handle-collision.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-tsutaya-handle-collision.md) | 判断待ち | 確認中 |
| 2026-09-04 | 引きの別名対応・案A | 未確認の公式X登録3件を外す＋正規化名の鍵の棚卸し（store-name） | [2026-09-04-plan-a-and-normkeys.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-plan-a-and-normkeys.md) | 判断待ち（PR #1273 マージ待ち） | 確認中 |

上の3件は、報告置き場を作る前のやりとり。**本文をファイルにする運用はここから始める**ため、
遡っての本文作成は行わない（2026-09-04 決定）。以降の報告は必ず本文をファイルに残す。
第1区切りは事前集計と実装で報告が別なので、行を2つに分けてある（事前集計の行は実装が
終わったので `完了`）。

## 列の意味

| 列 | 書くこと |
| --- | --- |
| 日付 | 報告した日（JST）。ファイル名の日付と揃える。**あとから追記した日が違うときは併記する**（例: `2026-09-04（追記 09-05）`） |
| 区切り/依頼名 | どの区切り・どの依頼への報告か（例: 監査 / 第1区切り / 公式X登録） |
| 指示の要点 | レビュー担当から受けた指示を1行に縮めたもの |
| 報告ファイル | **必ず絶対URLで書く**（下記）。置き場を作る前の報告だけ「本文なし（チャットのみ）」 |
| 判断結果 | **指示を出した側（レビュー担当）が下した判断**を1行で。未決なら「判断待ち」 |
| 状態 | `実装中` / `確認中` / `完了` / `保留` のいずれか |

状態はこの4語だけを使う。ほかの語を足さない。

## 報告ファイルへのリンクは絶対URL（2026-09-04 決定）

レビュー担当は **raw URL で INDEX を読む**。raw は Markdown を描かず素の文字列を返すので、
相対パス（`[名前](名前.md)`）では報告本文へ辿れない。**必ず絶対URLで書く。**

```
| … | [2026-09-04-example.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-example.md) | … |
```

前置きは `https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/` で固定。
