# 詳細ポップアップの応募帯・管理画面・X投稿のポスター：マージと本番反映

2026-09-18。[前の報告](https://raw.githubusercontent.com/shinonomeheta-ai/cardbot-reports/main/reports/2026-09-18-popup-admin-poster.md) の2本を本人の指示でマージした。

| PR | 中身 | merge commit |
| --- | --- | --- |
| #1624 | 詳細ポップアップの応募・フォローの帯、PCの横長2列、サイドバーの青 | `ab173dee` |
| #1627 | 管理画面・X投稿のポスター・OGP画像を紺と青・新しいロゴへ | `636a4e7a` |

* CI の web build check の赤 39 件は main の基準と同じ（PR 固有の赤 0）。Vercel プレビューは両方成功
* #1627 は #1624 のあとで `globals.css` 末尾が競合した。両方の追記を残して解き（`[skip ci]`）、試験・ビルド・プレビューを取り直してからマージ
  * 私の事前の競合確認は古い main で見ていて、競合を見落とした
* 本番の Vercel デプロイ成功。`https://torecanavi.app/og.png` が紺の新しい絵になり、撮影ページで起動の幕を出さない規則が本番に入っていることを確認
