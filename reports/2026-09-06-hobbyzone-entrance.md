# Hobby Zone が取れていない理由 — 公式サイトに告知が無い

セッション名: store-name-a
日付: 2026-09-06（JST）
区切り/依頼名: Hobby Zone の取得経路の確認
対象: `origin/main` = `aa8f0926`（#1365 マージ後）

## 受けた指示（原文）

> ## Hobby Zone が取れていない理由
> 入口には立っているのに、正解表の Hobby Zone（締切 9/6）が配布に出ていません。
> roundup の報告では「公式根拠が無く、まとめのページだけ」でした。
> EC巡回で /information/ と /news/ を読んでいるのに、9/6 の抽選の告知が
> 取れていないということです。
> 確認してください:
> - Hobby Zone の /information/ と /news/ に、9/6 締切の抽選の告知があるか
> - あるなら、なぜ候補台帳に公式根拠として入っていないか
> - 無いなら、店はどこで告知しているか（X？ 店頭のみ？）

## 指示と過去の報告の食い違い

なし。

## 答え: **公式サイトに告知はありません。取れないのが正しい状態です。**

### ① /information/ と /news/ に 9/6 の告知があるか → **ありません**

RSS で全記事を数えました（ページの HTML は JS で描くので、フィードのほうが確実です）。

```
/information/feed/   記事10件   最新は 2026-08-05「ゆめタウン光の森店営業再開のお知らせ」
/news/feed/          記事 2件   最新は 2026-07-21「つぶらな瞳のポップアップ」

抽選 / 30th / CELEBRATION / ポケモン を含む記事   **0件**
```

ページを本物のブラウザで描いても同じで、抽選の語は1つも出ません。

### ② なぜ候補台帳に公式根拠が無いか → **公式が出していないから**

候補台帳の Hobby Zone（締切 2026-09-06T21:00）は3件あり、根拠は**全部まとめ**でした。

```
ホビーゾーン / …プレミアムデッキセット    candidate_rejected（rejected_summary）
     pokecawatch.com ／ cardchusen.com
ホビーゾーン / …拡張パック「30th CELEBRATION」  candidate_rejected（rejected_summary）
     pokecawatch.com ／ cardchusen.com
ホビーゾーン / 拡張パック＋プレミアム…        found（has_application）
     pokecawatch.com ×2 ／ x.com/PokeGetInfoMain ／
     pokemon-infomation.com ／ rare-zaiko.blog.jp
```

**関門は正しく動いています。** 公式根拠が無いので落ちている、という状態です。

> **1つ気になること**: `pokecawatch.com` と `pokemon-infomation.com` の根拠が
> `source_authority: official_unverified` になっています。`pokecawatch` は
> `source_names.json` の**まとめのホスト**に入っている先です。**まとめを
> `official_unverified` と刻んでいる**ので、ここは分類の誤りだと思います。
> **触っていません**が、報告します（roundup セッションの範囲かもしれません）。

### ③ 店はどこで告知しているか → **公式サイトの SNS は Instagram。X ではありません**

```
公式サイトが張っている SNS   https://www.instagram.com/hobbyzone_official/  だけ
                          **X へのリンクは1つも無い**
登録済みの @hobby_zone_web  official_x_intake_state.json では **取り込み0件**
トップにある Google フォーム  404（終わった回の応募フォームの残骸）
トップにある customform.jp  「ホビーゾーン お客様アンケート」（抽選ではない）
そのほかの入口             /store/ /member/ /company/ /recruit/ …（告知は無い）
楽天店                    https://www.rakuten.co.jp/hobby-zone-/
```

### したがって

> **S2b（公式サイトの過去分巡回）では取れません。** 公式サイトが告知していないからです。

取るなら経路を増やすしかありません。

* **選択肢A**: Instagram（`@hobbyzone_official`）を見る。**いまシステムに Instagram の経路はありません**（新設が要る）
* **選択肢B**: 楽天店（rakuten.co.jp/hobby-zone-/）を公式の一覧として登録する。ただし楽天の抽選と店頭の抽選が同じ回とは限らない
* **選択肢C**: `@hobby_zone_web` が本当にこの店の口なら、X の取り込みが0件である理由（Cloudflare で読めていないのか、そもそも投稿が無いのか）を先に切り分ける
* **選択肢D**: 取れないままにする（店頭のみの告知なら、まとめ以外に材料が無い）

**私からは選択肢C を先にやることを勧めます。** 口が生きているかどうかで A・B の要否が変わります。

---

## 本人性の根拠が弱い登録の一覧 → PR #1366

ご指示のとおり、`_no_official_x`（無いと確かめた）とは**別の欄**として
`_weak_identity` を作りました。

```
ホビーゾーン  @hobby_zone_web
   公式サイトが X へのリンクを1つも持っていない（4ページ実測）
   サイトが張る SNS は Instagram だけ
   official_x_intake_state.json では取り込み0件
```

**外していません**（外すと経路が細るため・ご判断のとおり）。`_` で始まる鍵なので
`official_accounts()` が落とし、普通の登録としては読まれません。

## そのほか（ご指示どおり）

- **PR #1365 マージ済み**（`aa8f0926`）。イオンスタイルオンラインの入口が開きました
- **`k-lottery_sale.aspx` は落としていません**。T の記録で「毎回エラー」が続いたら、
  そのとき落とす、という方針を承知しました

## 判断していただきたいこと

1. **PR #1366 をマージするか。**
2. **Hobby Zone の経路** — 選択肢A〜D のどれか（推奨はC を先に）。
3. **まとめのホストが `official_unverified` と刻まれている件** — 私の担当外かもしれません。

## 状態

- **読み取りが中心。** 変更は `_weak_identity` の1件だけ（PR #1366）。
- Hobby Zone の登録は**触っていません**。
- 外部への通信は読み取りだけ。課金はありません。
