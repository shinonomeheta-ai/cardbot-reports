# T の穴: 「押した成果が main に載ったか」を見る設計（判定②'・⑦）

セッション名: metrics
日付: 2026-09-06（JST・18:40 時点）
区切り/依頼名: 「押した成果が main に載ったか」を T で見る形を設計する（急ぎ）
対象: `passrate.py check`（health-watch）・update-data ほか push する workflow 10 本

## 受けた指示（原文）

> T に穴があります。
>
> update-data で push が rejected になり、promote が作った336行が丸ごと消えていました。
> T の P の記録には「配る317・落とす19」と残るのに、その317行が main に載ったかは
> 記録していません。だから判定にも当たらず、Discord にも鳴りませんでした。
>
> 「押した成果が main に載ったか」を T で見る形を設計してください。
>
> 案:
> - 各 workflow の最後に「push が成功したか」を記録する
> - 記録した行数と、実際に main に載った行数を比べる
> - 差があれば異常として鳴らす
>
> これは判定②（緑で走ったのに行が無い）の変種で、
> 「行はあるが main に載っていない」ケースです。
>
> 急ぎです。今日の15店で止まっていた理由の一部がこれでした。

## 指示と過去の報告の食い違い

1 つ、事実の補足。「T の P の記録には残る」の P の行（配る 317）は **main には載っていない**（run のログの表にだけある。`history/passrate/2026-09-06/update-data-34023341557.jsonl` は main に無い）。この事故は「行はあるが main に載っていない」ではなく、**「run が赤で、行も成果も丸ごと載っていない」**型。T は赤の run を見ない（判定②は**緑**の run だけ数える）ので沈黙した。「行はあるが載っていない」型（rebase の `-X theirs` が中身を捨てる）は別に存在するので、設計は両方を塞ぐ。

## 報告

### 0. 結論を先に

- **穴は 2 つ。** (a) **押せなかった run** — 赤で終わり、成果も T の行も main に載らない。T は緑の run しか見ないので沈黙（今日の 16:03・17:58 の update-data）。(b) **押せたが中身が捨てられた run** — rebase の `-X theirs` や競合で古い中身が残り、run は緑・行は載る。T の行の数と main の中身が食い違う。
- **押した成果を T の行に記録する形は取れない。** 行は git で持ち帰るので、push が失敗した回の行は main に届かない（記録が事故と一緒に消える）。正本は **GitHub の run（jobs API の step の結末）** と **main のファイルそのもの**にある。T はその 2 つを読む。
- 設計は 3 層。**A・B は T の側（`passrate.check`・health-watch）で今日入れられる**。C は workflow の側（ci の領分）。

| 層 | 何を見る | 塞ぐ穴 | 誰が |
|---|---|---|---|
| **A 判定②'** | 期待表の workflow の**赤の run**のうち、落ちた step が push 段（Rebase／契約(push直前)／漏洩検査／Push／Commit artifacts）なら「成果が main に載っていない」として鳴らす | (a) | metrics・PR 今日 |
| **B 判定⑦** | 最後の行の**主張**と main の**実物**を突き合わせる: P の `out` ＝ `lotteries.json` の行数、L の `extra.rounds` ＝候補台帳の応募回数、N2 の `table_rows` ＝公式X表の行数 | (b) | metrics・PR 今日 |
| **C push の耐性** | Push が non-fast-forward で拒否されたら**1 回だけ**取り込み直して押し直す（rebase → 影の作り直し → 契約 → push）。それでも駄目なら lost-commit artifact（#1329 の型）＋ `alert_incident` を **`job=<workflow>:push`** で別建てに鳴らす | (a) の発生自体 | ci（update-data.yml ほか）|

### 1. 今日の事故（事実）

| run | 起動 | 落ちた step | 何が消えたか |
|---|---|---|---|
| [34018113050](https://github.com/shinonomeheta-ai/cardbot/actions/runs/34018113050)（16:03 JST） | 手動 | データ契約（push直前） | promote 327 行→配る 306・T の行 |
| [34023341557](https://github.com/shinonomeheta-ai/cardbot/actions/runs/34023341557)（17:58 JST） | 手動 | **Push**: `! [rejected] main -> main (fetch first)` | promote 336 行→配る 317・T の行 |

17:58 の形: `Rebase onto latest main` の step のあと、`Rebuild shadows after rebase`・契約・漏洩検査（合わせて数分）の間に nyuka-watch の push（18:0x）が main に入り、`git push` が non-fast-forward で拒否。**Push は 1 回きりで再試行が無い**（`run: git push`）。update-data には `if: failure()` の `alert_incident failure` があるが、16:03 の赤で障害が開いた後なので 17:58 は「継続」＝再通知は 12 時間後（Discord に新しい通知が出なかったのはこのため——障害の単位が workflow なので、原因が変わっても 1 件に畳まれる）。

promote の行は次の成功した run（nyuka-watch 18:08 の full 段）で作り直されて main に 317 行あるので、**失ったのはデータではなく時間（16:03〜18:08 の 2 時間、配布が古いまま）**。今日の 15 店の遅れの一部はこれ。

### 2. なぜ「行に push の結果を書く」では駄目か

T の行は `history/passrate/` を git で持ち帰る。push が失敗した回は行も届かない。**記録が事故と運命を共にする**——「持ち帰れない記録は無いのと同じ」（§10 の前提）そのもの。KV に書く手もあるが、書き手が 10 workflow に散り、書き忘れた workflow が穴になる（今日の型の再発）。GitHub は run の結末と step の結末を**既に持っている**ので、T はそれを読む（A）。main の中身も既にある（B）。**新しい記録を増やさず、既にある 2 つの正本を読む**のがこの設計。

### 3. A 判定②'（押せなかった run）

`passrate.check` に `failed_push_runs_last_day(workflow)` を足す。`successful_runs_last_day` と同じ GitHub API（`actions/runs` → `conclusion=failure` → `jobs` の steps）。

- 対象: 期待表の workflow（10 本）。直近 24 時間の赤の run。
- 「push 段」の step 名は 1 つの表で持つ: `Rebase onto latest main` / `Rebuild shadows after rebase` / `データ契約（push直前）` / `データ契約（push の前）` / `収集元名の漏洩検査（push直前・fail-closed）` / `Push` / `Commit artifacts` / `Commit intake artifacts` / `Commit AI artifacts` / `Commit resolved dates` / `Commit audit results` / `Keep the lost commit`。**試験が workflow の実物と突き合わせる**（名前が変わったら赤）。
- 鳴らし方: `problems` に `(part=<workflow>/push, "…の成果が main に載っていない（run <id>・step <name>）", "run を開いて落ちた理由を見る。次の成功した run で作り直される部品（P・L・V7）は時間の損、作り直されない部品（S1・S2 の告知・V5 の答え）はデータの損")`。`alert_incident` は `workflow=passrate / job=<workflow>/push` で **workflow 自身の障害とは別建て**——update-data の障害が開いていても、push の失敗は別の 1 件として鳴る。
- 赤の run のうち push 段**より前**で落ちたもの（収集の失敗・契約の失敗）は今までどおり workflow 自身の `alert_incident` の領分。②' は「成果はできていたのに載らなかった」だけを見る。
- 24 時間で消える（同じ run を翌日また鳴らさない）。復旧は「直近 24 時間に push 段で落ちた run が無い」。

### 4. B 判定⑦（主張と実物の突き合わせ）

snapshot の部品は「台帳全体に対する数」なので、**行の主張は main のファイルの実物と一致するはず**。health-watch は main を checkout して `check` を回すので、実物はその場にある。

| 部品 | 行の主張 | main の実物 | 書き手 |
|---|---|---|---|
| P | `out`（配る行） | `web/public/data/lotteries.json` の行数 | nyuka-watch・update-data・promote-now |
| L | `extra.rounds` | `shadow_candidates.json` の応募回数 | nyuka-watch(full)・update-data・official-x-intake・ec-lottery-watch |
| N2 | `extra.table_rows` | `store_x_accounts.json` の行数 | official-x-intake |
| H1 | `in`（保留の総数） | `publish_verdicts.json` の dropped 数 | P と同じ |

判定: **最後の行**（workflow を問わず一番新しい）の主張 ≠ 実物 → `problems`（`part=<部品>/landed`）「行はあるが main に載っていない（主張 317・実物 281。rebase で捨てられた型）」。差が 0 でなければ鳴らす（同じ台帳を最後に書いた run の数は一致するはずで、しきい値は要らない）。ただし**最後の行より新しいコミットが main にある**とき（別の書き手が後から書いた）は、その書き手の行が無い＝②の領分なので⑦は黙る。

主張の欄が無い部品（S1・S2 の告知など flow の部品）は⑦の対象外——flow は台帳全体の数を持たない。S2 の告知が rebase で消える型は #1268（再適用）が塞いでいる。

### 5. C push の耐性（ci の領分・提案）

update-data・nyuka-watch・resolve-dates・audit-dates・promote-now の `Push` を

```
git push || (
  git pull --rebase -X theirs --autostash origin main &&
  python3 post_rebase_rebuild.py && <契約> && git push )
```

の **1 回だけの押し直し**にする（#837 の押し直しは data_push の AI 経路にしかない）。それでも駄目なら lost-commit artifact（#1329 の型・14 日）＋ `alert_incident failure --job "<job>:push"`（別建て）。update-data は `Rebase` と `Push` の間に 3〜5 分あるので、nyuka-watch（20 分ごと＋heartbeat）と当たる確率が高い——今日は手動 run が続いて当たった。

### 6. 段取り

1. **今日**: A＋B を `passrate.py` に入れる（試験: step 名の表が workflow の実物にある／赤の run の step を読んで鳴る／主張≠実物で鳴る／新しい書き手がいれば黙る）。§10-2 に ②'・⑦ を足す。health-watch の env は既に GH_TOKEN があるので workflow は触らない。
2. ci: C（update-data.yml ほか 5 本）。
3. 1 の運用で「push 段で落ちた run」の頻度が見える。多ければ C を急ぐ。

## 根拠データ

- run [34023341557](https://github.com/shinonomeheta-ai/cardbot/actions/runs/34023341557) の Push step: `! [rejected] main -> main (fetch first)`
- run [34018113050](https://github.com/shinonomeheta-ai/cardbot/actions/runs/34018113050) の落ちた step: データ契約（push直前）
- main の `history/passrate/2026-09-06/` に `update-data-34023341557.jsonl`・`update-data-34018113050.jsonl` は無い（行も載っていない）

## 状態

設計の判断待ち（A・B は判断があり次第 PR。急ぎとのことなので実装は先に進める）。

## 実装（2026-09-06 19:15 JST・追記）

本人判断「A と B を実装。形は変えない」→ PR [#1368](https://github.com/shinonomeheta-ai/cardbot/pull/1368)（`passrate.py`・試験 14 本・§10-2）。workflow は触っていない（health-watch に GH_TOKEN が既にある）。

- **②'** `failed_push_runs_last_day(workflow)`: 赤の run（GitHub jobs API）の落ちた step が `PUSH_STEPS` に当たれば `passrate / <workflow>/push` で鳴らす。試験が step 名を workflow の実物と突き合わせる（名前が変わったら赤）。読めなければ②と同じく黙る。
- **⑦** `landed_problems`: 最後の行の主張（P `out`・H1 `in`・L `extra.rounds`・N2 `extra.table_rows`）と main の実物（`LANDED`）。新しい書き手がいれば弱い合図に留める。GitHub の `…Z` 時刻は `jst.parse` が JST と読んでしまうので、比較は `fromisoformat` で行う（試験で捕まえた）。

**実データで回した結果（鳴らさず）**: ②' は直近 24 時間で **10 run** が push 段で落ちていたのを拾った——update-data 5（`Push` 拒否 1・`データ契約（push直前）` 4）・nyuka-watch 4（`収集元名の漏洩検査（push直前・fail-closed）`）・audit-dates 1（同）。**どれも成果は main に載っていない。** 今日の型は 17:58 の 1 件ではなく、昨夜から 10 件あった。⑦ は P・H1・L が一致、N2 は別の書き手（store-x の手作業コミット）で弱い合図。

マージ後の最初の Check passrate（22:10）で ②' の 3 件（update-data／nyuka-watch／audit-dates の `/push`）が障害として開く見込み。24 時間で古い run は外れ、新しい push 失敗が無ければ復旧として閉じる。
