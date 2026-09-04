# reports/data/

報告の判断の根拠になった**集計結果**を JSON で置く。決まりは
[../README.md の「根拠データ」](../README.md#根拠データ)。

- ファイル名: `YYYY-MM-DD-内容.json`（対応する報告と同じ日付・内容名にする）
- 必ず入れる: どのファイル・どの時点のデータを見て数えたか
  （`source` / `commit` / `at`）
- 置かない: 台帳そのもの（`shadow_candidates.json` 等）、一時的な作業ファイル、
  機密（このリポジトリは public。**収集元サイト名も書かない**）

報告本文からは絶対URLでリンクする。前置きは
`https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/`。
