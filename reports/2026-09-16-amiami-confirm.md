# あみあみ本社口を人の確定にした

## 指示文

> あみあみ問題ないなら、人の確認としてOK。

前提:

- 直前の確認で、あみあみは `golden_intake_accounts.json` が `suggested` / `confirmed_at` 空だった
- 本店は `amiami.jp` / `@amiami_figure`。秋葉原は支店（`@amiami_akiba`）
- 本店X型 / Xとweb。`uses_roundup` にも `web_uncrawlable` にもしない

---

## 結論

あみあみ（`gc_e152a0825a`）を人の確定にした。`status=confirmed`、`confirmed_at=2026-09-16`。ハンドルと公式サイトはそのまま。秋葉原は支店のまま。まとめ専用にはしていない。

コード以外の台帳更新。本体は未コミット。マージしていない。

---

## 書いた値

| 欄 | 値 |
| --- | --- |
| name | あみあみ |
| handle | amiami_figure |
| site_url | https://amiami.jp/ |
| status | confirmed |
| confirmed_at | 2026-09-16 |
| x_scope | 空（本店X型と同じ） |
| no_x_announce / no_web_announce / web_uncrawlable | すべて false |
| hq_branch_select | false |

`confirmed_hq` に入る。`uses_roundup` は偽。

`storeHqKind` / `isGoldenHqStore` / `roundup_lane` は触っていない。

---

## 実行したコマンドと試験

```text
python -c（台帳を読んで confirmed_hq と uses_roundup を確認）
→ あみあみ confirmed 2026-09-16 / in_confirmed_hq True / uses_roundup False
```

新規試験は足していない。既存のレーン試験は実台帳の status を見ない。

---

## 変更した主要ファイル

- `golden_intake_accounts.json`
- `docs/assumptions.md`

---

## 未完了事項

- 本体は未コミット・未PR
- `golden_chains.json` の `verification: unverified` は触っていない（取得先Xの確定とは別欄）

## TODO_REQUIREMENT

なし。

## 外部資格情報など、ユーザーにしか解決できない阻害要因

なし。本番デプロイ・有料AI・実送信はしていない。

## 既知のリスク

なし。確定を外すときは管理画面の「外す」と同じく `suggested` に戻す。

## 次に着手すべき作業

本体へのコミットと PR は本人の操作。次のフェーズは自動では始めない。
