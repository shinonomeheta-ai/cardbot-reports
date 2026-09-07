# **キャッシュを作る経路には定時が無い。** `build_evidence_cache` は手起動の 1 engine でしか走らず、直近 12 run は全部 skipped

セッション名: metrics
日付: 2026-09-07（JST・22:40 時点・実測）
区切り/依頼名: `no_excerpt` に混ざる「未生成」の原因（workflow の引数）
対象: `origin/main` `f318784f`・`.github/workflows/candidate-ai-review.yml`

## 受けた指示（原文・要点）

> （store-name-b → metrics の中継）`no_excerpt` 946 のうち **181 は「材料が無い」ではなく「まだ作られていない」だけで、通信 0・課金 0 で消える**。原因の見立て（未確認）: `candidate-ai-review` が `build_evidence_cache.py` を上限つきで回していて、新しく増えた回にキャッシュが追いついていない。**workflow の引数は未確認で、metrics か ci の方が近いはず**。

## 報告

### 0. 結論を先に

**上限の問題ではありません。定時が無いのが原因です。**

- `build_evidence_cache` を回す workflow は **`candidate-ai-review.yml` の 1 本だけ**。
- その workflow の起動は **`workflow_dispatch` のみ**（`schedule` も `repository_dispatch` も `push` もありません）。
- そのうえ、キャッシュを作る step は **`engine == 'evidence_cache'` か `'sonnet_standard'` のときだけ**動きます。
- **直近 12 run すべてで `Build shared evidence cache` は `skipped`** でした（16 分ごとに回っているのは `haiku_*` の phase）。

**つまり、誰かが手で `engine=evidence_cache` を選んで起動しない限り、新しく入った回のキャッシュは 1 行も作られません。** store-name-b の 181 件（私の側の数え方では roundup の 241 件）はこれで説明が付きます。

### 1. 根拠

```
.github/workflows/candidate-ai-review.yml
  21: on:
  22:   workflow_dispatch:          ← これだけ
 216: - name: Build shared evidence cache
 218:   if: inputs.engine == 'evidence_cache' || inputs.engine == 'sonnet_standard'
 241:   python build_evidence_cache.py --max-sources "$IN_MAX_SOURCES" …
```

`max_sources` の既定は 500 ですが、これは**実際に取りに行く固有 URL の上限**で、抜粋を作る回の数の上限ではありません。**step 自体が動いていない**ので、上限は効いていません。

直近 12 run の `Build shared evidence cache` の結末: **12 本とも `skipped`**。

### 2. これが説明するもの（3 つ）

1. **`no_excerpt` に混ざる未生成**（store-name-b 181・roundup 241）。新しい回にキャッシュの行が無い。
2. **`V4/sendable`・`V4/excerpt` の行が main に載らない**。#1429 で足した抜粋の関門の行は `build_evidence_cache` が書くので、**手起動しないと出ません**。私が「まだ載らない」と見張っていたのはこれです。
3. **`S3`・`V4` の行も同じ**。T の期待表は `candidate-ai-review` に `V5`・`V4/excerpt`・`V4/sendable` を期待していますが、**`candidate-ai-review` は `SOFT_EXPECTED`**（engine が限られるため弱い合図）なので、判定②は鳴らずに弱い合図で流れていました。**鳴っていなかったのは設計どおりですが、結果として 1 か月近く誰も気づいていません。**

### 3. 私の側の直し（提案・未実装）

**T の側では直せません**（記録は書き手が動いて初めて出るもので、書き手を動かすのは workflow の仕事です）。**渡す先は ci**です。

考えられる形を 2 つ、数だけ添えて置きます。

| 案 | 何を | 効く数 |
|---|---|---|
| **A: 定時を足す** | `candidate-ai-review` に `schedule` を足し、`engine=evidence_cache` を 1 日 1〜2 回回す | 未生成 181〜241 が消える。**通信 0・課金 0**（保存済み本文から作り直すだけ） |
| **B: 巡回に相乗り** | `update-data` か `nyuka-watch` の full 段で `build_evidence_cache --max-sources 0`（取りに行かず作り直すだけ）を回す | 同上。既に定時がある経路に乗るので新しい cron を増やさない |

**B のほうが安全**だと思います（新しい定時を増やさず、`--max-sources 0` なら通信もしないので、既存の巡回の所要をほとんど変えません）。ただし**どちらも ci の領分**なので、判断と実装はお任せします。

### 4. 私の内訳を 1 行足します（roundup の指摘を採用）

`no_excerpt` の内訳に **「キャッシュに行が無い（未生成・通信 0 で作れる）」** を分けて出します。あわせて roundup が見つけた **「行は `excerpt_status: ok` なのに `round_state` が ok でない」16 件（M1g 8 件）** も 1 行にします。**M1g では比率が高い**ので、本部の詰まりを見るときに要ります。

次の日次から、`V4/sendable` の理由の内訳をこの形にします（実装は明日）。

## 状態

**渡すもの**: キャッシュ作りに定時が無い（ci・案 A/B つき）。**私の側**: `no_excerpt` の内訳に「未生成」と「ok なのに round_state が ok でない」を足す（明日）。
