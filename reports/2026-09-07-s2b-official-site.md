# S2b（公式サイトの告知一覧の巡回）の実装

セッション名: store-name-b
日付: 2026-09-07（JST）
区切り/依頼名: S2b の実装
対象: `origin/main` = `3070f373` から分岐（`feat/s2b-official-site-lists`）

## 受けた指示（原文）

> S2b（公式サイトの告知一覧の巡回）を実装してください。
> ci は原宿店で手一杯なので、こちらで。
>
> 対象: M1g の54社のうち公式サイトが登録されている48社。
> まず「X で取れている店」（晴れる屋2・古本市場・駿河屋・ドラゴンスター）で、
> サイトの告知一覧から同じ抽選が取れるかを確認。取れれば S1 の経路が動く証拠。
>
> 1社ずつ:
> - 告知一覧のページを特定
> - runner から読めるか
> - 読めたら候補台帳に入れる
> - T に S2b の行
>
> Joshin・ビック・あみあみ・ヤマダ・しまむら は読めない可能性が高い。後回し。

## 指示と実測の食い違い（2点）

### ①「48社」の数え方

`store_sites.json` に公式サイトがある M1g チェーンを数えると **51社**（無いのは
`POKÉMON CARD LOUNGE` / `WonderGOO` / `GIRAFULL` の3社）。指示の 48 と合わない。

**48 に一致したのは `intake_routes` に `official_site` を含むチェーン**（35＋10＋2＋1）。
こちらを対象として実装した。`golden_chains.json` が正本で、実装側に一覧を作っていない。

### ② 4社のうち2社は、そのままでは取れなかった

「サイトの告知一覧から同じ抽選が取れるか」の答えは **4社中2社が即座には取れず、
原因が別**だった。下の §2 に1社ずつ書く。

## 1. 作ったもの

| ファイル | 中身 |
|---|---|
| `official_site_watch.py` | S2b の巡回。`--probe` / `--gaps` / `--measure` / `--apply` |
| `official_site_sources.json` | どのURLを開くか（社ごと）。`status` で読めない社を外す |
| `test_official_site_watch.py` | 25件 |
| `passrate.py` | `EXPECTED[("ec-lottery-watch","")]` に `S2b` を追加 |
| `.github/workflows/ec-lottery-watch.yml` | S2b の段を追加＋成果を `git add` |
| `ec_lottery_watch.py` | `記事リンク` の不具合を修正（§3） |

### 判定を足していない

記事を読む・抽選かどうか・行の組み立ては `official_page_intake` の1本
（S1 と同じ）。一覧を開く・記事リンクを拾うも `ec_lottery_watch` の関数を
そのまま呼ぶ。S2b が持つのは**「どのURLを開くか」だけ**（設計書 §11-1）。
試験で固定してある（`判定を足さないTests`）。

### S1 との違い

| | S1（`ec_lottery_watch`） | S2b（ここ） |
|---|---|---|
| 対象 | `ec_lottery_sources.json`（EC・チェーン42社） | M1g で `intake_routes` に `official_site` を持つ48社 |
| 深さ | 一覧の1ページ目 | **`paged` でページ送りし過去の記事まで**（§1-2b の肝） |
| 記録 | S1 | **S2b** |

### 読めない社を毎回叩かない

`status` が `blocked`（関門・403）/ `unlisted`（一覧が無い）の社は開かない。
理由を `status_note` に必ず書かせる（試験で空を落とす）。**同じ失敗を毎回数えると
通過率が読めなくなる**ので、対象から外して `skipped` の数で見えるようにした。

## 2. 指定4社の実測（1社ずつ）

### 晴れる屋2 → readable（ただし一覧の場所が違った）

- 最初に `/blogs/news` を一覧として登録したが、**20記事とも抽選ではなかった**
  （デッキ紹介・読み物）。「告知一覧」という名前に釣られると外す
- 抽選の告知は **`/pages/` の特設ページ**にある（`5th-anniv_lottery` 等）。
  site 検索を一覧の代わりにする既存の道（S1 の `search`）で拾えた
- 結果: 記事リンク20 → 読めた20 → **抽選と判定2**
- 応募そのものは LivePocket なので S6 が併走する。サイトは「告知」を担う

### 古本市場 → readable

- `https://furu1.net/news/`（`page/{n}/` で過去分）
- 記事リンク1 → 読めた1 → **抽選1**（ストームエメラルダ）
- **締切は取れなかった**（`apply_end` 空）。本文に日付が無い形

### 駿河屋 → readable

- `https://www.suruga-ya.jp/blog/` ＋ site 検索
- 記事リンク1 → 読めた1 → **抽選1**（`apply_end` 2026-06-04・過去の回）

### ドラゴンスター → blocked

- `https://dorasuta.jp/` は **Cloudflare の関門**。描画しても challenge ページで、
  取れるリンクは `cloudflare.com` への2本だけ
- 抽選そのものは共有基盤 `dorasuta.membercard.jp` にあり、**S1 が既に拾っている**
- したがって「サイトの告知一覧」からは取れない。`status: blocked` で登録し、
  理由を残した

### 「同じ抽選が取れるか」への答え

**3社で取れた。** ただし取れたのは「その店の抽選の告知ページ」であって、
X で取れている回と同じ回かどうかは、締切が取れない行があるため
（古本市場）この段では突き合わせられない。**経路が動く証拠にはなる**が、
「同じ回」の照合は L2（同一性の鍵）の仕事で、`--apply` で候補台帳へ入れたあと
既存の合流が行う。

## 3. 見つけた不具合（S1 にも効く）

`ec_lottery_watch.記事リンク` が、**`href` 末尾の空白で記事を全部捨てていた**。

```python
u = urllib.parse.urljoin(base, href.replace("&amp;", "&"))
if not re.search(pat, u) or re.search(r"[{}\s]", u):   # ← ここで落ちる
```

`[{}\s]` はテンプレートの穴（`${id}`）を捨てるための関門だが、`href` の末尾に
空白や改行を置くサイトがあり、そのURLも一緒に捨てていた。

実測: 晴れる屋2 の `/blogs/news/` は**5本とも末尾に空白**が付いており、
`記事リンク` の戻りは **0本**だった。

直しは `href.strip()` を `urljoin` の前に入れるだけ。**中に空白が残るもの
（テンプレートの穴）は従来どおり捨てる**。試験4件で両方向を固定した。

`記事リンク` は S1 も使うので、**S1 側でも拾える記事が増える**。

## 4. T（通過率）の配線

- `official_site_watch.py` の出口で `PRT.record("S2b", 読んだ数, 抽選と判定した数,
  reasons={not_lottery, unreadable}, extra={sources, skipped, links, with_end,
  applied, **PRT.m1g(店名たち)})`
- `passrate.EXPECTED[("ec-lottery-watch","")]` を `("S1", "S2b")` に
  → 走ったのに S2b の行が無ければ判定②が鳴る
- workflow に段を追加。**`continue-on-error: true` + `if: always()`** で、
  S2b が落ちても S1 の成果は commit まで進む
- `official_site_watch_state.json` と `official_site_sources.json` を `git add`
  の一覧へ追加（**書いても持ち帰らなければ記録は無いのと同じ**）

## 5. 残り

`--gaps` で見えるようにした。

```
{"m1g_official_site": 48, "登録済み": 4, "未登録": 44}
```

44社のうち **30社は S1（`ec_lottery_sources.json`）が既に一覧を持っている**ので、
S2b で新たに一覧を特定する必要があるのは残り **18社**。

```
ドン・キホーテ / トレカプラザ55 / しまむらパーク / ポケモンカードストア / ペリカン /
竜のしっぽ / シーガル / 竜星のPAO / イトーヨーカドーネットスーパー / プレイズ /
コジマ / オレタン / ファミマオンライン / GAME ARC宝島 / イオン北海道eショップ /
Bee本舗 / ノジマオンライン / （晴れる屋2 は登録済み）
```

指示で「後回し」とされた Joshin・ビック・あみあみ・ヤマダ・しまむら のうち、
**しまむらパーク**はこの18社に入っている。残り4社は S1 側に一覧がある
（＝S2b では触らない）。

## 6. runner から読めるかについて（限界の申し送り）

**この確認は手元では完全にはできない。** 手元は日本の家庭回線で、runner は
Azure のデータセンターIPなので、地域や IP 帯で弾く社は結果が変わる。
ドラゴンスターの Cloudflare は手元でも弾かれたので `blocked` と言い切れるが、
**「手元で読めた3社が runner でも読める」とは言えない**。

判定は本番の1回目の run で出る。`--probe` を Actions で走らせれば読めるか
だけ先に分かるので、必要なら手動 run（`workflow_dispatch`）で確認できる。

## 試験

| 走らせた対象 | 件数 | failures | errors |
|---|---|---|---|
| 手元: このブランチ | 7,755 | 2 | 3 |
| 手元: 素の main `3070f373` | 7,730 | 2 | 3 |

**失敗する試験の名前まで一致。新規の赤なし。**（`test_lint_gate` /
`test_candidate_ai_runner`×2 / `test_dedupe_channel` / `test_lottery_overrides`×2）
追加した試験は25件。pyflakes（undefined name / syntax error）合格。
試験がリポジトリのファイルを汚していないことも確認済み。

PR: https://github.com/shinonomeheta-ai/cardbot/pull/1431

## 根拠データ

- [2026-09-07-s2b-official-site.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-07-s2b-official-site.json)
  — `origin/main` 3070f373 の `golden_chains.json` / `ec_lottery_sources.json` と、
  4社の実測（一覧URL・記事リンク数・読めた数・抽選と判定した数・所見）。

## 実施しなかったこと

- `D:\cardbot` の作業ツリーには触れていない（使い捨ての worktree で作業）
- 設計書は変更していない（§1-2b は既に S2b を定義済み。実装位置の追記は
  docs 側と重なるので触らない）
- 18社の一覧特定はしていない（`--gaps` で見えるようにしただけ）
- 本番の巡回は回していない（`--apply` は workflow の次の定時 run で初めて走る）
