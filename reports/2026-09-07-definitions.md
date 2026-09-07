# 画面 7 社（12 行）／**うち公式根拠 5 行**（私の 11 行は誤り・x-intake が正しい）／上流 32 社。前日同時刻比 −5 社

セッション名: metrics
日付: 2026-09-07（JST・23:20 時点・実測）
区切り/依頼名: 冒頭の数字の定義を 1 つにして配る／内訳の 2 行を実装
対象: `origin/main`・PR [#1448](https://github.com/shinonomeheta-ai/cardbot/pull/1448)

## 今日の数字（指示の定義で数え直した値）

```
画面 7 社（12 行）／うち公式根拠（trusted）5 行／上流 32 社
前日同時刻（09-06 23:14・3a895387）: 画面 12 社（23 行）
前日比 −5 社（増 0 ／ 減 5: WonderGOO・オレタン・プレイズ・竜のしっぽ・駿河屋）
```

**前の報告の −6 社（22:05 基準）とは比べる時刻が違うだけ**です（古本市場は 22:05〜23:14 の間に前日側から外れました）。同時刻で揃えれば −5 社です。

## 1. 定義（全セッションへ・この 3 つで固定）

| 数 | 定義 |
|---|---|
| **画面** | 配布行（`web/public/data/lotteries.json`）で、店名が `golden_chains.json` の `store_keys` ＋ `extra_store_keys` と**完全一致**する行。**支店の個別名は除き「各店」は含む**（`store_keys` に入っているものがそのまま対象）。**締切は実時刻**（`apply_end >= いま`。空は受付中） |
| **上流** | `AL.rounds_of(candidates)`（**superseded を除く**）のうち `lifecycle_status == "active"` で、**締切が実時刻で未来**（空を含む）、**本部のみ**（`golden_chain_index.チェーン` が支店を含めない判定） |
| **公式根拠** | 画面の行のうち **`source_confidence["status"] == "trusted"`** |

**`source_confidence` は文字列ではなく dict** です。実物はこの形です。

```
{"status": "unverified", "reason": "single_unofficial_source", "source_count": 1}   7 行
{"status": "trusted",    "reason": "multi_source",            "source_count": 2}   2 行
{"status": "trusted",    "reason": "official_source",         "source_count": 1}   3 行
```

**`status` を見れば trusted は 5 行**です。

### 私の 11 行は誤りでした

`source_confidence == "official"`（文字列比較・**1 度も一致しない**）と `official_url_first_seen_at` の有無を OR で数えていました。後者は「公式URLを最初に見た時刻」の欄で、**根拠の信頼度ではありません**。**x-intake の 5 行が正しい値です。** 訂正します。

api-customer の 8 行は、`reason` が `official_source` の 3 行に別の条件を足した数だと思われます（未確認）。**上の定義で数え直していただければ 5 行に揃います。**

### 上流が 33 → 32 になった理由

指示の定義に**「締切が実時刻で未来」**が入ったためです。前は `lifecycle_status == active` だけで数えていました（締切が空か過ぎている回も 1 社ぶん数えていた）。**32 が正しい値です。**

## 2. 内訳の 2 行を実装しました（PR #1448）

`extra` に**数だけ**足しました（語彙は増やしていません）。

| 鍵 | 意味 | 実測 |
|---|---|---:|
| `not_generated` | キャッシュに行そのものが無い＝まだ作られていない | **249** |
| `ok_but_unsendable` | 行は `excerpt_status: ok` なのに `round_state` が ok でない | **346** |

```
V4/excerpt   2,830 → 1,884   not_generated 249
V4/sendable  2,830 → 1,538   no_excerpt 946・not_official 327・stale 15・evidence_changed 4
                              not_generated 249・ok_but_unsendable 346
```

`ok_but_unsendable` は 346 で、roundup の 16 件より大きく出ています。**roundup は `excerpt_missing` などを除いた残りを数え、私は「抜粋は ok なのに送れない回」を全部数えている**ためで、その大半は `not_official` 327 です。**roundup の 16 件は、そこからさらに理由の語彙に現れないものだけを取り出した数**だと思います。どちらを日次に出すかは、**私の側は 346（全部）を出し、内訳として `not_official` が見える形**にします。

## 3. ci が相乗りを入れたら（指示 2）

`build_evidence_cache` が定時で回るようになったら、**a/b/c を数え直して store-name-a へ渡します**。見込みは `a1`（未生成）249 が消えて `b`（送れるが送っていない）に移ることです。**その差の数をそのまま渡します。**

## 状態

PR #1448 CI 待ち（通れば自分でマージ）。**配ったもの**: 画面・上流・公式根拠の定義 3 つ。**訂正**: 公式根拠は 5 行（私の 11 行は誤り）・上流は 32 社。
