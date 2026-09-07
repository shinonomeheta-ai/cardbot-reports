# 抜粋の関門の行を T に足す（V4 と V5 の間・PR #1429）／コホートの日次はマージ（#1421）

セッション名: metrics
日付: 2026-09-07（JST・21:30 時点）
区切り/依頼名: T に「抜粋の関門」の行を足す（V4 と V5 の間）
対象: PR [#1429](https://github.com/shinonomeheta-ai/cardbot/pull/1429)（CI 待ち）／PR [#1421](https://github.com/shinonomeheta-ai/cardbot/pull/1421) マージ済み `7373241e`

## 受けた指示（原文）

> T に「抜粋の関門」の行を足してください。V4 と V5 の間。
> - 抜粋を作れた数・作れなかった数（理由別: 長すぎる・店名が本文に無い・本文が無い）
> - 送れる数・送れない数（理由別: 材料が古い・公式由来でない・共有基盤で持ち主未定）
>
> 今日 store-name-a が手で数えた「626回が V5 に届かない」を、T が毎日出す形に。
> この行が無かったから、3日間気づかなかった。

## 指示と過去の報告の食い違い

理由の語彙が 2 つ、実装と合いませんでした。

1. **「長すぎる」は起きない。** 抜粋は `EXCERPT_MAX`（2,000 字）で切るので、長さで落ちる回はありません。`excerpt_status` の語彙にも無いので入れていません。
2. **「共有基盤で持ち主未定」は抜粋の関門ではない。** これは応募URLが決まらない理由（`apply_url_reasons.shared_platform_owner_unconfirmed`・L の行の側）で、V5 へ送る関門には入っていません。設計書にその旨を書きました。

代わりに、実装が実際に持っている分岐をそのまま語彙にしました（下の 1）。

## 報告

### 0. 結論を先に

- PR #1429 を出した（CI 待ち・通れば自分でマージ）。**`V4/excerpt`（抜粋を作れたか）と `V4/sendable`（AI へ送れるか）の 2 行**を candidate-ai-review の run で毎回書く。判定は変えず、送る側の判定（`candidate_ai_cache.round_state`）をそのまま数える。
- 実データでは **2,748 回のうち送れるのは 869 回（32%）**。送れない 1,879 回の内訳は `not_official` 1,076（57%・抜粋はあるが公式由来でない＝設計どおり）・`no_excerpt` 801・`evidence_changed` 2。
- コホートの日次（#1421）は**マージ済み**（`7373241e`）。CI の赤 5 本は main の基準（run 34111591788）と完全に同じでした。

### 1. 足した行

| 行 | in → out | 落ちた理由（語彙） |
|---|---|---|
| `V4/excerpt` | 全応募回 → 抜粋を作れた回 | `excerpt_missing`（記載を切り出せない）・`source_text_missing`（本文が無い）・`event_store_mismatch`（店名が本文に無い）・`no_eligible_evidence`（材料が1本も無い） |
| `V4/sendable` | 全応募回 → AI へ送れる回 | `no_excerpt`・`stale`（材料が古い／切り方が旧版）・`evidence_changed`（根拠の組が変わった）・`not_official`（公式由来でない）・`source_changed`（抜粋を含む本文がもう無い）・`invalid_row` |

`V4/sendable` の語彙は新設（`PASSRATE_V4_GATE_REASON`・3 点セットで登録）。`round_state` を理由つきの `_round_state` に割り、`unsendable_reason()` が同じ分岐を返します。**送る側（plan / submit / ab_plan / sonnet_direct）が通る判定そのものを数える**ので、写しがずれません。

### 2. 実データ（main の台帳・書かずに数えた）

```
V4/excerpt   2,748 → 1,947   excerpt_missing 751 ・ no_eligible_evidence 25 ・ event_store_mismatch 25
V4/sendable  2,748 →   869   not_official 1,076 ・ no_excerpt 801 ・ evidence_changed 2
```

読み:
- **送れない回の 57% は `not_official`。** 抜粋はできていて、公式由来でないから送らない（§6-4 の決まりどおり）。store-name-a の「966 は設計どおり」と同じ形です。
- **抜粋が作れていないのが 801 回**（`excerpt_missing` 751 が主）。ここが「626 回が V5 に届かない」の本体で、直す相手はこちら。
- 2 行に分けたので、**「作れていない」と「作ったが送らない」が毎日別々に見えます。** 混ぜて 1,879 と数えると、また原因を取り違えます（2026-09-02 に一度起きた型）。

### 3. 形

- 小部品は部品が flow でも snapshot にできるようにしました（`SNAPSHOT_SUBS` / `is_flow`）。台帳全体の数なので、日次は合計でなく最後の run の値です。
- 期待表（`candidate-ai-review`）に 2 つ足したので、走ったのに行が無ければ判定②が鳴ります。

### 4. 試験

`test_passrate_excerpt_gate` 10 本（理由ごとの分岐 6 種・全応募回の数え方・snapshot・期待表・設計書）。関連 522 本 OK。

## 状態

PR #1429 CI 待ち（通れば自分でマージ）。最初の行は次の candidate-ai-review の run。
