# 他セッションの run を自分のものとして読んでいた（洗い直し）

2026-09-07 ／ ci

## 受けた指示（原文）

> \# 手順を直してから
>
> 「gh workflow run の直後に最新の run を自分のものと決めつける」——
> 同時に走る環境では成立しない。
> 「起動前に最新の run id を控え、それより新しく、かつ自分が渡した入力を持つ run を選ぶ」——
> この形に直してから。
>
> B は存在しない問題だった可能性が高い。私の「直してください」も、
> ci の見立てを確かめずに出した指示でした。
>
> 「今日の報告のいくつかに混ざっている可能性」——洗い直して、
> どの報告のどの数字が他 run のものだったかを、新しいファイル名で出してください。
>
> 原宿店の締切まで26時間。手順を直してから1件で通す。

---

## 1. 何をしていたか

`gh workflow run` は run id を返さない。私は起動直後に

    gh run list --workflow candidate-ai-review.yml --limit 1

で「いちばん新しい run」を取り、それを自分の run として読んでいた。

`candidate-ai-review` は 2026-09-07 07:07〜07:17 の10分間に **12回**
`workflow_dispatch` で起動されている。うち私が起動したのは3回だけで、残りは
別セッションと定期実行のもの。**この密度では最新が自分のものである保証は無い。**

    07:16:50  34094698342  failure
    07:16:16  34094653879  success
    07:15:47  34094613380  success
    07:14:29  34094501323  failure
    07:13:12  34094398576  failure   ← 私の submit
    07:12:08  34094310879  failure
    07:11:35  34094266726  success
    07:11:11  34094234158  success
    07:08:36  34094020009  failure
    07:08:30  34094012236  success
    07:07:57  34093967628  success
    07:07:33  34093938734  success

## 2. 判定のしかた

各 run のログから、`workflow_dispatch` の入力がそのまま出る環境変数
（`IN_ENGINE` / `IN_MAX_REQUESTS` / `IN_ROUND_IDS` / `IN_ATTEMPT_INTENT_ID`）を読み、
**私が渡した値と一致するか**で判定した。

## 3. 結果

| run | 実際の入力 | 私のか | 使った報告 |
| --- | --- | --- | --- |
| 34047426612 | plan / max 3 / `crnd_028b…,crnd_1eed…` | ○ | 「planned_requests 1・送れるのは1件だけ」 |
| 34047533285 | evidence_cache | ○ | 「evidence_cache 成功」 |
| 34048091237 | plan / max 3 / 同上 | ○ | 「evidence_cache 後も 1件のまま」 |
| 34048736682 | intent / max 1 / `crnd_1eed…` | ○ | 「intent_id amat_abd53d…・requests 1」 |
| 34048784265 | submit / max 1 / `crnd_1eed…` | ○ | 梅田 9/7 の有料送信（実費 $0.0157） |
| 34048913291 | collect | ○ | 「ok 1 / error 0・verify mismatch 1」 |
| 34090389018 | evidence_cache | ○ | **原宿店の抜粋 2,000字**（#1403 の効果） |
| 34090938752 | plan / max 1 / `crnd_028b…` | ○ | 「planned_requests 1・引当 $0.0955」 |
| **34091302486** | **max 20 / `crnd_ba452729db20,…`** | **×** | **「intent が11件・$1.10」** |
| 34093856542 | submit / intent `amat_58ed5c53…` | ○ | 「abandoned で止まった・課金0」 |
| **34094020009** | attempt / intent `amat_b18c67…` | **×** | 「step 9 skipped・intent 実行が走っていなかった」 |
| 34094398576 | submit / max 11 / intent `amat_b18c67…` | ○ | 「preflight で止まった・課金0」 |

nyuka-watch の手動起動は同じ日に3回だけ（`34059549247` / `34083065756` /
`34087544679`）で、いずれも私の起動と時刻が一致する。枝で回した
`34050854021`（update-data）と `34051480304`（nyuka-watch）は
`fix/event-id-order` 上で、その枝は私しか持っていない。**巡回側の数字は無事。**

## 4. 誤っていた報告

### (a) 「intent が11件・$1.10 になっている」

**その intent は私が作ったものではない。** `amat_b18c6766e37610fb` は
run 34091302486（`max 20` / `round_ids=crnd_ba452729db20,…`）が作ったもので、
私が `--round-ids crnd_028b8dd7963c --max-requests 1` で頼んだ結果ではない。

### (b) 「11件の中身」の一覧

TSUTAYA唐津店・HARUYAトレカベース西の土居店・ブックオフお宝大陸倉敷笹沖店 ほか
11件の一覧は、**その別 run の intent の中身**として正しい。ただし
「私が原宿店1件を頼んだのに11件になった」という**枠組みが誤り**だった。

### (c) 「`--round-ids` が intent に効かない」

**根拠が無い。** 私の intent 実行の結果を一度も見ていない。私の plan
（34090938752・`max 1` / 原宿店）は `planned_requests: 1` を返しており、
`plan()` の呼び出しは1か所で `round_ids` を渡している。**B は存在しない問題**
だった可能性が高い。

### (d) 「intent 実行が走っていなかった（step 9 skipped）」

**別 run の段を見ていた。** 34094020009 は attempt の run で、私の intent 実行ではない。

## 5. 危なかったこと

`34094398576` は**私の submit** だが、**別セッションが作った intent
（`amat_b18c6766e37610fb`）に対して `--confirm-paid-haiku` を渡していた**。
preflight で止まったので課金0だったが、通っていれば
**他セッションの意図で $1.10 を払っていた**。

意図と支払いを分けた設計（[P0-2]「意図が main に乗ってからでないと払わない」）が、
**別セッションの意図を掴む**という想定外の形でも守ってくれた。

## 6. 直すこと

  * `gh workflow run` の直後に「最新の run」を取らない
  * **起動前に最新の run id を控え**、それより新しい run のうち、
    ログの `IN_*` が**自分の渡した値と一致する**ものだけを自分の run とする
  * 一致するものが無ければ「自分の run を特定できない」と扱い、**数字を報告しない**
  * `--confirm-paid-haiku` を渡すときは、`intent_id` が**自分の run が作ったもの**か
    を確かめてからにする

`docs/renaming-procedure.md` へ「連続で workflow を叩くときは前の push が main に
乗るのを待つ」と併せて書く。

## 7. 生きている数字

  * **原宿店の抜粋 2,000字**（LivePocket → Vercel → KV → runner）は私の run。#1403 は効いている
  * 梅田 9/7 の有料送信（$0.0157・`ai_status: conflict`）は私の run
  * V7 の数字（`ai_not_run` 213 → 277 → 290、刻めない2行、added_keys 227）は
    すべて nyuka-watch / update-data 側で、**私の run で確認済み**
  * 課金は **$0.0157 の1回だけ**。$1.10 は1円も払っていない
