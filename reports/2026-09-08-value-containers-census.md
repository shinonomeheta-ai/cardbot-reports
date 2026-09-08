# 同じ値を持つ入れ物を数えた（実物・読むだけ）

2026-09-08 20:44 ／ ci ／ 対象 main `803b36b1`（#1484 マージ後）

**数え方**: リポジトリ直下と `web/public/data/` の JSON **167本を全部**読み（読めなかった
ファイル 0本）、値の欄が実際に入っている器を数えた。**7つの値のどれかを持つのは 78本。**
判定の実装数は `.py`（試験を除く）と `web/app/**/*.mjs` を機械で数えた。
**読むだけ・書き換えていない。**

**この数え方の穴を先に書く**: 値を**辞書の鍵**として持つ器は数えられていない
（`store_aliases.json` は別名を鍵にしている）。**実際の器はここに出した数より多い。**

---

## 0. 先に結論

**入れ物は「数個」ではない。20 以上ある。** ただし**そのままでは作戦の分岐に使えない**——
数えると、入れ物は3種類に割れて、まとめられる相手は3つ目だけだった。

| 種類 | 数 | まとめられるか |
| --- | --- | --- |
| **段の器**（収集値・AI観測値・配布行…段ごとに1つ持つのが正しい） | **27ファイル／31の欄** | **まとめられない**（段があるから存在する） |
| **記録・控え・報告・待ち行列**（読み返さない／人が見るだけ） | **51ファイル** | まとめる必要がない（危険は「読み返した時」だけ） |
| **同じ判定の写し**（同じ問いに別々の実装が答える） | **26** | **まとめられる。ここが相手** |

**したがって「1つずつ入れ物をまとめる」は成立しない**（段の器は減らせない）。
**減らせるのは判定の写し 26 個**で、これは1つずつ潰せる大きさ。

**そして、この見立ては半分外れている。** 同時に渡された2社を追った結果、
**転んだ原因は入れ物の食い違いではなかった**（403 と、1日20件の順番待ち）。
詳しくは別便の報告。

---

## 1. 値ごとの数（実測）

| 値 | 器を持つJSON | 段の器 | 判定の写し | 正本（いま） |
| --- | ---: | ---: | ---: | --- |
| 商品名 | 37本 | 5 | 3 | `product_master.json`（M2） |
| 店名 | 52本 | 6 | **7** | `store_canon.py` ＋ `golden_chains.json` |
| 弾名 | 13本 | 4 | 3 | `product_master.json` の `sets` |
| 本文 | 7本 | 3 | 1 | `shadow_candidate_evidence_cache.json` |
| 口の表 | 16本 | 4 | 2 | `accounts.json`（＋公開用の写し） |
| 刻印 | 30本 | 5 | 1 | `shadow_round_links.json` ＋ `event_id_registry.json` |
| 締切 | 27本 | 4 | **9** | `lotteries.json` の `apply_end`（配布行） |

---

## 2. 商品名

**書く場所（値が入る器）**

    shadow_candidates.candidates[].product              2,605  収集値（取り込みが書く）
    shadow_candidates.candidates[].product_master{}     2,408  M2 の判定の写し
    shadow_candidate_ai.results[].checks.product        1,584  AI の観測値
    shadow_candidate_ai_human.reviews[].corrections       41  人の訂正
    lotteries.lotteries[].product / product_master       400  配布行
    product_master.json ＋ _supply.json                       M2 の正本（公式一覧）
    KV `site:lotfix`（lottery_overrides の entries）      121  人手補正

**読む場所**: 上のほか、`shadow_current_events(.v2)` 400 ／ `lottery_publish_queue` 400 ／
`latest.json` 324 ／ `lottery_conflicts` 177 ／ 報告系 12本。合計 **37本**。

**まとめられるか**: **段の器はまとめられない**（収集値・AIの観測値・人の訂正・配布行は
別のものを指しているので、1つにすると訂正の履歴が消える）。**まとめられるのは判定**——
「この文字列はどの商品か」を答える場所が3つあった（`product_master.resolve` が正本、
口A `build_lotteries_melimelo.extract_set`＝#1482 で正本へ移動済み、口B
`official_x_intake.set_names`＝#1483 で塞いだ）。**残りは0。ここは今日1日で片付いている。**

**正本**: `product_master.json`。**弾の名簿 `lottery_stores.json` は正本ではない**が、
M2 が名簿を一字一句写す約束なので**事実上の第2の正本**になっている（`'BRIGHTNESS'` の穴）。

---

## 3. 店名 —— **いちばん散っている**

**書く場所**

    store_registry.json.stores[].canonical_name        3,441  店の台帳（正本）
    web/public/data/stores.json.stores[]                 400  公開用の写し
    golden_chains.json.chains[].store_keys                55  ゴールデン台帳の鍵
    golden_chains.json.chains[].extra_store_keys           8  鍵のずれを埋める追加
    store_aliases.json / store_aliases_learned.json           別名（静的＋学習）
    shadow_candidates.candidates[].store               2,605  収集した生の名前
    lotteries.lotteries[].store                          400  配布行（寄せた名前）

**読む場所**: 52本。うち報告・控えが 30本以上。

**判定の写し（＝相手）**: 「同じ店か」を答える実装が **7つ**。

    store_canon.py                     正本（正規化2本）
    golden_chain_index.py              store_canon を呼ぶ ✓
    round_links.py                     store_canon を呼ぶ ✓
    link_golden_chains.py              store_canon を呼ぶ ✓
    build_lotteries_nyuka.py           store_canon を呼ぶ ✓
    event_identity.py                  **自前の正規化を持つ**
    candidate_contract.py              **自前の正規化を持つ**
    notify_open_lotteries.py           **自前の正規化を2本持つ**
    candidate_ai_ab.py                 **自前の正規化を2本持つ**
    web/app/lib/store-chains.mjs       **JS の写し**
    web/app/lib/golden-chains.mjs      **JS の写し**

**まとめられるか**: **6つはまとめられる**（4つの py の自前正規化と、JS 2枚）。
JS は「画面が Python を呼べない」ので消せないが、**#1484 が使った形**——
`PD._身元` と `RL.同じ店と言えるか` が**同一オブジェクトであることを試験で固定する**——を
JS 側にも当てられる（生成物にするか、契約試験で字面を突き合わせる）。

**正本**: `store_canon.py`（正規化）＋ `golden_chains.json`（チェーンの鍵）。

**今日の実例**: 「候補をまとめた鍵（`canonical_name`）と表を引いた鍵（`store_keys[0]`）が違う」で
22社が0行に化けた。これは**判定の写しではなく、鍵の選び方の食い違い**——
`golden_chains.json` の中に**鍵が2欄ある**（`canonical_name` と `store_keys`）ことが原因で、
`extra_store_keys` は**3欄目**にあたる。**同じ器の中に鍵が3つある**のが、この値の本当の形。

---

## 4. 弾名

    product_master.json.games[].sets[]          M2 の正本
    lottery_stores.json.<game>.sets             名簿（利用者の鍵 lot_key の元）
    watchlist.json.items[].include        21    照合用の1語（弾名ではない・#1483 の口B）
    settings.json / watchlist_settings.json     ピン留めの写し（include 33）
    web/app/lib/lot-key.mjs                     **JS が鍵を組み立てる**

**判定の写し 3つ**: `product_master.set_names()`（正本）／`derive_include`（別物だが
弾名として読まれていた＝#1483）／`lot-key.mjs`。

**まとめられるか**: `include` は**弾名ではない**ので、まとめるのではなく**名前を変える**のが正しい
（同じ器に別の意味の語が入っている）。`lot-key.mjs` は**まとめられない**——
利用者の端末に保存された鍵と一致し続ける必要があり、Python 側を変えると鍵が動く。
**名簿の `BRIGHTNESS` を直せない理由もこれ。**

**正本**: `product_master.json` の `sets`。**ただし名簿が事実上の第2正本**。

---

## 5. 本文（材料）

    shadow_candidate_evidence_cache.json  sources[].text  2,643 ／ rounds[].excerpt 2,993
    linked_page_cache.json                pages[].text      734
    shadow_official_x_posts.json          posts[].text    1,692

**3つとも独立に書かれ、独立に読まれる。** 今日「`linked_page_cache` だけ見て根拠キャッシュを
見ていない」で数を間違えたのは、この3つが同じ「本文」を指すのに**重なっていない**ため。

**まとめられるか**: **まとめられる**。3つとも「URL→本文」の写像で、鍵が違うだけ
（URL ／ `source_fingerprint` ／ 投稿ID）。ただし**取り方が違う**（Vercel経由のX・runner の web）ので、
**器を1つにして取り口を欄で分ける**のが素直。

**正本**: `shadow_candidate_evidence_cache.json` の `sources`（V4）。

---

## 6. 口の表（応募・告知の入口）

    accounts.json（直下）                      12  正本
    web/public/data/accounts.json              12  公開用の写し（別ファイル）
    store_x_accounts.json                          店の公式X（書く .py が3本）
    store_x_candidates.json                   406  候補
    golden_chains.json.intake_routes / announce_type  55  口の種類
    web/app/lib/*.mjs                              画面の写し

**まとめられるか**: `accounts.json` の2枚は**同じ中身**（写しは公開用）。
`store_x_accounts.json` は**書く .py が3本**あり、ここが唯一の多重書き込み。

**正本**: `accounts.json`（直下）。

---

## 7. 刻印

    shadow_round_links.json.links               439  round_id → candidate_round_id（#1484）
    event_id_registry.json.events[]           2,673  event_id ＋ identity_keys
    lottery_round_registry.json.rounds[]      1,621  round_id → event_id
    shadow_candidates.candidates[].identity_keys 2,605  素性の鍵
    lotteries.lotteries[].round_id              398  配布行の鍵

**5つとも別の対応を持っている**（同じ値の写しではない）。**まとめられない。**
危ないのは**同じ問い（この行はどの回か）に2つの答え方がある**こと——
刻印で引く／身元で引く。#1484 はその2つ目を減らしただけで、**入れ物は増やしていない**
（`shadow_round_links.json` は 2026-09-04 から存在する既存の器）。

**正本**: `shadow_round_links.json`（引く順で先）。

---

## 8. 締切 —— **判定の写しがいちばん多い**

    shadow_candidates.rounds[].apply_end              収集値
    shadow_candidate_ai.results[].checks.apply_end  1,584  AI の観測値
    shadow_candidate_ai_human / human_readings        139/151  人の訂正
    lotteries[].apply_end / current_apply_end / first_apply_end  400×3  配布行（3欄）
    lottery_status.records[].apply_end                 91
    KV `site:lotfix`                                  人手補正

**判定の写し 9つ**（「もう終わったか」を**現在時刻と自分で比べている** JS）:

    application-window.mjs  apply-ended.mjs  candidate-review.mjs  countdown.mjs
    lottery-overrides-api.mjs  partner-contract.mjs  review-grid.mjs
    review-table.mjs  sale-policy.mjs

`apply-ended.mjs` を輸入しているのは **4本だけ**。Python 側も `apply_end` と現在時刻を
比べているファイルが **20本以上**ある。

**まとめられるか**: **まとめられる**（JS は `apply-ended.mjs` に寄せる・Python は1本に寄せる）。
**ただし配布行の3欄（`apply_end` / `current_apply_end` / `first_apply_end`）はまとめられない**——
「最初に見た締切」と「いまの締切」を分けて持つのが訂正の履歴なので、
1つにすると**訂正されたことが分からなくなる**。

**正本**: 配布行の `current_apply_end`、判定は `apply-ended.mjs` / Python 1本。

---

## 9. 作戦（数えた結果から）

1. **段の器（31）は触らない。** 減らそうとすると訂正の履歴が消える。
2. **判定の写し（26）を1つずつ潰す。** 大きい順に **締切 9 → 店名 7 → 弾名 3 → 商品名 0（済）**。
   潰し方は #1484 が使った形が既にある——**「2つの実装が同一オブジェクトである」ことを
   試験で固定する**（`test_stamp_round_links` の1件）。字面を写した試験では止まらない。
3. **JS の写し（店名2・締切9・弾名1）は消せない**ので、**生成物にするか契約試験**を当てる。
   `vocab.gen.mjs` は既に生成物になっている——**この形が先例**。
4. **記録・控え（90以上）は放置してよい。** 危険なのは「読み返した時」だけで、
   今日の 4-3（`linked_page_cache` だけ見た）は**まさにそれ**。
   → **控えを読むときは、その値の正本が別にあるかを先に見る。**

---

## 10. この見立て自体について

**「入れ物が減っていないから、また別の場所でずれる」は、半分しか当たっていない。**

同時に渡された2社を実物で追ったところ、**どちらも入れ物の食い違いでは転んでいない**。

* イオンスタイルオンライン: 公式ページが **HTTP 403（連続8回）**。取れないので抜粋が無く、
  AI へ送れない。**入れ物は全部つながっていた。**
* GAME ARC宝島: 生きている応募回が2つあるのに **AI 判定の順番待ち**
  （送れる回 662 に対して 1日 20 件・並びは締切順ではなく指紋順）。

**入れ物の数で説明できるのは、今日の14例のうち「鍵の食い違い」型だけ**（22社の件・
`ゲームアーク/宝島` の鍵）。**403 と順番待ちは、器をいくつまとめても直らない。**
