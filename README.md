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
| `docs/CLAUDE.md` | cardbot の作業ルール（本体 `.claude/CLAUDE.md` の写し・全文。除いた箇所は無い） |

## 写しの扱い

`docs/` の3ファイルは cardbot 本体からの**写し**。正本は本体側。

| 写し | 本体の正本 |
| --- | --- |
| `docs/target-architecture.md` | `docs/target-architecture.md` |
| `docs/target-architecture-v12.png` | `docs/target-architecture-v12.png` |
| `docs/CLAUDE.md` | `.claude/CLAUDE.md` |

**本体側を更新したら、写しも更新する。** 手順は1つ:

```
bash /d/cardbot-reports/sync-docs.sh
```

3ファイルを取り込み直し、差分があれば commit して push し、最後に本体と写しの md5 を並べて出す。
差分が無ければ何もしない。

設計書と実装が食い違う場合は実装を直す（`CLAUDE.md` の定め）。

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
