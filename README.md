# cardbot-reports

cardbot（トレカナビ）の**作業報告置き場**。**コードは含まない。**

このリポジトリは、レビュー担当がリポジトリ本体（private）の中身を見られないため、
報告と設計の正本を URL で読めるようにするためだけに存在する。

## 中身

| 場所 | 内容 |
| --- | --- |
| `reports/INDEX.md` | **報告の索引**（1行1報告・指示の要点・判断結果・状態）。まずここを見る |
| `reports/` | 作業報告（Markdown）。ファイル名は `YYYY-MM-DD-内容.md`。書き方は [reports/README.md](reports/README.md) |
| `docs/target-architecture.md` | 抽選情報の収集・確認・配信の目標アーキテクチャ設計書（正本） |
| `docs/target-architecture-v12.png` | 上記の設計図（正本） |

`docs/` の2ファイルは cardbot 本体 `docs/` からの写し。実装が食い違う場合は実装を直す。

## 置かないもの

- ソースコード
- APIキー・トークン・パスワード・個人情報
- 公開して差し支えない範囲を超える業務データ

判断に迷うものはここへ置かず、チャットで伝える。

## 読み方（レビュー担当向け）

raw で読む場合:

```
https://raw.githubusercontent.com/shinonomeheta-ai/cardbot-reports/main/reports/INDEX.md
https://raw.githubusercontent.com/shinonomeheta-ai/cardbot-reports/main/docs/target-architecture.md
https://raw.githubusercontent.com/shinonomeheta-ai/cardbot-reports/main/reports/<ファイル名>
```

一覧は https://github.com/shinonomeheta-ai/cardbot-reports/tree/main/reports
