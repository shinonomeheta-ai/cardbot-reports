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
| 2026-09-04 | 依頼3〜5 | 1日1周・頻度に応じた配分・repository_dispatch化 | [2026-09-04-intake-coverage.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-intake-coverage.md) | 判断待ち | 確認中 |
| 2026-09-04 | 第1区切り | 配信の関門の実装＋刻印3件の修正 | [2026-09-04-gate-impl.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-gate-impl.md) | 承認・#1261 マージ | 完了 |
| 2026-09-04 | 第1区切り | conflict_status の意味の分離（判断への対応） | [2026-09-04-conflict-status-split.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-conflict-status-split.md) | 承認・#1263 マージ。跡の寿命は §9 と一緒／走査テストの拡張は §11 で別途 | 完了 |
| 2026-09-04 | 連結名の削除 | 見出しが前に付いた店名3件を落とす | [2026-09-04-concat-names.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-concat-names.md) | 削除は承認。配布行は消さず「正しい名へ寄せて畳む」で後日。制約は assumptions.md へ記録 | 完了 |
| 2026-09-04 | INDEX 絶対URL化 / §8-1 修正 | INDEX のリンクを絶対URLへ・設計書 §8-1 から「締切が未来」を外す | [2026-09-04-index-urls-and-gate-8-1.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-index-urls-and-gate-8-1.md) | 承認・#1265 マージ。CLAUDE.md へ「push したらチャットに raw URL を書く」を追記 | 完了 |
| 2026-09-04 | 発見と値の分離 | まとめを発見だけにした場合の測定と実装規模 | [2026-09-04-discovery-vs-values.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-discovery-vs-values.md) | 判断待ち | 確認中 |
| 2026-09-04 | CI費用の削減 | python test の実行を減らす調査 | [2026-09-04-ci-cost.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-ci-cost.md) | 判断待ち | 確認中 |
| 2026-09-04 | 報告置き場の運用 | 写しの取得元を origin/main へ／CLAUDE.md を管理下に | [2026-09-04-sync-docs-and-claude-md.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-sync-docs-and-claude-md.md) | 案1で実装の指示（PR #1267 はマージ待ち） | 確認中 |
| 2026-09-04 | 索引検査 | INDEX の報告ファイル列が絶対URLかを機械で検査する | [2026-09-04-index-url-gate.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-index-url-gate.md) | 承認（依頼1のみ実装。依頼2・3は指示側の重複渡しと確認）。以後このセッションは index と名乗る | 完了 |
| 2026-09-04 | 引きの別名対応 | 正規化の正本をどれにするか・店名で引く全経路・直す順番（調査のみ） | [2026-09-04-store-name-normalization.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-store-name-normalization.md) | 判断待ち | 確認中 |
| 2026-09-04 | CI費用の削減 1 | 常駐赤の切り分け（実装なし） | [2026-09-04-ci-red-triage.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-ci-red-triage.md) | 分類は妥当・B/Dは着手承認。**件数14件は数え方の誤りで後続報告で訂正** | 完了 |
| 2026-09-04 | CI費用の削減 2 | 巡回の該当段の停止（止める対象の訂正と混入の一覧） | [2026-09-04-identity-key-absorb.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-identity-key-absorb.md) | 止める対象の訂正は妥当・止めずに汚染源の特定へ。**数え方に誤りがあり後続報告で訂正** | 完了 |
| 2026-09-04 | 共有作業ツリーの棚卸し | 作業ツリーを使う処理の一覧（調査のみ・docs） | [2026-09-04-shared-worktree-survey.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-shared-worktree-survey.md) | 判断待ち | 確認中 |
| 2026-09-04 | CI費用の削減 2 | 汚染源の特定＋案1の差し戻し | [2026-09-04-absorb-source.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-absorb-source.md) | 案1を採用・#1271 マージ（b595cd7e）。戻る症状は289行中1行。既存7件は次の巡回で停止を確認してから | 確認中 |
| 2026-09-04 | 引きの別名対応・段1 | 公式Xの表を引く鍵の形を合わせる（docs） | [2026-09-04-official-x-lookup-key.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-official-x-lookup-key.md) | 承認・#1269 マージ（3b05a18f） | 完了 |
| 2026-09-04（追記 09-04×3） | 引きの別名対応・段1 | 店名の索引を1本にする（実施・PR #1270・store-name-b） | [2026-09-04-official-handle-index.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-official-handle-index.md) | 承認・マージ済（c1a4337c）。追記3で official_handle() の寄与を現 main（cd236648）で実測＝救う8店名・副作用0件・救えないのは ドラゴンスター各店 1件。段4の判断根拠として保存 | 完了 |
| 2026-09-04 | 引きの別名対応・段1の後始末 | 衝突する TSUTAYA 5店のどちらのハンドルが本物か（調査のみ・store-name） | [2026-09-04-tsutaya-handle-collision.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-tsutaya-handle-collision.md) | 判断待ち | 確認中 |
| 2026-09-04 | 引きの別名対応・案A | 未確認の公式X登録3件を外す＋正規化名の鍵の棚卸し（store-name） | [2026-09-04-plan-a-and-normkeys.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-plan-a-and-normkeys.md) | 判断待ち（PR #1273 マージ待ち） | 確認中 |
| 2026-09-04 | 引きの別名対応・前提確認 | canonical_name の健全性と輪が止まらない理由（調査のみ・store-name-a） | [2026-09-04-canonical-name-health.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-canonical-name-health.md) | 判断待ち | 確認中 |
| 2026-09-04（追記 09-04） | CI費用の削減 1 | B の修正・D の不在・GOODGAME の確認・赤の数え方の訂正 | [2026-09-04-ci-red-bd-goodgame.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-ci-red-bd-goodgame.md) | §4 の GOODGAME 判定は誤りと判明し取り下げ。測り直しは shared-platform-gate へ | 訂正済み |
| 2026-09-04 | CI費用の削減 1 | 関門を入れる前に影響（from_source の件数・外れる件数・正しい件数）を測る | [2026-09-04-shared-platform-gate.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-shared-platform-gate.md) | 案A を採用（試験を直す）・案C は別の区切りへ。GOODGAME の訂正も了承 | 完了 |
| 2026-09-04 | CI費用の削減 1 | 案A の実施（試験に免除を足す）＋ 本番と試験のずれの棚卸し | [2026-09-04-gate-fix-and-rule-drift.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-gate-fix-and-rule-drift.md) | 案A を承認・#1278 マージ済み（d9e86103）。一覧のずれは即修正の指示 | 完了 |
| 2026-09-04 | CI費用の削減 1 | 共有基盤の一覧のずれを直す（突き合わせ試験つき）＋ まとめ一覧に無い記事形式ホストの棚卸し | [2026-09-04-shared-platform-list-parity.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-shared-platform-list-parity.md) | #1278・#1281 ともマージ済み。突き合わせ試験の作り方を承認 | 完了 |
| 2026-09-05 | CI費用の削減 1 | build の常駐赤（lotteries/e2e の 290≠292）の調査 ＋ rare-zaiko を足した場合の影響 | [2026-09-05-build-red-duplicates.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-build-red-duplicates.md) | round_id で畳む案を採用（実装は原因調査の後）。rare-zaiko は追加の指示 | 完了 |
| 2026-09-05 | CI費用の削減 1 | rare-zaiko を足す／9/2 から重複が出る原因／round_id で畳む前の確認3点 | [2026-09-05-round-id-collapse.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-round-id-collapse.md) | 畳みは案Bを採用（実装指示）。台帳の件は最優先で修正案を出す指示。#1286 はマージ指示 | 完了 |
| 2026-09-05 | CI費用の削減 1 | event_id 台帳の作り直しが止まっている件の修正案 | [2026-09-05-registry-refusal.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-registry-refusal.md) | 案1の狭い版を採用・#1289 マージ済み（c182316e）。作り直しが通り保留もファイルへ出ることを確認 | 完了 |
| 2026-09-05 | CI費用の削減 1 | 台帳の修正（#1289 マージ）／吸収の測り直し／U+007F の経路 | [2026-09-05-control-char.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-control-char.md) | U+007F の関門と除去を承認・実施済み（#1293）。吸収+0の測定も確認 | 完了 |
| 2026-09-05 | CI費用の削減 1 | U+007F を止める／test_url_candidate の切り分け／案B の実装 | [2026-09-05-collapse-round-id.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-collapse-round-id.md) | #1293・#1294 ともマージ済み。A-2/B-2 を採用（段1を待つ・台帳は触らない） | 完了 |
| 2026-09-05 | CI費用の削減 1 | 段1の範囲の再定義／吸収の数え方の訂正（6→5）／配布データの混入の記録 | [2026-09-05-stage1-scope.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-stage1-scope.md) | 範囲を承認（C=段1／A=M1g／D=store-name-a）。印を付ける・強めるのは別名整備の後 | 完了 |
| 2026-09-05 | CI費用の削減 1 | 段1の印の実装／「配布7回」の訂正（実際は1件）／xAI経路を開きかけた件 | [2026-09-05-owner-mismatch.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-owner-mismatch.md) | #1298 マージ済み。巡回を回して印を確認・A/C の穴を直す指示 | 完了 |
| 2026-09-05 | CI費用の削減 1 | 巡回の確認（印35/122）／A-C判定の穴／残る赤4件の切り分けと修正案 | [2026-09-05-reds-triage.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-reds-triage.md) | 判断待ち（lottery_overrides の案1〜4）。candidate_ai_runner は roundup 待ち | 確認中 |
| 2026-09-04（追記 09-04） | 引きの別名対応・出口と入口 | 出口(#1276)を push＋入口に author_name が使えるかの事前確認（store-name-a） | [2026-09-04-author-name-entrance.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-author-name-entrance.md) | 判断待ち（入口の修正は効果なしと実測。実施しないことを推奨）。初回 push が空になったため本文を入れ直し、publish-report.sh に空の関門を足した（§3） | 確認中 |
| 2026-09-04（追記 09-04） | 引きの別名対応・段2 | 公式X表・店サイト表を引く鍵を tenantKey へ寄せる（store-name-a） | [2026-09-04-stage2-tenant-key.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-stage2-tenant-key.md) | 判断待ち（PR #1280・配布物でURLを失う行は0）。CIは main と同じ赤のみ（§6・23:05 追記） | 確認中 |
| 2026-09-04 | 引きの別名対応・書き手の特定 | 正規化の出力を店名として書き戻す経路を探す（store-name-a） | [2026-09-04-broken-name-writer.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-broken-name-writer.md) | 判断待ち（入口は既に閉じている・輪を切る3案＋段2の漏れ PR #1282） | 確認中 |
| 2026-09-05 | 引きの別名対応・掃除（3）の着手前 | 【訂正】直した鍵が3.5時間で戻った・掃除は止めている（store-name-a） | [2026-09-05-ghost-rows-regrow.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-ghost-rows-regrow.md) | 判断待ち（案B→案A→案Cを推奨・幽霊の行17件） | 確認中 |
| 2026-09-05（追記 09-05） | 引きの別名対応・案B/案C/案A | 探索の対象から別綴りを外す＋誤登録1件除去＋幽霊18件の材料（store-name-a） | [2026-09-05-plan-b-c-and-ghost-detail.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-plan-b-c-and-ghost-detail.md) | 判断待ち（PR #1285・案Aは材料のみ・案Bは別店5件も止める代償あり）。CIは main と同じ赤13件のみ（§7・追記済） | 確認中 |
| 2026-09-05 | 予行演習の実行 | 通知の経路を確かめ、mainの赤12件を ci へ渡す | [2026-09-05-intake-rehearsal-and-outage.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-intake-rehearsal-and-outage.md) | 判断待ち | 確認中 |
| 2026-09-05 | 読めないworkflowの検知 | 案出し（実装前）。stateは使えず、実行名がパスになる形で見分ける | [2026-09-05-unparseable-workflow-detection.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-unparseable-workflow-detection.md) | 判断待ち（案B＋D-2 を推奨） | 確認中 |
| 2026-09-05（追記 09-05） | 引きの別名対応・案A(a)/案Bの絞り込み/(d) | 幽霊7件を統合＋売り方が違う相手は止めない＋誤登録4件の一覧（store-name-a） | [2026-09-05-merge-ghosts-and-misregistration.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-merge-ghosts-and-misregistration.md) | 判断待ち（PR #1287・(d)4件はci セッションと突き合わせ要）。CIは main と完全一致の赤13件のみ（§7・書き直し済） | 確認中 |
| 2026-09-05（追記 09-05） | 引きの別名対応・(d) の除去 | チェーン名に支店・通販の口が結ばれた登録4件を外す（store-name-a） | [2026-09-05-drop-chain-branch-handles.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-drop-chain-branch-handles.md) | 判断待ち（PR #1288・配布行への影響0行／応募回 -8）。CIは main と完全一致の赤14件のみ。main の新しい赤1件は巡回 88764db1 由来と切り分け済（§5） | 確認中 |
| 2026-09-05 | 引きの別名対応・現在地の固定 | 段1〜案C の到達点を1枚に＋失った根拠8回の測定（store-name-a） | [2026-09-05-stage1-to-planC-summary.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-stage1-to-planC-summary.md) | 判断待ち（段3の着手はこの整理を見てから）。指示の数字2つを訂正 | 確認中 |
| 2026-09-05 | 段3-A ＋ B の問い | 店名48件を観測済みの表記へ戻す＋誤登録1件／チェーンの単位を実測で整理（store-name-a） | [2026-09-05-stage3a-and-chain-unit.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-stage3a-and-chain-unit.md) | 判断待ち（PR #1292）。「15件のうち11件」は成り立たず＝機械で決まるのは1件だけ | 確認中 |
| 2026-09-05 | 段3・B の答えの反映 | 設計書 §3-1-1／ノジマの付け替え／M1gにいる分の食い違い4件（store-name-a） | [2026-09-05-chain-unit-doc-and-attachment.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-chain-unit-doc-and-attachment.md) | 判断待ち（PR #1295）。付け替え候補2件・行き先なし2件（エディオンは配布2行が根拠を失う） | 確認中 |
| 2026-09-05 | 段3-A の仕上げ | 通販の口の付け替え2件／§3-1-1 に正しい形の実例／M1gへ2件持ち越し（store-name-a） | [2026-09-05-reattach-ec-handles.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-reattach-ec-handles.md) | 判断待ち（PR #1296）。応募回は差し引き0／エディオンは配布2行が通販の口を根拠に出ている | 確認中 |
| 2026-09-05（追記 09-05） | 段3-A の完了と待機 | 段3-A 完了の整理＋M1g の store_keys 重複2件・行なし1件を実測（store-name-a） | [2026-09-05-stage3a-done.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-stage3a-done.md) | 完了（PR #1296 マージ済み）。段3-B は指示待ちで待機。着手順はエディオンから（§4） | 完了 |
| 2026-09-05 | 段3-B（別名の整備） | owner_mismatch 35本の分類。別名では解けない件を実測して停止（store-name-a） | [2026-09-05-owner-mismatch-triage.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-owner-mismatch-triage.md) | 判断待ち。23/35は別名の問題でない／canonical_store を通す収集器が1つだけなので別名を足しても効かない | 確認中 |
| 2026-09-05 | 段3-B の再定義 | ヨロズヤ/ビックカメラ/絆の前提が合わず停止＋§4 の実装範囲の見積もり（store-name-a） | [2026-09-05-stage3b-recheck-and-stage4-scope.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-stage3b-recheck-and-stage4-scope.md) | 判断待ち。3件とも実測が指示の前提と違う／§4 は発番のやり直しが本体（26/27でIDが変わる） | 確認中 |
| 2026-09-05 | 段3-B の残り＋段4 の材料 | ヨロズヤの統合＋発番が素性を材料にしている8箇所の列挙（store-name-a） | [2026-09-05-yorozuya-merge-and-id-materials.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-yorozuya-merge-and-id-materials.md) | 判断待ち（PR #1301）。発番は4つでなく8つ・素性に依らないのは evidence_id だけ・転送は evt_ にしかない | 確認中 |
| 2026-09-05 | 段4-1（設計） | 発番から素性を外す設計。発番と同定を分ける／凍結欄／全件は振り直さない（store-name-a） | [2026-09-05-stage4-1-id-design.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-stage4-1-id-design.md) | 判断待ち。1つだけ選ぶなら frozen_event_id 欄で大半が解決／lot_key はIDと独立 | 確認中 |
| 2026-09-05 | 段4-2（測定）＋③の設計 | ①は採らない（候補が1.6〜1.9倍に増える）／③は identity_keys 方式を提案（store-name-a） | [2026-09-05-stage4-2-measure-and-design.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-stage4-2-measure-and-design.md) | 判断待ち。ci の控え9件はいま2件／転送191は素性ベースが1000件規模の二重発番を防いでいる証拠 | 確認中 |

上の3件は、報告置き場を作る前のやりとり。**本文をファイルにする運用はここから始める**ため、
遡っての本文作成は行わない（2026-09-04 決定）。以降の報告は必ず本文をファイルに残す。
第1区切りは事前集計と実装で報告が別なので、行を2つに分けてある（事前集計の行は実装が
終わったので `完了`）。

## 列の意味

| 列 | 書くこと |
| 2026-09-05 | 段4-3（③の実装） | identity_keys の実装・1,736件の移行・docs/renaming-procedure.md（store-name-a） | [2026-09-05-identity-keys.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-identity-keys.md) | 判断待ち（PR #1305）。identity_keys だけでは繋がらず別名を同定に使う形へ訂正／版は上げていない | 確認中 |
| --- | --- |
| 2026-09-05 | §4（別名の整備） | 統合2件＋表の鍵1件＋別名3件。手順書の4点を確認（store-name-a） | [2026-09-05-stage4-aliases.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-stage4-aliases.md) | 判断待ち（PR #1306）。「15本」はこちらの測定では8本／バンビ本郷店は方向が決まらず保留 | 確認中 |
| 日付 | 報告した日（JST）。ファイル名の日付と揃える。**あとから追記した日が違うときは併記する**（例: `2026-09-04（追記 09-05）`） |
| 2026-09-05 | §4 の続き | 別名3件が防御に当たり保留／CARDBOX は 25件の正規化の食い違い（store-name-a） | [2026-09-05-cardbox-and-bracket.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-cardbox-and-bracket.md) | 判断待ち（PR #1306）。EI.norm は【】を落とし tenant_key は落とさない／force push の報告あり | 確認中 |
| 区切り/依頼名 | どの区切り・どの依頼への報告か（例: 監査 / 第1区切り / 公式X登録） |
| 2026-09-05 | tenant_key の括弧 | 権限の鍵でも括弧を落とす（Python と JS を同じPRで）＋設計書 §11-1-1（store-name-a） | [2026-09-05-tenant-key-brackets.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-tenant-key-brackets.md) | 判断待ち（PR #1308）。引き先が変わった鍵0・衝突2のまま・応募回 993→994 | 確認中 |
| 指示の要点 | レビュー担当から受けた指示を1行に縮めたもの |
| 2026-09-05 | 別名の防御の緩和 | 括弧・肩書き・ブランド綴りの3方向へ緩め、通す／止めるを試験で固定（store-name-a） | [2026-09-05-alias-guard-relax.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-alias-guard-relax.md) | 判断待ち（PR #1309）。語は落とさない／ヒアドキュメントの罠を docs へ | 確認中 |
| 報告ファイル | **必ず絶対URLで書く**（下記）。置き場を作る前の報告だけ「本文なし（チャットのみ）」 |
| 2026-09-05（追記 09-05） | §4 の仕上げ | 別名3件を足す。§4 の最初の区切り完了（store-name-a） | [2026-09-05-aliases-3.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-aliases-3.md) | 完了（PR #1310 マージ `985b9626`）。段1〜§4 で16本。main の基準は gh workflow run へ切り替え済み | 完了 |
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
| 2026-09-05 | まとめの発見と値の分離（D1・L） | 336回の実地確認（無作為20件）／案Aで入らなくなる回の模擬／is_official_source からまとめを外す再測定 | [2026-09-05-roundup-discovery-values.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-roundup-discovery-values.md) | §3 は別PRで先に／案Aは保留（画像の締切が先）／照合4つ実施／(i)(ii) を測る（2026-09-05） | 完了 |
| 2026-09-05 | まとめの発見と値の分離（D1・L）・判断への返答 | §3＋照合4つの PR #1299／(i) t.co 展開の実測／(ii) Haiku に画像を読ませる試験（10件・$0.116） | [2026-09-05-image-deadline-probe.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-image-deadline-probe.md) | (i) は採らず (ii) を採る／a〜d 着手／案A は a〜c の後／枝は削除（2026-09-05） | 完了 |
| 2026-09-05（追記 同日夕） | まとめの発見と値の分離（D1・L）・a〜d 実装 | 画像を材料レーンへ通す a〜d の PR #1303／#1299 の CI は main と同じ赤／V5 確定率の「前」の基準 | [2026-09-05-image-lane-impl.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-image-lane-impl.md) | #1299 `bc556d59`・#1303 `2bf27515` ともマージ／PROMPT_COMPAT 11 承認／次は数日後の「後」の測定 | 完了 |
| 2026-09-05（追記 同日夜） | T（通過率の計測）の実装: 設計から（セッション metrics） | 既存の記録を部品記号へ対応づけて棚卸し／§10-1 を満たす記録の設計（1関数・1置き場・1 run 1ファイル・§10-2 の判定5つ）／所要とサイズの見積もり | [2026-09-05-passrate-metrics-design.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-passrate-metrics-design.md) | 判断待ち（v14 §0/§10 をリポジトリの設計書へ入れるか／check_collection を置き換えるか）。追記: 数字の時点を明記（ファイルは 62efe3a4〜9899268c で同一・API は 17:00〜17:40 JST） | 判断待ち |
| 2026-09-05 | まとめの発見と値の分離（D1・L）・手動 V5 | 画像の補充を手動3走行（286→2）→ V5 を1回（10回・$0.18）→ 同じ10回の前後 | [2026-09-05-v5-manual-run.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-v5-manual-run.md) | 画像の道が効いた／補充の配線は翌朝の N を見て／追加走行2〜3回承認（plan の順序を確認してから）／控えの赤は記録（2026-09-05） | 完了 |
| 2026-09-05 | T の実装・段1（セッション metrics） | 判断の実装: #1311（止めた4ソースを見張りから外す）／#1312（passrate.py・P と S2・持ち帰り6件・設計書 §0/§10）。CI の赤は main 由来のみ | [2026-09-05-passrate-stage1.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-passrate-stage1.md) | 判断待ち（マージは本人操作。マージ後に持ち帰りを確認して追記） | 判断待ち |
| 2026-09-05 | まとめの発見と値の分離（D1・L）・追加走行 | plan の並び替え（#1313）→ 追加走行3回（32回・$0.57）→ 前が missing の回の前後（画像あり 11/22・画像なし 0/11） | [2026-09-05-v5-extra-runs.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-05-v5-extra-runs.md) | 判断待ち | 確認中 |
