# まとめXフォールバックは視点の支店を本社にしない

## 指示文

> ただこれ、視点だけが動かないように気をつけて。まとめXで撮ったやつが、視点のやつを本社だと思ってフォールバックしたらそれは最悪。

前提（直前までの本人確定）:

- 公式が先。まとめを主経路にしない。値は公式からだけ取る（設計書 §0-1。例外は Amazon の状態だけ）
- 通販は台帳の店名かつ本店と同じ公式Xのときだけ本店（あみあみ通販。フルコンプ通販は別X）
- あみあみ本店は `amiami.jp` / `@amiami_figure`。秋葉原は支店（`@amiami_akiba`）
- 視点（投稿を作る・支店ごとに作成する）の本社/支社は `storeHqKind` / `isGoldenHqStore`（`store_keys` 完全一致）
- 秋葉原を本店としない。まとめXは管理画面で登録したアカウントから取る

---

## 結論

まとめXのフォールバックは **支店形を本店にしない** ように固めた。秋葉原店・吉祥寺店・渋谷店は、`store_keys` に入っていても、本店と同じ公式Xでも、本店レーンにも本店合図にもまとめ埋めにも載せない。

視点の本社/支社判定（`storeHqKind` / `isGoldenHqStore`）は **触っていない**。`roundup_lane` には繋いでいない。あみあみ秋葉原店は視点のまま支社。あみあみ通販は台帳の本社キーのまま本社。

コードは未コミット。マージしていない。

---

## 何が最悪だったか

直前の通販フォールバックは「台帳の店名 かつ 同じ公式X → 本店」だった。穴は3つ。

1. `roundup_lane` が **本店鍵の所属を支店形より先に見ていた**。`store_keys` に秋葉原店が入ると本店になる
2. 同じ公式Xなら「あみあみ秋葉原通販」のような名前も本店鍵に入り得た
3. `対象の店` が本店名の別名を **レーン再判定なしで足していた**。`キディランド` → `キデイランド吉祥寺店`、`ポケモンカードラウンジ` → `ポケモンカードラウンジ渋谷店` が本店合図の変種になる。変種そのものが店名だと `本店の合図か` が真になる

視点は `store_keys` 完全一致なので、今の台帳では秋葉原は支社のまま。ただしまとめXが支店回を本社回として埋めると、視点の「本社」と配信の店名が食い違う。それが本人の最悪ケース。

---

## 直したこと

判定の順を入れ替えた。**支店形を先に見る。**

社名の後ろ:

- `各店` / `一部店舗` / `対象店舗` → 本店
- `通販` / `オンライン`（店の形だけ）→ 本店と同じ公式Xのときだけ本店
- `〜店`（通販店・各店以外）→ 支店。`store_keys` でも同じXでも本店にしない

`対象の店` の別名は、本店レーンか本店の表記ゆれだけ残す。吉祥寺店・秋葉原店は落とす。キデイランド（ディ/デイ）は残す。

`本店の合図か` は、変種そのものが個別店なら偽。

`まとめ埋めしてよいか` はもともと支店を先に落とす。今回のレーン直しで、台帳を汚しても秋葉原は埋めない。

変えなかったもの:

- `storeHqKind` / `isGoldenHqStore` / `hqStoreKeys`
- あみあみを `uses_roundup` / `web_uncrawlable` にしない
- 通販の同じX例外（あみあみ通販は本店のまま）

---

## 採用した設計

- まとめXの店名判定と、視点の本社/支社判定は別の物差し
- 支店形は本店鍵に入れない。先に BRANCH を返す
- 別名の表記ゆれは残す。店で終わる個別店は残さない

## 採用した仮定

`docs/assumptions.md` 「まとめXの支店は本店にフォールバックしない（2026-09-16）」に記録した。

---

## 実行したコマンドと試験

```text
python -m unittest test_golden_intake_accounts test_roundup_seen test_publish_verdicts -q
→ Ran 106 tests in 1.985s  OK

python -m unittest test_roundup_x_seed -q
→ Ran 8 tests in 0.009s  OK

node --test web/app/lib/golden-intake-accounts.test.mjs web/app/lib/x-digest-text.test.mjs
→ 68/68 pass
```

新規・更新した試験:

- `store_keys` に秋葉原店があり、本店と同じXでも `roundup_lane` は BRANCH
- `あみあみ秋葉原通販` が同じXでも本店にしない
- `キデイランド吉祥寺店` / `ポケモンカードラウンジ渋谷店` は本店合図に入らない。`キデイランド` / `キデイランド各店` は残る
- 変種そのものが秋葉原店なら `本店の合図か` は偽
- `選ぶ` のあみあみ秋葉原店は `no_official_evidence`（まとめ埋めしない）
- 視点: `storeHqKind("あみあみ秋葉原店")` は branch、`あみあみ 通販` は hq

`test_roundup_seen` の未クローズ `io.open` 警告は以前からある。今回は触っていない。

---

## 変更した主要ファイル

- `golden_intake_accounts.py`（`_after_hq` / `_hq_roundup_keys` / `roundup_lane`）
- `web/app/lib/golden-intake-accounts.mjs`（同じ判定）
- `roundup_seen.py`（別名の再判定 / `本店の合図か`）
- `test_golden_intake_accounts.py`
- `test_roundup_seen.py`
- `test_publish_verdicts.py`
- `web/app/lib/golden-intake-accounts.test.mjs`
- `web/app/lib/x-digest-text.test.mjs`
- `docs/assumptions.md`

`storeHqKind` / `isGoldenHqStore` / `golden_intake_accounts.json` / `store_x_accounts.json` / `golden_chains.json` は変えていない。

---

## 未完了事項

- 本体リポジトリは未コミット・未PR。作業ツリーに別件の汚れがある
- 公式巡回の取りこぼし率は、次の実巡回まで測っていない

## TODO_REQUIREMENT

なし。視点の本社/支社をまとめXレーンに寄せる判断はしていない。

## 外部資格情報など、ユーザーにしか解決できない阻害要因

なし。本番デプロイ・有料AI・実送信はしていない。

## 既知のリスク

- 支店形は社名の後ろが `〜店` のときだけ。社名と綴りが違う支店（キデイランド吉祥寺店 vs キディランド）は別名フィルタの「見た目は支店名」で落とす
- `store_keys` に支店名を足すと視点の本社判定は動く。今回は台帳を触っていない。まとめX側は足しても本店にしない

## 次に着手すべき作業

本体へのコミットと PR は本人の操作。次のフェーズは自動では始めない。
