# 判断待ちを1枚に整理（2026-09-07 の全セッション）

日付: 2026-09-07（JST・18:00 時点）
区切り/依頼名: 判断待ちの整理（セッション docs）

## 受けた指示（原文）

> 「判断待ち5件を1枚に整理」をやってください。
> 今日、複数のセッションから判断待ちが出ていて、私が追いきれていない可能性がある。
> 各セッションの報告から「判断待ち」を拾って、1枚にまとめる。

## 指示と過去の報告の食い違い

「5件」ではなく、INDEX の 2026-09-07 の行で状態が「判断待ち」のものは **11 行**あった。うち 4 行はこの後の PR マージで解けているので、**残っている判断は 9 組**（下の A〜I）。件数の数え方は「INDEX の行」で、1 行に複数の問いを含むものがある。

## 報告

### 0. もう解けているもの（判断は不要）

| INDEX の行 | 何で解けたか |
|---|---|
| 設計図・設計書の版そろえ（design） | #1417 を 324d2a45 でマージ（`2026-09-07-pr1417-merge.md`） |
| 指紋の刻み直し（PR #1401・store-name-a）の「#1401 のマージ」 | #1401 マージ済み。残るのは「残り219回」（下の D） |
| 推定器の直し（PR #1408・x-intake）の「#1408 のマージ」 | #1408 マージ済み。残るのは「段1へ上げるか」（下の F） |
| workflow の叩き方の手順（PR #1411・store-name-a） | #1411 マージ済み |

### 1. 残っている判断（9 組・セッション別）

#### A. KIDDY LAND の寄せ方（store-name-a）

報告: [2026-09-07-storm-emeralda-and-kiddy-name.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-storm-emeralda-and-kiddy-name.md)

- 案あ: M1g の `extra_store_keys` に「キデイランド」を足す（数え方だけ直る・カードには出ない・規則の緩めが要る）
- 案い: 別名表で書き換える → **採れない**（応募済み・既読の鍵が動く）
- **案う（推奨）**: 「本部主体の企画は支店の回もチェーンのカードへ寄せる」をチェーンごとに宣言する欄を M1g に足し、カード側で商品ごとに畳む。案1（KIDDY LAND の出し方）と一緒に

**答え方**: あ／い／う のどれか。う なら設計案が先に出る。

#### B. D1 の続き（roundup）4 点

報告: [2026-09-07-d1-followup.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-d1-followup.md)

1. 承認の下書き 7 件＋別名 1 件（§5）を承認するか
2. カードボックス横浜西口2号店を別の店として持つか（同じ口で告知）
3. 窓から落ちた 7 店: まとめの行の投稿リンクを `--route evidence` の根拠として渡す形を作るか
4. 候補台帳の同じ店 3 組（§2）を ci の段4 へ渡すか

#### C. evidence_cache_missing 1,624 の中身（store-name-a）3 点

報告: [2026-09-07-evidence-cache-missing.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-evidence-cache-missing.md)

1. 966 は「壊れていない」で決着してよいか（名前が紛らわしいだけ）
2. 635 を直しに行くか。行くなら案A／B／C のどれか
3. 同じ語 `evidence_cache_missing` で別のもの（キャッシュ側 635／AI 側 1,624）を数えている件を直すか

#### D. V5 画像読み 117 回の結果（store-name-a）

報告: [2026-09-07-v5-images-result.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-v5-images-result.md)／[2026-09-07-fingerprint-self-invalidation.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-fingerprint-self-invalidation.md)

1. 「暫定回に締切が付いたら正式な回を起こす」→ **#1401 でマージ済み**（判断は済み）
2. **残り 219 回を回すか**（実費 $4 前後・課金）。口も指紋も直った後なので、回せば配布に届く見込み
3. 過ぎている 44 件を締切ありで正式化して「終了」として片付けるか（配布には出ない・未確認の山が減る）

#### E. LivePocket を Vercel 経由で読む（x-intake の測定 → ci の設計）

報告: [2026-09-07-shared-platforms-via-vercel.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-shared-platforms-via-vercel.md)／[2026-09-07-livepocket-vercel-read.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-livepocket-vercel-read.md)

- 測定は済み: LivePocket は Vercel から 27 回連続で読める。e-starbox は塞がれていない。Google フォームと customform は描画の問題で別課題
- 設計は本人指定を反映済み（許可表は livepocket.jp だけ・本文 32KB を運ぶ・HSET＋EXPIRE）
- **問い: 実装に着手してよいか。** キデイランド原宿店の締切が **9/8 23:58** なので、間に合わせるなら今日中の設計→実装→マージと、明朝の evidence_cache の後に AI を 1 件手で回す（$0.02 程度）ことになる

#### F. 公式X巡回の回数（x-intake）

報告: [2026-09-07-estimator-and-runs-plan.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-estimator-and-runs-plan.md)

- 発見: いまの 3回×440 は全店 1 日 1 回の下限を満たしていない
- **推奨は段1（3回×1,360）**: 取り切れる割合 50.4% → 84.8%、Actions 35 → 109 分/日、Vercel の読み取りは 3 周のまま
- 段2・段3 は 9/10 の捕捉率を見てから
- 小さい問い: Wayback の深さをさらに上げるか（30 店で 904 件が頭打ち・所要 10 分で余裕あり）

#### G. 寄せる単位は告知の主体（PR #1412・store-name-a）

報告: [2026-09-07-subject-and-pacing.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-subject-and-pacing.md)

1. 同じ応募 URL で 2 行になる件: カード側で束ねるか、このまま出すか（**急ぎではない**・該当行は締切が過ぎている）
2. 15:52 の candidate-ai-daily の run を動かした主はどのセッションか（分かれば V5 の残りはその後に）
3. #1412 自体のマージ（CI は test/build が赤。main 由来かどうかの切り分けは store-name-a 側）

#### H. 報告への追記禁止を CLAUDE.md へ（PR #1413・docs）

報告: [2026-09-07-report-no-append.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-report-no-append.md)

- **問い: #1413 を承認するか**（Vercel SUCCESS・Actions 起動なし・+11 行の文面のみ）。承認の一言で自分でマージする

#### I. 設計図 v14 の次（design）

報告: [2026-09-07-architecture-v14.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-07-architecture-v14.md)

- #1417 は済み。残る問いは「次に何をやるか」（design セッション宛）
- 付随: `.claude/CLAUDE.md` の Source of Truth がまだ v12.png を指している（2 行の PR で直せる・`2026-09-07-pr1417-merge.md` §4）

### 2. 昨日以前から残っている判断待ち（参考・件名だけ）

INDEX で状態が「判断待ち」のまま更新されていない 2026-09-05〜06 の行。多くは後続の PR で動いているが、INDEX の行が直っていない可能性がある（各セッションが自分の行を見直す対象）。

- 2026-09-06: 合流が畳んだ先を同一店と読めない型（案1〜4・#1333）／昼の枠で取れた告知の中身／公式X未登録 3 店と新正解表 6 店／roundup からの 2 件の設計／障害対応・締切が今日の店を画面へ／ゴールデンチェーン 54 件の裏取り（§2 の裁定）／捕捉率の測り直しと Vercel のビルド費用／LivePocket 主催者ページの登録の裏取り A/B/C
- 2026-09-05: T の設計（v14 §0/§10 を設計書へ入れるか）／公式X巡回の回復判定と案c／案イ-2＋案E＋素性の被り／段3-B の準備（判断 1〜11）／PR #1241 のレビュー／M1g 第2段・第3段（#1324・#1325）／M2 の判断①〜⑥／update-data の連続失敗（#1330→#1327）／M1g 前提の直し（#1331）／M1g「カードはオンラインの店だけ」（判断 A〜C）
- backlog.json の「判断待ち」6 件: #13 cardchusen 規約第5条・#14 B レーンの観測・#15 登録候補の共有基盤 17 件・#19 公式X未登録の M1g 3 店・#20 C ドライブの空き・#21 VERCEL_TOKEN

### 3. 早く決めると効くもの（順番の提案）

1. **E（LivePocket の実装着手）** — 9/8 23:58 の締切に間に合うかが今日の判断で決まる
2. **D-2（残り 219 回・$4）** — #1401 が入ったので、回せば配布が増える
3. **F（段1へ）** — 全店 1 日 1 回の下限が初めて成立する。Vercel を余計に叩かない
4. **H（#1413）** — 承認の一言で済む
5. A・B・C・G は設計や台帳の判断で、今日中でなくてよい

## 根拠データ

- 数え方の元は `reports/INDEX.md` の 2026-09-07 の行（18:00 時点・状態列に「判断待ち」を含む 11 行）と、PR #1401/#1408/#1411/#1412/#1413/#1417 の GitHub API の state。集計 JSON は作っていない（行数 11・PR 状態 6 件で、INDEX と GitHub がそのまま根拠）。
