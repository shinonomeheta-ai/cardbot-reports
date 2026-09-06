# T（通過率の計測）段4の実装: PR #1338（check を health-watch へ配線・check_collection を外す・本番デプロイの見張り）— T の完成

セッション名: metrics
日付: 2026-09-06（JST・08:40 時点）
区切り/依頼名: T の実装・段4 ＋ 本番デプロイの見張り（Vercel）
対象: `origin/main`（M2 段2 0bf44d11 まで）を取り込んだ枝 `feat/passrate-stage4`（head eadb700a）。専用 worktree で作業し、共有の作業ツリーは触っていない。

## 受けた指示（原文）

> 全部揃ったら段4（check を health-watch へ配線、check_collection を外す）へ。
> 段4が入れば T は完成です。
>
> 持ち帰りは明朝 08:10 まで揃わないので、段4の push はそれからで構いません。
> V5 の手起動は roundup に頼んであります。

> 本番デプロイが #1324 以降4本続けて ERROR で、サイトの更新が止まっていました。
> x-intake が /api/xread の 404 から見つけました。
>
> T の段4に「Vercel の production デプロイが ERROR なら鳴らす」を足せますか。
> GitHub API か Vercel API で、直近のデプロイの状態を取る形で。
> プレビューは READY でも本番だけ ERROR という形は、PR の CI では捕まりません。

> x-intake から補足: 本番デプロイの見張りは health-watch（GitHub 側）に置いてください。
> Vercel の /api/watch から見ると、Vercel 自身が落ちたときに鳴りません。
>
> Vercel API で production の最新デプロイの state を取り、ERROR が続いたら鳴らす形で。
> 「前のデプロイが残るのでサイトは動いたまま古くなる」ことも通知の文面に。

## 指示と過去の報告の食い違い

なし。

## 報告

### 0. 出した PR

[#1338](https://github.com/shinonomeheta-ai/cardbot/pull/1338) `feat/passrate-stage4`（head eadb700a）— CI 待ち。マージされれば **T（§0 の全部品の記録 → 日次 → 判定 → 通知）が一そろい**。

### 1. 段3の持ち帰り（全部確認）

| 部品 | コミット | 備考 |
|---|---|---|
| D1/cardchusen・D1/meli_melo・D1/evidence・L・V3/official_url | 6b9c07de・3c0e2169（nyuka-watch full） | 09-05 夜 |
| D1/xweb | 23a188c0（official-x-web-discovery 33974301383） | 09-06 00:27 |
| N・N2・S2（経路つき）・L | b62b0d08（official-x-intake 33997497978・Vercel 起動 08:00） | 23:10 の cron は保険の guard だけ（本命が動いていれば intake は skip） |
| S1 | 7e4f86ef（ec-lottery-watch 34000625133） | **#1329 の後は push が通った** |
| S1/ai_read・V4/seed | be390159（ai-read 34002418302） | |
| V5 | 未 | roundup の手起動待ち。許可リストは #1320 で前置き一致にしてある |

### 2. T が今朝示していること（記録から読めたこと）

- **S2: 開けた 30・投稿 0・`route:render` 30・stopped_early。** 埋め込みタイムラインが全滅して描画に落ち、描画でも 0 件——X 側に塞がれている（x-intake が Vercel 読み役に分ける理由そのもの）。投稿 0 だと判定①の下限に届かず黙るので、**判定①'「開けたのに投稿0」**を足した（経路の内訳つき）。
- **N2: 公式X表 1,400 行 → 引ける鍵 1,359・衝突 9・索引に載らない 32。** #1299 の前は 66% が引けなかったが、いまは 97%。⑤の材料が毎回残る。
- **D1/evidence: 40 店 → 登録 0（別の店 22・複数 10・使い回し 5・表示名不一致 3）。** 登録しないのが正しい回。判定①がここで鳴ったので、**出力0が設計上ふつうな部品**を明示して外した（`ZERO_EXEMPT`＝S2・D1/evidence・H1）。

### 3. 段4で入れたもの

**配線**: health-watch（JST 10:10 / 22:10）の「Check collection」→「Check passrate」（`python passrate.py check`）。`check_collection.py` は削除（狼少年）。通知は `alert_incident`（`workflow=passrate / job=<部品>`）で障害単位に1回・12時間ごとの再通知・直ったら復旧を1回。段階 `passrate` を STAGES へ（見出し「通過率に異常があります」）。週1の生存確認は KV。update-data が `passrate.py --write` で日次表を書いて持ち帰る。

**判定（§10-2）— 実データで回してから配線した**

| 判定 | 内容 | 実データで直したこと |
|---|---|---|
| ① 通過率0 | 24h の全 run で in≥10・出力0かつ保留0 | H1 が毎回当たった → held を見る。出力0が設計上ふつうな部品を外す（`ZERO_EXEMPT`） |
| ①' S2 が開けたのに投稿0 | opened≥10・投稿0（再適用の行は除く） | 今朝の実データ（上の 2） |
| ② 配線切れ | 期待表の部品の行が無い | **緑で走った（GitHub の実行履歴）のに行が1つも無い**は問題として鳴らす（成果ごと消えた型＝09-05 の ec-lottery-watch）。走っていない／分からないは弱い合図 |
| ③ 前日比の急変 | ±30pt／1/3・3倍（flow は完全な2日） | — |
| ④ 保留の増加 | H1 が3日連続増・3日前比 +20% | — |
| ⑤ 引けない表 | N2 の表が +10 なのに引けた数が伸びない | N2 の held を埋めて mismatch の印を消した |
| ⑥ **本番デプロイ** | **`VERCEL_TOKEN` があれば Vercel API**（`v6/deployments?target=production`）、無ければ GitHub Deployments API。決着した直近が failure/error なら「本番デプロイが失敗しています（Vercel・N本連続）」。pending は飛ばす・CANCELED は決着に数えない。文面に「**前のデプロイが残るのでサイトは動いたまま古くなる**」 | 見張りは **GitHub 側**（x-intake 補足）。実 API で確認: 直近 success 2本・その前 failure 2本（f88ceb2e・23a188c0）→ いまは問題なし。#1324 直後なら「2本連続」で鳴る形 |

いまの実データ（08:30 JST）で `check --report` → **問題なし**。弱い合図は audit-dates / candidate-ai-review / promote-now / resolve-dates に直近24時間の行が無い（走っていないだけ）。

### 4. 本人に設定してもらうもの（任意）

Vercel API を使うには Actions の secret **`VERCEL_TOKEN`**（読み取りだけで可）。任意で vars `VERCEL_PROJECT_ID`（既定 `cardbot`）・`VERCEL_TEAM_SLUG`（既定 `shinonome-hema-s-projects`）。未設定でも GitHub Deployments API の fallback で動く。

### 5. 確認したこと

- 関連 16 モジュール 241 tests OK（段4の新規 16 件）。全件は実行中（結果は追記）。
- `passrate.py check --report`・`production_deploys()` を実データ・実 API で確認。
- 最新 main（M2 段2の `N/product`・#1329・#1326）を取り込み済み。update-data.yml の add 行が M2 と競合したので両方を残して解決。

## マージと初回の動作（2026-09-06 11:50 JST・追記）

- #1338 は 11:34 JST にマージ（5911450a）。**T が一そろい。**
- CI（head 566c55ea）: vocab 緑。python test の赤3件（`test_lottery_overrides` 2件・`test_url_candidate.実データ`）は現在の main（5911450a）で同じ3件が赤（detached worktree で実測）。web build の赤1件は `api/v1/lotteries/e2e` の重複ID（前日と同じ・配布データ側）。**PR 由来の赤なし**（7,495 tests）。
- 10:10 の定時はマージ前の main で走っていたので、health-watch を **`report=true`（鳴らさない）で手起動**（run 34006929324）。`Check passrate` は動き、出力は次の1件と弱い合図4つ:

  ```
  !! candidate-ai-review: 緑で走ったのに通過率の行が1つもありません
     直近24時間に緑の run が 17 回。成果が push されていない（…）か、記録の配線が切れている
   ! audit-dates / promote-now / resolve-dates / update-data: 直近24時間に通過率の行が1つもありません（走っていないか配線切れ）
  ```

  **上の1件は誤報**: candidate-ai-review は submit / attempt / reconcile の engine で17回緑・collect は0回（V5 の行は collect でしか出ない）。成果が消えたのではない。→ [#1340](https://github.com/shinonomeheta-ai/cardbot/pull/1340) で `SOFT_EXPECTED`（記録する engine が限られる workflow）を足し、弱い合図に留める。**22:10 の定時（通知あり）の前に入れたい。**
  弱い合図4つは実態どおり（update-data は 09-04 から データ契約で落ちていて行が出ない・ほかは走っていない）。
- 手元の全件試験はメモリ不足で止められた。全件は CI で見た。

**初回で誤報が1件、実データで直した誤報が3件（H1・D1/evidence・S2）。** 判定は「実データで回してから配線」で減らせたが、workflow の性質（engine で書く部品が変わる）は実データの run が無いと見えなかった。

## V5 の持ち帰り（2026-09-06 12:20 JST・追記）— 段3の持ち帰りはこれで全部

roundup の手起動 collect 2回が candidate-ai-review のコミット e88d1dc6・7c4e30af で入った（`data_push.py --ai` の前置き一致が効いた）。roundup の表と同じ欄がそのまま出ている:

```
batch 1  in=11 ok=11  before_end_missing=11 (画像あり 8)  end_filled_from_missing=0            note_mentions_image=6  status: insufficient 11
batch 2  in=11 ok=11  before_end_missing=10 (画像あり 5)  end_filled_from_missing=2 (画像あり 2) obs_end=3 obs_result=3  note_mentions_image=4  status: insufficient 8・conflict 1・likely_valid 2
```

「前が missing → 後に締切が入った」2回はどちらも画像あり（roundup の 09-05 の測定「画像なしは 0/11」と同じ向き）。以後、`history/passrate_daily.json` の V5 を日で合計すれば「後」の測定になる。

update-data も通り（7fb431a0・09-04 から落ち続けていた run が成功）、D1/registry・N/product（M2）と日次表 `history/passrate_daily.json`（26 部品）が main に入った。

## 追記（2026-09-06 12:40 JST）

- **#1340（初回の誤報の修正）は本人操作でマージ済み**（12:0x）。22:10 の定時から実通知。
- §10 の「T の完成」の表（566c55ea）は、#1338 のマージ（11:34・head eadb700a）の直後に push したため main に入っていなかった。本人指示の「本番デプロイ4本 ERROR」の段落と合わせて docs PR [#1345](https://github.com/shinonomeheta-ai/cardbot/pull/1345) にした（docs のみ）。
- **作業上の事故（push 前に戻した）**: 手順の鎖の先頭の `cd`（専用 worktree）が、worktree のディレクトリが別の掃除で消えていて失敗し、続く `git add` / `commit` が共有の作業ツリー D:\cardbot の main で走った。別セッションの staged 変更 1,372 ファイルごとコミットされたが、**push はしておらず**、`git reset --soft HEAD~1` で index と作業ツリーを元の状態に戻した（HEAD 81231543・staged 1,372 件を確認）。設計書1ファイルの index だけは私の add の影響が残りうる。以後、鎖の先頭は `cd … || exit 1`、git は `git -C <絶対パス>`、worktree は使う前に存在を確かめる（記憶に追記）。

## 運用の見張り 1日目・昼（2026-09-06 12:50 JST・追記）

- **①'（S2 が開けたのに投稿0）は消えた。** x-intake の KV 経路が入った run（official-x-intake 34008887469・12:34）の S2 は 開けた 440・投稿 1,493・`route:kv` 438・`route:render` 2（`route_posts:render` 0）。朝の run（開けた 30・投稿 0・render 30）と並べると、経路ごとの件数で X 側に塞がれた状態と読む役への切替が数字で見える。
- **③（前日比の急変）が L と P で誤報**: `L: 83% → 30%`・`P: 92% → 44%`。実態は、日次表の「その日の最後の run」が母集団の違う段を混ぜていた（P: fast 段 ≈300 行 92%／full 段 ≈650 行 44%、L: nyuka-watch 84%／official-x-intake 30%）。→ [#1347](https://github.com/shinonomeheta-ai/cardbot/pull/1347)（snapshot は (部品, workflow, 段) ごとの最後の行で比べる）。直したあとの実データは問題なし（弱い合図は走っていない3本のみ）。**22:10 の定時の前に入れたい。**
- ここまでの誤報の型: 出力0が設計上ふつう（H1・D1/evidence・S2）／記録する engine が限られる（candidate-ai-review）／段で母集団が違う（P・L）。いずれも「実データで回して見つけ、部品の性質として明示する」形で直した。しきい値そのものは触っていない。

## 根拠データ

- [2026-09-05-swallowed-push.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-swallowed-push.json) — 前日の持ち帰りの状態と握り潰しの実測（今朝の持ち帰りは上の表・コミットで辿れる）

## 状態

#1338・#1340 マージ済み（T の完成）。#1345 マージ済み。#1347（③の誤報）は判断待ち。マージ後の health-watch（JST 10:10 か手起動）で `Check passrate` が動くのを見て追記する。初回は「緑で走ったのに行が無い」が段3以前の run に当たって鳴る可能性がある（24時間で消える）。V5 は上の追記のとおり確認済み。

## 運用の見張り・追記（2026-09-06 15:50 JST・手起動の Check passrate）

本人指示で 22:10 を待たず health-watch を手起動した（run [34017122759](https://github.com/shinonomeheta-ai/cardbot/actions/runs/34017122759)・15:41 JST）。今日の 3 枠（08:00 render 30 店・投稿 0／12:34 kv 438・投稿 1,493・告知 68／14:11 kv 439・投稿 1,471・告知 55）を含む行での判定:

| 判定 | 結果 | 読み |
|---|---|---|
| ①'（S2 開けたのに投稿 0） | **消えた** | 12:34・14:11 の枠が KV 経路で投稿を取っている。08:00 の render 30・投稿 0 は 24 時間の中に残るが、①' は「全 run で 0」なので鳴らない |
| ③（前日比・snapshot は同じ workflow・同じ段） | **鳴った（L・P の nyuka-watch/full）** | **誤報ではない。** 15:35 の full 段（heartbeat 起動・run 34016772027）で `cardchusen.com` の 3 URL が **timed out**（該当 0 件・既存を保持）→ 候補台帳の入力が 500 → 146、配布の入力が 658 → 310 に縮み、L 83%→45%・P 45%→97% に見えた。**収集元 1 つの時間切れで full 段の母集団が 1/4 になった**のを T が捕まえた形。Discord へ L と P の 2 件（障害として開いた） |
| ②（配線切れ・弱い合図） | audit-dates・promote-now・resolve-dates が 24 時間走っていない | これまでどおり（cron の間引き・run が無い）。問題ではない |
| H2 の弱い合図 | H2（nyuka-watch/full）17% → 53% | 母集団が小さい（前回の保留 12〜30 回）。弱い合図のまま |
| ⑥（本番デプロイ） | 鳴らず | 直近の Production は READY |

**次の 22:10 の見込み**: 15:36 に別セッションが手起動した full 段（run 34016916399）は cardchusen が通常どおり（+363・配布 668 → 304）で、その行が今日の最後の full の行になったので、L・P は**復旧**として閉じる（最新 main fb91d6ff の行で `check --report` を回し、残るのは弱い合図 3 件だけを確認済み）。

**T が拾った別の実害（metrics の領分ではないので直さない・報告のみ）**: nyuka-watch の full 段で `fill_round_methods.py` が毎回 Traceback（`candidate_ledger.台帳が読めない: cevt_8abee801a8550fa6 が壊れています（保存を中止）`）。14:41・15:35・15:36 の 3 run とも。F/methods の行は書かれているが（record が save の前）、規則で埋めた応募方法・受取方法は**保存されていない**。候補台帳の 1 件が壊れている型（`candidate_ledger.validate`）。

**しきい値について**: ③ が「収集元の時間切れ」を捕まえたのは正しい動きなので、上げない。ただし文面は「前日比が急変」より「full 段の入力が 1/4（cardchusen 該当 0 件）」のほうが早く読めるので、**S4（まとめ収集）の行に取得失敗の数を残す**のを次の候補に置く（今日は S4 の行が無い＝まとめ収集は S4 として記録されていない）。

**#1352（店の次元）**: CI の赤は main の基準（run 34014450590・d72e541e）と同じ 5 本で PR 固有の赤なし → **マージ済み（fb91d6ff・15:47 JST・自分で）**。最初のチェーン別の日次は次の update-data の `--write` で `history/passrate/m1g/2026-09-06.json` に出る。15:40 の full 段の行はマージ前の code なので `extra.m1g` はまだ無い。

## 運用の見張り・追記（2026-09-06 23:05 JST・22:10 の枠）

22:10 の schedule の run は 23:00 になっても起きなかった（GitHub の cron 遅延・candidate-ai-daily の 21:40 と同じ型）ので手起動した（run [34037840125](https://github.com/shinonomeheta-ai/cardbot/actions/runs/34037840125)・23:01 JST）。#1352（店の次元）と #1368（判定②'・⑦）のマージ後、最初の Check passrate。

| 判定 | 結果 | 読み |
|---|---|---|
| ②'（押せなかった run） | **3 件が障害として開いた**（Discord に 3 通）: update-data/push（4 run: `Push` 拒否 1・契約 3）・nyuka-watch/push（4 run: 漏洩検査）・audit-dates/push（1 run: 漏洩検査） | 見込みどおり。どれも成果は main に載っていない run。24 時間で古い run が外れ、新しい push 失敗が無ければ復旧として閉じる。漏洩検査で落ちる nyuka-watch 4 件は ci の領分 |
| ③（15:41 に開いた L・P） | **復旧を知らせた（L・P）** | 15:36 の正常な full 段が今日の最後の行になり、閉じた。cardchusen の時間切れは一過性 |
| ⑦（行の主張と実物） | P・H1・N2 は一致。**L は弱い合図**: 行（22:37）より新しいコミット「ec-lottery-watch update」が候補台帳を書いている（主張 2342・実物 2345） | 設計どおり黙った。ec-lottery-watch と ai-read は候補台帳を書くが L の行は書かない書き手（S1 を書く）なので、この弱い合図は**毎回出る**。次の候補: `LANDED` に「その台帳を書くが行を書かない書き手」を持たせて、その書き手のコミットなら合図も出さない |
| ①'・⑥ | 鳴らず | KV 経路で投稿が取れている／本番デプロイは READY |
| 弱い合図 | audit-dates・promote-now・resolve-dates の行なし（24 時間走っていない）／H2（nyuka-watch/fast）29% → 65% | これまでどおり。H2 は母集団が小さい |

M1g のチェーン別（`history/passrate/m1g/2026-09-06.json`）は次の update-data の `--write` で出る（この時点ではまだ無い。update-data は 17:58 以降走っていない）。

## 運用の見張り・追記（2026-09-07 00:40 JST・遅れて発火した 22:10 の schedule）

22:10 の schedule は 01:11 JST に発火した（run [34044669744](https://github.com/shinonomeheta-ai/cardbot/actions/runs/34044669744)・3 時間遅れ）。日付をまたいだので判定③の「完全な 2 日」が 09-05 対 09-06 になり、**flow の 7 部品が誤報した**。

| 判定 | 結果 | 読み |
|---|---|---|
| ③（flow・完全な 2 日） | **誤報 7 件**（Discord に 7 通）: D1/cardchusen 2,080 → 18,444・D1/evidence 120 → 1,531・D1/meli_melo 33 → 330・F 2,273 → 14,531・F/methods 16,760 → 107,768・F/receive・L2 27,511 → 187,004 | flow の日次は run の合計。09-05 は段2・3 の記録初日（3〜8 run）、09-06 は手動 run が多く 33〜48 run（L2 は 68 → 502 run）。**run あたりは 693 → 558・284 → 302・2,095 → 2,245・404 → 372 で平坦。** 部品の性質として直した: 件数は `in / runs` で比べ、記録初日は基準にしない（PR [#1378](https://github.com/shinonomeheta-ai/cardbot/pull/1378)・しきい値は変えない）。マージ後の次の check で 7 件は復旧として閉じる |
| ②' | update-data/push は継続（3 run・1 つが 24 時間で外れた）。**nyuka-watch/push・audit-dates/push は復旧**（新しい push 失敗が無い） | 見込みどおり |
| ⑦ | 一致（L の弱い合図も消えた） | — |
| 弱い合図 | audit-dates・promote-now・resolve-dates の行なし／H2（nyuka-watch/fast）29% → 65% | 従来どおり |

**読み**: ③ の flow の比較は「日次の合計」を前提にしていたが、合計は run の回数の関数だった。今日のように手動 run が 5 倍になる日は毎回鳴る。実データで見つかった誤報はこれで 5 種類目（H1 held・D1/evidence と S2 の出力 0・candidate-ai-review の期待・snapshot の段・flow の run 回数）。**どれもしきい値でなく部品の性質で直した。**
