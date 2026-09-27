# 絞り込みの「郵送」と朝のAI使用量の直し（PR #1690・#1691 マージ済み）

前の報告: https://raw.githubusercontent.com/shinonomeheta-ai/cardbot-reports/main/reports/2026-09-27-lottery-unified.md

## 指示（本人 2026-09-27）

> フィルター、トラックのアイコンとかつけて、ネットを郵送にして。
>
> 朝のAI使用量の昨日の表示、でもグロック1,000円、1,500円ぐらい引かれてたよ。直して
>
> OK　マージして

## 結論

- **本人の指示でマージした**。
  - #1690 → merge commit `11b133653`（Vercel 本番: 成功）
  - #1691 → merge commit `fbea0def7`（Python だけの変更なので Vercel は組み立てを飛ばした）
- CI は起こしていない。

## #1690 絞り込みのボタン

- 「🌐 ネット」を外し、並びを 🚚郵送（receive_method=ship）／🏪店頭／📱アプリ／💬SNS／🎟LivePocket に。
- 試験: hero-banners.test.mjs 19件緑。

## #1691 朝のAI使用量

| 何が起きていたか | 直し |
| --- | --- |
| 「昨日」が月の累計（9/27 朝「昨日 ¥1,397」は9月の累計） | 前回報告時点の ai_usage_report_state.json を update-data の commit の一覧に足した。記録が無い日は昨日の日付の xAI 呼び出しから目安を出し「目安」と書く |
| 見出しは Grok なのに Claude が混ざる（extra_yen ¥469 は Claude の実額） | 見出しを「AIの使用量」に、「うち Grok ／ Claude など」を分けて書く |
| 内訳が一度も出ていない（時刻の欄を ts で読んでいた。実際は timestamp_jst） | 日時として比べ、xAI の呼び出しだけを呼び出し元ごとに出す |
| Claude（AI審査）の大半が帳簿に入らない（記録で9月 1,956回・約¥7,025、帳簿は¥469） | 呼び出し記録から「Claude（AI審査など）: 昨日／今月」を1行足す |

今のデータで組み立てた報告:

```
💰 AIの使用量
昨日（Grokの呼び出し記録からの目安）: 約 ¥26（$0.17）／5回
今月(2026-09): 約 ¥1,411（$9.41）／167回 ・上限¥15,000の9%
　うち Grok 約 ¥942／Claude など 約 ¥469
Claude（AI審査など・呼び出し記録から）: 昨日 約 ¥0／0回・今月 約 ¥7,025／1956回
Grokの内訳: notify_new_lotteries: 3回 $0.09／build_news: 2回 $0.08（スキップ5）
```

試験: test_notify_ai_usage.py 7件緑。update-data.yml を読む試験 1,444件のうち赤2件（test_deadline_corrections の実データ・test_fill_product_master の「神の支配」）は main のままでも同じ赤（PR固有の赤0）。

## 気づいたこと

- 9月の Claude（candidate-ai-review）は記録で約¥7,025。月の予算¥5,000を Claude だけで超えている。9/20 以降はほぼ動いていない（最後は 9/23 の2回）。
- 金額はどれも記録の見積もり。実際の請求は xAI・Anthropic の管理画面が正。
