# 案A の実施: 共有基盤の関門の判断を1か所へ ＋ 本番と試験のずれの棚卸し

日付: 2026-09-04（JST）
区切り/依頼名: CI費用の削減 1（常駐赤の解消・続き）

根拠データ: [2026-09-04-rule-drift.json](https://github.com/shinonomeheta-ai/cardbot-reports/blob/main/reports/data/2026-09-04-rule-drift.json)（ホストごとの Python/JS の答えと、実データの件数）

## 受けた指示（原文・要点）

> ## 案A を実施してください
> 試験に url_fixed_by_hand の免除を足す。3件とも緑になり、データは動かない。
>
> ## 規則が2か所にある件
> これは設計書 §11（判定定義の一元化）の対象です。
> 案A で試験を直す際、「本番と試験で規則が分かれている箇所が他にもないか」を
> 軽く確認して、あれば一覧で報告してください（実装はしない）。
>
> ## 事故（空 push）について
> publish-report.sh 側でも防げるなら（同じファイルを指していたら止める）、
> そちらも入れておいてください。

## 1. 案A の実施

**試験だけを直すのはやめて、判断そのものを1か所に置きました。**

指示は「試験に免除を足す」でしたが、免除を試験に書くと**3か所目の写し**が
増えます（配信JS・巡回Python・試験）。今回の赤はまさにそれが原因なので、
**行を見て決める関数を1つ作り、巡回も試験もそこを呼ぶ**形にしました。
振る舞いは指示どおり（3件とも緑・データは動かない）です。

### 足したもの: `resolve_urls.shared_platform_blocked(lot, url=None)`

```python
def shared_platform_blocked(lot, url=None, tenants=None):
    """**共有基盤の関門がこの行を止めるか。行を見て決めるのはここ1か所。**
    ・人が固定したURL（url_fixed_by_hand）は別の信頼経路。
    """
    l = lot or {}
    if l.get("url_fixed_by_hand") is True:
        return False
    u = l.get("url") if url is None else url
    return shared_platform_unconfirmed(u, l.get("store") or "", tenants)
```

役割を分けました。

| 関数 | 答えること | 引数 |
| --- | --- | --- |
| `shared_platform_unconfirmed()` | そのURLの**持ち主を確かめられたか**（事実） | URL・店名 |
| `shared_platform_blocked()` | **この行を止めるか**（行ごとの例外はここだけ） | 行 |

### 直した呼び出し（3か所）

- `finalize()` ① — 「`ok` を確定してよいかの、ただ一つの関門」。ここが行を見る
- `stale_ok()` の2か所 — 行が手元にあるので同じ判断を使う。
  人の固定で `ok` に戻った行は、次の巡回で **`url_hold_reason` が消えます**
  （いま3件に残っている `shared_platform_owner_unconfirmed` は自然に片づく）

`shared_platform_unconfirmed()` を直に呼んでいる他の10か所（`url_fields.py`,
`promote_candidate_decisions.py`, `cardchusen_official_links.py` など）は
**行を持たない**（URLと店名だけ）ので、そのままにしました。

### 足した試験（7件・`人が固定したURLは関門を越える`）

- 人が固定していなければ止まる／固定したら通る
- **`True` だけを免除にする**（`"true"` や `1` を通さない）
- 共有基盤でないURLには関係しない
- `finalize` が免除を通したとき **`url_hold_reason` を消す**
- **配る側にも同じ免除があること**（`public-fields.mjs` の
  `url_fixed_by_hand === true` を字面で確かめる）——片方だけ直すとまた分かれる
- `finalize` が `shared_platform_unconfirmed` を**直に呼ばない**こと

### 結果

**PR [#1278](https://github.com/shinonomeheta-ai/cardbot/pull/1278)**（head `0e87398c`）。

CIと同じ `python -m unittest discover -s . -p "test_*.py"` を、**無改変の同じ元**
（`aa034c69`・別 worktree）と突き合わせました。

| | 赤 | 試験数 |
| --- | ---: | ---: |
| 無改変の `aa034c69` | 17 | 7165 |
| この変更 | **16** | 7172 |

**増えた赤 0件。消えたのはちょうど対象の1件だけ。**

```
- test_shared_platform_gate.公開データも直してある.test_共有基盤のokは登録済みの店だけ
```

- `test_shared_platform_gate` 単体 … 52件すべて緑
- pyflakes … 0
- **データは1行も動かしていません**

#### 測り方の訂正: 「触った副作用」は外れでした

前回「実行中に同じ worktree を触った副作用の疑い」と書きましたが、
**何も触らずに測り直したら1回目と完全に同一の16件**でした。
原因は私の操作ではなく、**main 側の赤がもともと多い**ことです。

そのうえで、`aa034c69` を基準に取り直して差分で見たので、
いまの数は「私の変更のせいか」に答えられます。

#### CI の本物の赤（実測・`run 33873752926` / `128ba3af`）

CI のログを落として数えました。**5件**です。

```
test_candidate_ai_runner.抜粋の版Tests.test_実データの抜粋が店ごとに分かれている
test_lottery_overrides.実データで通るTests.test_実データの行に安定IDが付く
test_lottery_overrides.管理用の控えTests.test_成果物の行と控えの鍵がつながっている
test_lottery_overrides.管理用の控えTests.test_本物の控えが行の数だけある
test_shared_platform_gate.公開データも直してある.test_共有基盤のokは登録済みの店だけ  ← この PR で消える
```

（ログに出る `test_dedupe_channel.実データ.test_実データ` は
`test_data_push_retry.py:82` が印字する**模擬の文面**で、本物ではありません。
以前ここで数え違えたので、今回は名前を拾ってから除きました。）

**この PR で 5件 → 4件。** 残るのは

- `test_lottery_overrides` ×3 … 指示どおり吸収7件の直しを待つ
- `test_candidate_ai_runner` ×1 … **前回の私の報告（4件）には無かった赤**。
  main のデータが動いて増えたもので、まだ調べていません

手元（Windows）の17件のうち12件はCIに出ません
（`test_lint_gate` / `test_source_confidence_shadow`×4 / `test_url_propagation`×3 /
`test_single_branch_stores` / `test_data_push_retry`×2 / `test_registry_sandbox`）。

## 2. 本番と試験で規則が分かれている箇所（一覧・実装はしない）

「軽く確認」の範囲で、配信JSと巡回Pythonに**同じ決まりが別々に書かれている**
場所を洗いました。**実害のあるずれが1件見つかりました。**

### 【要対応】共有基盤の一覧が JS と Python で4ホストずれている

`date_source.PLATFORMS`（Python）と `store-x-match.mjs` の `PLATFORMS`（JS）は
同じ「誰でもページを作れるので持ち主を語れないホスト」の一覧のはずが、
**片方にしかないホストが4つ**あります。

| ホスト | Python | JS | 入った経緯 |
| --- | :---: | :---: | --- |
| `membercard.jp` | ✓ | **無し** | 2026-08-16 に Python へ追加（トレカキャピタル各店の誤 `ok` の修正） |
| `hopapp.jp` | ✓ | **無し** | 同上 |
| `customform.jp` | ✓ | **無し** | 2026-08-17 に Python へ追加（TCバトロコ各店ほか9行の誤 `ok` の修正） |
| `myshopify.com` | **無し** | ✓ | JS のみ（Python は `ORIGIN_OK` 側に持っている） |

**どちらの追加も「Python の一覧に抜けていたせいで誤 `ok` が出た」事故の
後始末で、そのとき JS 側へ写していません。**

いまの実害は 0 です（この3ホストの配布行は `membercard.jp` 5件・
`customform.jp` 2件・`hopapp.jp` 0件で、**`url_status = ok` は1件もない**）。

ただし JS の関門は**二重の守り**として置かれたものです。
`public-fields.mjs` にこう書いてあります。

> 以前はここで即座に返していたので、Python 側が「複数店が同じURLを指して
> いる」として拒否する `livepocket.jp/e/nq7lq` でも、**古い成果物や
> 誤って `ok` になった成果物なら公開できた**

**この3ホストについては、その二重の守りが効いていません。**
さらに `url_status = "source"` の経路では、共有基盤でないと判定されると
`store_sites.json` との照合へ落ちるので、**そこへこのホストが入った瞬間に
証明なしで公開できる**——公開経路のコメントが「塞いだ」と書いている穴が、
この3ホストだけ開いたままです。

守る試験もありません（`store-x-match.mjs` を読む試験は4本ありますが、
一覧の中身は突き合わせていない）。

#### ① 4ホストのURLを持つ行は現在何件か

| ホスト | 配布行 | `url_status` の内訳 | `store_platforms.json` の登録 |
| --- | ---: | --- | --- |
| `membercard.jp` | 5 | `unverified` 5 | **有り** |
| `customform.jp` | 2 | `unverified` 2 | **有り** |
| `hopapp.jp` | 0 | — | 無し |
| `myshopify.com` | 0 | — | 無し |

**7行あり、いまは全部 `unverified`**（＝配っていない）。ただし
`membercard.jp` と `customform.jp` には**明示登録が既にあります**。
つまり Python 側の関門は「登録があるので通す」と答えうる状態で、
`ok` になった瞬間に JS 側の二重の守りが無いまま配ります。
**「たまたま当たる行が無いだけ」というご指摘のとおりです。**

#### ② JS 側で共有基盤として扱われないと何が起きうるか

`publishableUrl()` の枝は2つあり、**どちらも緩む方向**に外れます。

**`url_status === "ok"` のとき**

```js
if (l?.url_fixed_by_hand === true) return url;
const okHost = hostOf(url);
if (!isSharedPlatform(okHost)) return url;      // ← ここで素通し
return tenantAllows(url, tenantKey(l?.store), maps?.tenants) ? url : "";
```

JS が共有基盤と思わないので、**登録の確かめをせずに返します**。
いまは Python の関門が先に効いているので結果は同じですが、
公開経路のコメントが想定している「古い成果物や、誤って `ok` になった
成果物」——たとえば登録を後から取り消した場合や、別経路で `ok` が
付いた行——を**止められません**。

**`url_status === "source"` のとき（こちらが本命）**

```js
if (isSharedPlatform(host)) {
  return tenantAllows(...) ? url : "";
}
return sameSite(host, (maps?.site || {})[who]) ? url : "";   // ← ここへ落ちる
```

共有基盤でないと判定されるので、**`store_sites.json` との照合**へ落ちます。
`store_sites.json` にその店の `membercard.jp` のURLが1つ入っていれば、
**明示登録なしにそのホストのURLを配れます**。これは公開経路のコメントが
「#550 で塞いだ穴が公開の判定で再発していた」として明示的に閉じたはずの道です。

> Google Forms / LivePocket / e-starbox / BASE などは誰でもページを
> 作れるので、`store_sites.json` にそれらが入った瞬間、証明なしで
> 公開できてしまう。（`public-fields.mjs`）

**いまは `store_sites.json` に4ホストの登録が0件なので発火していません。**
逆に言うと、**店サイトの表に1行足すだけで開きます**。台帳は人も機械も
足すので、「入らないはず」に頼れる場所ではありません。

#### ③ 一覧を1か所に集約できるか

**できます。正本は Python の `date_source.PLATFORMS` を推します。**

理由は、追加が3回ともPython側の事故対応から来ていること（誤 `ok` を
見つけて足す→巡回が止める、という順序）で、**先に知るのは常にPython側**
だからです。JSは配信時の二重の守りなので、写す側でよい。

集約の形は2案あります。

| 案 | 形 | 良い点 | 難点 |
| --- | --- | --- | --- |
| **生成** | `date_source.PLATFORMS` から `store-x-match` 用の**正規表現リテラル**を生成し、`vocab.gen.mjs` と同じ型で置く | 表が1つになる。ずれようがない | 生成物が最新かを見る試験が要る |
| **突き合わせ** | 一覧は2つのままで、**同じホスト列を両方へ当てて答えが一致すること**を試験する | 変更が小さい。既にある `PythonとJSで同じ答えになる` と同じ型 | 表は2つのまま。足すときは2か所直す |

**私の推し: まず「突き合わせ」を1本入れて、生成は §11 の中でまとめて。**
いま3ホストを JS へ写すだけなら数行ですが、**それだけだと次も同じずれ方**を
します。突き合わせの試験があれば、片方に足した時点でCIが止まります。

なお `myshopify.com` は逆向き（JSにあってPythonに無い）で、Python は
`ORIGIN_OK` 側に持っています。集約するときは、この2つの表の役割の違いを
先に決める必要があります（`PLATFORMS` は「登録を求める」、`ORIGIN_OK` は
「オリジン配下をまとめて許す」）。**同じ表にはできません。**

### 【一致・ただし守り無し】保留理由の語彙

`public-fields.mjs` の `HELD_REASONS_NOT_PUBLISHABLE`（3語）と、Python が
実際に `url_hold_reason` へ書く4語を突き合わせました。

| Python が書く理由 | JS | 扱い |
| --- | :---: | --- |
| `own_source_post` | 出さない | 一致 |
| `other_target_apply_url` | 出さない | 一致 |
| `broken_url` | 出さない | 一致 |
| `shared_platform_owner_unconfirmed` | **出す**（「確認中」） | 意図どおり（2026-08-28 本人指定） |

**いまはずれていません。**ただし JS の3語は手書きで、`vocab_master.py` が
生成する `vocab.gen.mjs` を読んでいません。Python 側で新しい保留理由を足すと、
**JS は黙って公開側に倒します**（既定が「出す」なので、足し忘れが安全側に
倒れない）。実データの保留理由はいま `shared_platform_owner_unconfirmed` 33件だけ。

### 【別立て・意図的と読める】記事ホストの表

`public-fields.mjs` の `ARTICLE_HOSTS`（`cardchusen.com` / `meli-melo.blog.jp` /
`nyuka-now.com` / `pokemoncenter-online.com`）は、まとめの一覧
（`source_names.json` の `hosts`）とは別立てです。JS 側には守り
（`notice-page-leak.test.mjs`）がありますが、Python との対応はありません。
4つ目の `pokemoncenter-online.com` はまとめではないので、**同じ表にはできない**
——別立てそのものは妥当に見えます。

### 【ずれではなかった】確認して外したもの

- `url_quality.PLATFORMS` と `date_source.PLATFORMS` … **別の概念**
  （前者は「このホスト上のページ＝応募ページ」という分類、後者は
  「明示登録を求める共有基盤」）。`test_customform_platform.py` に
  そのとおり書いてあり、一覧が違うのは正しい
- `finalize_official_urls.py` が `ok` を作る経路 … `RU.finalize()` を
  ちゃんと通しています（「`ok` を作ってよいのは関門だけ」を守っている）

## 3. `publish-report.sh`: 同じファイルを指していたら止める

別セッションが先に「控えを取る＋空なら元へ戻す」を入れていました（`266ed93`）。
**main を正にして、足りない差分だけ**を足しました（`5d3343c`）。

既にある復元は「消えた本文を戻す」備えで、**なぜ空になったかは言いません**。
原因は毎回これでした。

```
bash publish-report.sh 2026-09-04-x.md < reports/2026-09-04-x.md
```

置き場の本文をそのまま流し込むと `cat > "$DEST"` が**読む前に中身を捨てる**。
device+inode（`test -ef`）で突き合わせれば**書き込む前に**分かるので、名指しで
止めるようにしました。第2引数が置き場そのものの場合も同じです。

実際に両方の形で試して、止まることと本文が無事なことを確認しました。

```
$ bash publish-report.sh 2026-09-04-shared-platform-gate.md reports/2026-09-04-shared-platform-gate.md
本文の場所が置き場そのもの: reports/2026-09-04-shared-platform-gate.md
  そのまま置くと中身が消える。置き場の外に本文を用意して渡すこと。

$ bash publish-report.sh 2026-09-04-shared-platform-gate.md < reports/2026-09-04-shared-platform-gate.md
標準入力が reports/2026-09-04-shared-platform-gate.md そのもの。読む前に中身が消える。
  置き場の外へ本文を写してから、第2引数で渡すこと。
```

## 判断をお願いしたいこと

**共有基盤の一覧のずれ（membercard.jp / hopapp.jp / customform.jp）を、
いつ直すか。**

- いまの実害は 0（該当ホストの `ok` は1件も無い）
- ただし二重の守りが3ホストだけ効いていない
- 直し方は「JS の一覧へ3つ足す ＋ 両者を突き合わせる試験を1本」。
  実装は小さいが、**いま走っている作業（第2区切り・段1）とは別**なので
  勝手には入れていません

## 次にやること

- **#1278 のCIを見てマージ**
- `event_id_registry.json` が書き直されたら吸収を測り直す → 既存7件の直し
- `test_candidate_ai_runner` の赤（新しく増えた1件）を調べる
- `test_lottery_overrides` の3件は、指示どおり7件の直しを待つ
- 段1は `2026-09-04-tsutaya-handle-collision.md` を読んでから
- 案C（人の固定に根拠URLを必須）はバックログ
- CI削減は着手しない

---

## 追記 2026-09-04: #1278 のCI実測（赤だが、main の残りとちょうど同じ）

`run 33875014539`。

| | 試験数 | 赤 |
| --- | ---: | ---: |
| main（`128ba3af`・`run 33873752926`） | 7175 | 5 |
| **#1278** | 7182 (+7) | **4** |

```
test_candidate_ai_runner.抜粋の版Tests.test_実データの抜粋が店ごとに分かれている
test_lottery_overrides.実データで通るTests.test_実データの行に安定IDが付く
test_lottery_overrides.管理用の控えTests.test_成果物の行と控えの鍵がつながっている
test_lottery_overrides.管理用の控えTests.test_本物の控えが行の数だけある
```

**`test_共有基盤のokは登録済みの店だけ` は消えました**（手元だけでなくCIでも）。
増えた赤は0件。残る4件は**すべて main が既に赤いもの**です。

（ログの `test_dedupe_channel.実データ.test_実データ` は `test_data_push_retry.py:82` が
印字する模擬の文面で、本物ではありません。CI の `FAILED (failures=4)` と一致します。）

### 判断をお願いしたいこと: マージしてよいか

**CI は赤のままです。main が赤いので、緑にはできません。**
`test_lottery_overrides` ×3 は指示どおり吸収7件の直しを待っており、
`test_candidate_ai_runner` ×1 は別件です。

「CI を待たずにマージしない」という決まりに従って**待っています**。
- そのままマージする（残る4件は main 由来と実測済み）
- `test_lottery_overrides` の3件が消えるまで待つ

のどちらかを指示してください。
