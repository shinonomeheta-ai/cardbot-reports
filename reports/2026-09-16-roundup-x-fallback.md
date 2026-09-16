# まとめXのフォールバック（通販が本店と同じ公式Xのときだけ本店）

## 指示文

> でも取り残す可能性は高いので
> まとめのフォールバックはしっかりするようにしてほしいな。まとめXの。

前提（直前までの本人確定）:

- 公式が先。まとめを主経路にしない。まとめの値は根拠にしない（設計書 §0-1。例外は Amazon の状態だけ）
- あみあみは本店X型 / Xとweb。`uses_roundup` にも `web_uncrawlable` にもしない
- 通販本店は `amiami.jp` / `@amiami_figure` / `form.amiami.jp`。秋葉原は支店（`@amiami_akiba`）
- 秋葉原を本店としない。フルコンプ通販は別Xなので本店に入れない
- まとめXは管理画面で登録したアカウントから取る（全部掻き集めない）

---

## 結論

公式が取りこぼした回の安全網として、まとめXの本店レーンが **あみあみ通販** を拾うようにした。フルコンプ通販と秋葉原は入れない。まとめを主経路にはしていない。値は公式からだけ取る。コードは未コミット。マージしていない。

---

## 何が足りなかったか

`roundup_lane` は通販・オンラインを、台帳の社名そのもの以外は本店から外していた（ポケモンセンターオンライン例外）。あみあみの台帳は `store_keys: ["あみあみ","あみあみ 通販"]` で、両方とも `@amiami_figure` なのに **「あみあみ 通販」は空** だった。

その結果:

1. `まとめ埋めしてよいか("あみあみ 通販")` が偽 → `選ぶ` が `no_official_evidence` を落とす
2. `対象の店` の本店合図に通販が入らない
3. 「あみあみ」単体なら埋まるが、通販の店名で来た回はまとめフォールバックに乗らない

公式側（S1 お知らせ＋公式X）は Cloudflare 描画と `form.amiami.jp/draw日付` で取る。取りこぼしは残るので、まとめXは安全網として通販本店まで届く必要がある。

---

## 直したこと

判定は `roundup_lane` 1本。通販を本店にする条件は次の両方:

1. 台帳の店名（`canonical_name` / `display_name` / `store_keys` / `extra_store_keys`）
2. 本店と同じ公式X（`store_x_accounts.json` のハンドル一致）

ハンドルが無い・違うときは空のまま。名前の前方一致では寄せない。

実データでの答え:

| 店 | レーン | 理由 |
| --- | --- | --- |
| あみあみ | 本店 | 社名 |
| あみあみ 通販 | 本店 | 台帳の店名 かつ `@amiami_figure` が本店と同じ |
| あみあみ秋葉原店 | 支店 | `@amiami_akiba` は別。埋めない |
| フルコンプ 通販 | 空 | `@fullcomp_online` は本店と違う |

Python の本番呼び出しは `x_accounts` を省略し、`store_x_accounts.json` を1回読む。管理画面の JS はファイルを勝手に読まない（渡された表だけ見る）。

`選ぶ` は本店と同じ公式Xの通販を `kept_golden` / `roundup_fill` で残す。まとめ垢の投稿は応募先から外す（既存）。まとめサイトURLは残す。

変えなかったもの:

- あみあみを `uses_roundup` / `web_uncrawlable` にしない
- `公式が無い店` の合図（公開済みの店には合図を出さない）。あみあみは既に公開行があるので、取りこぼし回の安全網は **まとめ埋め** 側
- まとめの値を根拠にしない

---

## 採用した設計

- 判定は `roundup_lane` だけ。publish / 合図 / 管理画面はそれを呼ぶ
- 通販の例外は「同じ公式X」だけ。推測で寄せない
- ブラウザは JSON を黙って読まない（試験で差し替えられる）

## 採用した仮定

`docs/assumptions.md` 「まとめXの通販は本店と同じ公式Xのときだけ本店（2026-09-16）」に記録した。

---

## 実行したコマンドと試験

```text
py -m unittest test_golden_intake_accounts test_publish_verdicts test_roundup_seen -q
→ Ran 105 tests in 1.644s  OK

py -m unittest test_roundup_x_seed -q
→ Ran 8 tests in 0.009s  OK

node --test web/app/lib/golden-intake-accounts.test.mjs
→ 41/41 pass
```

新規・更新した試験:

- `test_まとめXの本店合図は支店名と混ぜない`（あみあみ通販＝本店、秋葉原＝支店、ハンドル無し＝空、フルコンプ通販＝空）
- `test_本店と同じ公式Xの通販はまとめで出す`（`kept_golden` / `roundup_fill`）
- レーン試験に あみあみ通販＝本店、秋葉原＝支店
- `test_本店と同じ公式Xの通販は合図に入れる`

既存の `test_チェックが付いたらAmazonフォールバックは使わない` は、応募先を `https://x.com/cardchusen_com/status/1` にした。通販社は実台帳に無いのでレーンは空のまま、まとめ垢の投稿を外す規則が `example.invalid` では効かなかったため。今回の通販本店判定とは別件。

`test_roundup_seen` の未クローズ `io.open` 警告は以前からある。今回は触っていない。

---

## 変更した主要ファイル

- `golden_intake_accounts.py`（`_same_hq_x` / `roundup_lane`）
- `web/app/lib/golden-intake-accounts.mjs`（同じ判定）
- `publish_reviewed_only.py`（レーン呼び出しに `x_accounts`）
- `roundup_seen.py`（`対象の店` に `x_accounts`）
- `test_golden_intake_accounts.py`
- `test_publish_verdicts.py`
- `test_roundup_seen.py`
- `web/app/lib/golden-intake-accounts.test.mjs`
- `docs/assumptions.md`

`golden_intake_accounts.json` と `store_x_accounts.json` は変えていない。

---

## 未完了事項

- 本体リポジトリは未コミット・未PR。作業ツリーに別件の汚れがある
- あみあみ公式パス（お知らせ描画 + 公式X）の取りこぼし率は、次の実巡回まで測っていない
- `公式が無い店` の合図はあみあみには出ない（公開行があるため）。意図どおり

## TODO_REQUIREMENT

なし。まとめを主経路にする判断、あみあみを `uses_roundup` にする判断は本人確定済みの「しない」を守った。

## 外部資格情報など、ユーザーにしか解決できない阻害要因

なし。本番デプロイ・有料AI・実送信はしていない。

## 既知のリスク

- 本店と通販が同じハンドルなのは台帳の事実。ハンドルが後で分かれたらレーンは空に戻る（推測で寄せない）
- まとめ埋めは公式根拠が無いときだけ。公式が取れた回はまとめを載せない

## 次に着手すべき作業

本体へのコミットと PR は本人の操作。次のフェーズ（公式巡回の実測やマージ）は自動では始めない。
