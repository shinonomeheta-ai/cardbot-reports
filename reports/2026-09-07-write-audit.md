# 今夜の私の run の書き込み棚卸し（事実のみ）

日付: 2026-09-07（JST・22:40 時点）
区切り/依頼名: 「書かないつもりで書いていた」の点検（全セッションへの確認）
セッション名: roundup

## 受けた指示（原文）

> api-customer から訂正が来た。
> 「runner の実測は書き込みなし」と報告していたが誤りで、ec_lottery_watch.py は --apply で走り、
> 候補台帳へ2行足していた。push が競合で控えに入り、リポジトリには着地しなかった。
>
> いま ci が event_id_registry.json の移行を控えており、
> 「移行中は台帳への書き込みを止める」を全セッションに出してある。
> 「書かないつもりで書いていた」ケースが1件出た。
>
> 各セッション、今夜自分が回した run について次を確認して返すこと。
>   - dry-run / probe / read-only のつもりで回したものがあるか
>   - それが本当に書いていないか（--apply が既定になっていないか、
>     probe のフラグが別スクリプトにしか効かないことがないか）
>   - 書いていた場合、どの台帳に何行か、着地したか控えで止まったか
>
> 判断は要らない。事実だけ返してほしい。他のセッションの報告と併せて総合で判断する。

## 事実

### 1. 「書かないつもり」で回したもの → **書いていない（3 種・確認済み）**

| 回したもの | つもり | 実際 | 確かめ方 |
|---|---|---|---|
| `roundup_survey.py --dry-run` | 読むだけ | 書き込みなし | `--dry-run` で `_書く` と `PRT.record` の手前で return |
| `roundup_rows.py --dry-run`（段 1 の実験・その後ファイルごと削除） | 読むだけ | 書き込みなし | 同上。`CL.load()` は読むだけで `CL.save()` を呼ばない |
| `build_lotteries_cardchusen.py` / `_melimelo.py` / `_nyuka.py`（停止の確認のため 1 回ずつ） | 門で止まるはず | **3 本とも `main()` の冒頭で終了**（「…の収集は管理設定で無効（sources.json）」） | 3 本とも `main()` の先頭に `source_enabled()` があることを origin/main で確認。実行前に `sources.json` を false にしてから回した |

`roundup_seen.py`（手元 2 回）は書きますが、書き先は**自分の 2 つの台帳だけ**（`roundup_seen.json` / `roundup_signal.json`）。候補台帳・店マスタ・公式X表には触りません（`candidate_ledger` / `store_registry` を import しないこと、`observe` / `note_x_candidate` / `set_x_status` を呼ばないこと、`_書く` の宛先が 2 つだけであることを試験で固定・#1434）。

### 2. 書いたもの → **2 回。どちらも私が手で起こした `roundup-daily`。両方 main に着地**

| run | 起こした時刻（JST） | main のコミット | 台帳への実際の変化 |
|---|---|---|---|
| 34108919723 | 18:58（私の判断で 1 回目） | **`0843d3d7`**（19:00） | 候補台帳 **2,352 → 2,360**（新規 8 件・応募回 +9）／店マスタ **+1 店**／公式X表 **+4 口**（TSUTAYA 須賀川店・カードスタジアムTSUTAYA首里店内・ブックオフ新座志木南店・モトナワールド）／X 投稿 **+9**／`roundup_survey.json` 新規／`official_x_intake_state.json`・`shadow_candidate_health.json`・`shadow_url_owner.json`・`history/source_stats.jsonl`・`history/passrate/...` を更新 |
| 34121137052 | 21:18（**metrics の依頼**で `D1/signal` の行を出すため） | **`916b7b11`**（21:23） | **新規の候補・応募回・店・口・投稿はいずれも 0**（候補 2,497 → 2,497／応募回 2,910 → 2,910）。中身は `last_seen_at` 136 か所と `lifecycle_status` 36 か所の更新、`roundup_seen/roundup_signal/roundup_survey` の更新、`shadow_url_owner`・health・source_stats・passrate |

どちらも `--apply`（Discovery の自動登録）と Seed（X 投稿の取り込み → `merge_intake_artifacts` で候補台帳へ再適用）を含む段があるので、**書く口は開いていました**。2 回目は結果として新規 0 でしたが、見つかっていれば書いていました。

**`event_id_registry.json` は今夜、私のコミットでは 1 度も触っていません**（`git log -- event_id_registry.json` で 0 件）。

### 3. 私が起こしていない run（誤解を避けるため）

今夜の窓に出ている `official-x-intake`（19:11・20:51）と `candidate-ai-daily`（22:19）は**私ではありません**。私の `candidate-ai-daily` の最後の起動は 16:1x の submit（batch 2 本・未回収）で、`official-x-intake` を最後に起こしたのは 09-06 20:21 です。今夜の `python-test` は私の PR の CI と main の基準取りで、読み取りだけです。

### 4. 指示の受領について（事実）

**「移行中は台帳への書き込みを止める」という指示を、私は受け取っていません。** ci と metrics との連絡でも、移行の予定は聞いていますが停止の指示は届いていません。21:18 の 2 回目は metrics からの「`D1/signal` の行が出ていない」という依頼に応えて起こしたものです。

### 5. 明日 05:40 に自動で走ります（事実）

`roundup-daily` は **schedule（JST 05:40）** を持っています。止めない限り、明朝この時刻に同じ段（survey → discovery `--apply` → seed → signal → commit）が走り、**候補台帳・店マスタ・公式X表へ書きます**。移行の窓に重なるなら、`workflow_dispatch` だけにするか schedule を外す必要があります（判断は仰ぎます）。

## 実行したこと・していないこと

- 上記の棚卸しのため、`git log` / `git show` と手元のファイル比較のみ。今回の点検で新たに何も書いていません
- 台帳の巻き戻しはしていません（指示があれば、`0843d3d7` の 8 候補・1 店・4 口は特定できます）
