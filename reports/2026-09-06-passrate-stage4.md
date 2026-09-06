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

## 根拠データ

- [2026-09-05-swallowed-push.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-05-swallowed-push.json) — 前日の持ち帰りの状態と握り潰しの実測（今朝の持ち帰りは上の表・コミットで辿れる）

## 状態

CI 待ち（#1338）。マージは本人操作。マージ後の health-watch（JST 10:10 か手起動）で `Check passrate` が動くのを見て追記する。初回は「緑で走ったのに行が無い」が段3以前の run に当たって鳴る可能性がある（24時間で消える）。V5 は roundup の手起動後に追記。
