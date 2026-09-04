# B・D の修正、GOODGAME の実地確認、そして赤の数え方の訂正

日付: 2026-09-04（JST）
区切り/依頼名: CI費用の削減 1（常駐赤の解消・続き）

根拠データ: [2026-09-04-ci-red-bd.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-04-ci-red-bd.json)（見たファイル・commit・数え方を含む）

## 受けた指示（原文・要点）

> ## 次の作業
> 指示どおりの順で進めてください。
> 1. B・D の3件、GOODGAME の実地確認
> 2. 次の巡回で停止を確認 → 既存7件の直し
> 3. 段1・その他のストアは後回し
> 4. CI削減は着手しない
>
> ## 段1について（追加）
> store-name セッションが同じ現象を報告しています。
> 「岡崎店・瀬戸店の投稿が TSUTAYA鈴鹿中央通店 の根拠にも付いている」
> （2026-09-04-tsutaya-handle-collision.md の末尾）。
> 段1に着手するときは、この報告を先に読んでください。

## 指示と過去の報告の食い違い

**私が報告してきた赤の件数が間違っていた。原因は私の数え方。**

`test_data_push_retry.py` は、データ契約が落ちたときの押し直しを試すために
**unittest の失敗そっくりの文面を標準出力へ印字する**（`test_data_push_retry.py:82`）。

```
FAIL: test_実データ (test_dedupe_channel.実データ.test_実データ)
Traceback (most recent call last):
AssertionError: 同じ商品が2件並んでいます
```

私は `grep "^FAIL:"` で数えていたので、**この模擬の文面を本物の失敗として数えていた**。

| | 私の報告 | 実際 |
|---|---:|---:|
| CI の常駐赤 | 「6〜8件」→「14件」 | **本物は最大でも4〜6件** |
| 手元の全件 | 16〜18件 | **本物は13件**（うち9件は Windows 固有でCIには出ない） |
| **D（`test_dedupe_channel`）** | 「実行順で結果が変わる1件」 | **そんな失敗は存在しない**（模擬の文面） |

`test_dedupe_channel.py` に `def test_実データ` は**無い**。「単独では通るのに全件では落ちる」
という私の観察も、印字を拾っていただけだった。**Dは幻だったので、直すものが無い。**

正しい数え方は「`=` の行 → `FAIL:`/`ERROR:` → （docstring）→ `-` の行」という
unittest の見出しの形で拾うこと。集計スクリプトを根拠データと一緒に残した。

## 報告

### 1. B（時限式のテスト2件）— 直した

**PR [#1274](https://github.com/shinonomeheta-ai/cardbot/pull/1274) をマージ**（`91e6074e`）。

`描画の経路Tests` の実測ページは応募期間が `2026-08-03 11:00〜09-02 23:00` で固定
なのに `application_status == open` を期待していた。**9月3日に期限切れ**になり、
以後ずっと `'closed' != 'open'`。コードは正しく `closed` を返していた。

期待値は書き換えず、**時計を期間の中（2026-08-20 12:00）へ固定**した。実測の文面は
そのまま。前提そのものを守る試験（`test_時計が期間の中にある`）も足したので、期間を
動かしたらそこが落ちる。

### 2. D — 存在しなかった

上の訂正のとおり。**直すものが無い。**

### 3. いまの main の本物の赤

私の修正が入った main（`cb2367d2`）の CI を、正しい数え方で拾い直した。

**本物 4 件。**

```
FAIL: test_実データの行に安定IDが付く            (test_lottery_overrides)
FAIL: test_成果物の行と控えの鍵がつながっている    (test_lottery_overrides)
FAIL: test_本物の控えが行の数だけある            (test_lottery_overrides)
FAIL: test_共有基盤のokは登録済みの店だけ         (test_shared_platform_gate)
```

**shop_watch の2件は消えた**（私の修正の効果）。残る4件は、私が「C: 実データの状態の
ずれ」に分類したものと一致する。

手元（Windows）ではこれに9件が加わるが、**すべて Windows 固有でCIには出ない**
（`test_lint_gate` の subprocess、`test_source_confidence_shadow`×4、
`test_url_propagation`×3、`test_single_branch_stores`）。

### 4. GOODGAME 流山おおたかの森店 — 本人のものと確認できなかった

対象の行:

```
store        GOODGAME 流山おおたかの森店
url          https://livepocket.jp/e/0pbiq
url_status   ok
url_source   from_source        ← まとめ記事から導いた、という意味
source_url   （まとめサイトの該当節）
```

確かめたこと（すべて保存済みの材料・追加の通信なし）:

1. **店の公式Xは登録済み**（`GOODGAME 流山おおたかの森店 → goodgame_ootaka`）
2. **保存済みの公式X投稿789本のうち、この店の投稿に `livepocket` を含むものは0件**
3. **その店自身の告知（`x.com/GOODGAME_Ootaka/status/2088817098168664334`）が
   応募方法を明記している**——

   > 期間中、合計3,000円（税込）ごとのお買い上げで、**レシート番号による抽選**に
   > ご応募いただけます

   **レシート番号による店頭抽選**であって、LivePocket の応募ページではない
4. 同じ `livepocket.jp/e/0pbiq` が **`GOOD GAME（千葉）` の根拠にも付いている**。
   LivePocket のイベントURLは回ごとに1つなので、2つの店名に付くのは
   「同じ店の別名」か「URLの塗り替え」のどちらか。**どちらにせよ持ち主を確定できない**
5. `store_platforms.json`（共有基盤の明示登録・61店）に **GOODGAME の登録は無い**

告知に付いた短縮URL（`t.co/iYTnEkjt4i`）は展開の控えに無く、行き先は未確認。
ただし **告知が応募方法を「レシート番号」と書いている**以上、LivePocket が
この回の応募先である可能性は低い。

**判定: 本人のものと確認できない。** 指示（「確認できなければ ok を落とす」）に従い、
`url_status` を `ok` から外すのが正しい。

**ただし1点、判断を仰ぎたい。** この行の `url_status = ok` は巡回が
`from_source`（まとめ記事由来）で付けたもの。**データだけ直しても、次の巡回で
また `ok` に戻る可能性がある。** 止めるなら、共有基盤のURLを `from_source` で
`ok` にしない、という関門が要る。データを直すだけにするか、関門も入れるかを
指示してほしい。

なお `url` そのものは変えない（変えると身元の鍵が変わり、`event_id` 台帳に
触れる）。`url_status` だけを落とす。

---

## 判断をお願いしたいこと

1. **GOODGAME の `ok` を落とす方法**。データだけ直すか、
   「共有基盤のURLを `from_source` で `ok` にしない」関門も入れるか
2. **残る `test_lottery_overrides` の3件**（`285 != 288` など）。
   [汚染源の報告](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-absorb-source.md)
   の既存7件と同根の可能性が高いので、**7件を直すときに一緒に消える見込み**。
   先に個別に見るか、7件の直しを待つか

## 次にやること（指示の順のまま）

- 次の巡回で吸収が **7 のまま**かを確認 → 既存7件の直し
- 段1は、指示のとおり `2026-09-04-tsutaya-handle-collision.md` を先に読んでから
- CI削減は着手しない

---

## 【訂正】2026-09-04 追記: §4 の GOODGAME の判定は誤りでした

私が引いた「レシート番号による抽選」の告知は**店頭の回**のもので、この行は
`conditions_note` のとおり**通販の購入者向けの回**です。別の回を突き合わせていました。
**「本人のものと確認できない」であって「誤りと確認した」ではありません。**

またこの行は `url_fixed_by_hand = True`（人が管理画面で URL を採用）で、
「まとめが勝手に `ok` にした行」でもありません。§4 の判定と、そこから出した
「`ok` を落とすのが正しい」という結論は**取り下げます**。

測り直しと、赤の本当の原因（本番と試験で規則がずれている）は
[2026-09-04-shared-platform-gate.md](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/2026-09-04-shared-platform-gate.md)
に書きました。判断はそちらでお願いします。
