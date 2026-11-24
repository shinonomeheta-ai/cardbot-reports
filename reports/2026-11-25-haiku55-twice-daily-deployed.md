# Haiku 5.5 への切り替え・取得を1日2回に・朝の見回りの二重払いを止める（出した時の報告 2026-11-25）

本人 2026-11-25 の指示「確認のための流し直しと、報告→返事の往復を挟まない。設定1つで元に戻せる形にして、試験が通ったら本番に出す。出した後に、本番の数字で確かめる」「1〜5は、試験が通っていれば承認を待たずにマージしてよい（チャット側のレビュー担当が先に承認する）。差分は出した後の報告に入れる」に沿って出した。レビュー担当は、下の差分を出した後に読む。

## だめだったもの・戻らなかったもの・止まっているもの

1. 本番の数字での確かめは、まだ1回もできていない。2次判定・取得の1日2回・朝の見回りは、どれも次の 6:00 の便から効く。買取は 8:30 の便から、ニュースのボットは Haiku 5.5 で判定した記事がまだ0件（3:31 の回は判定する記事が無かった）。
2. 2次判定で「当選者向けの購入の案内」「抽選販売のみの案内」を抽選として出すようにしたが、締切が無い件は支店の口（lottery_branch）に出ない。口の設定 output_unknown_deadline = no（本人 2026-09-20「締切未定で出したくない」）のため。本店の口は締切が無くても 14日出る。11/25 の決定と 9/20 の決定が食い違うので、設定は変えていない。
3. 7日分（11/10〜11/16）の2次判定の流し直し（迷ったら抽選の行を外した形）は、指示の変更で途中で止めた。1,176件のうち 566件が返り、残りは取り消した。数えていないので、b・c・d の分け方と、抽選でない側の誤りの数は出ていない。実額 $0.22。
4. いま有効な買取表の読み直しはしていない。前に読んだ文字（Cloud Vision の結果）は DB に残っておらず（残っているのは文字の印 ocr_hash だけ）、指示どおり新しい投稿で置き換わるのに任せる。
5. 買取の控え（同じ画像は文字読みし直さない）で減る枚数と額の見込みは、まだ出せていない（画像を取り直して md5 を数える道具は作ったが、流していない）。
6. ニュースのボットの元の RSS の1つ（人気トレカゲットナビ gamenv.net/tc/feed/）が 403 で、記録の残る 11/22 16:01 から取れていない。取得の対象は変えない決まりなので触っていない。
7. GitHub の課金の分数は、窓口の権限（user）が無く読めない。下の分数は実行時間の合計。

## 出した物と時刻（JST）・戻した物

| 時刻 | 出した物 | 戻し方 |
|---|---|---|
| 11/25 3:17 | ニュースのボット: `config.yaml` の ai.model を claude-opus-5-5 → claude-haiku-5-5、影（shadow_model）を消した | `model` の1行を claude-opus-5-5 に戻す（前の設定は `D:\tenbaiCroll-backup-20261124\config.yaml.before-switch-20261125`） |
| 11/25 3:18 | 買取: card-crolling PR #3 をマージ・リポジトリの変数 `COLLECTOR_BUYBACK_READ_MODEL = claude-haiku-5-5`。同じ PR に買取の画像の文字読みの控え（intake.ocr_cache・中身が同じ画像は Cloud Vision に送らない） | 変数を空にする（控えは表が読めなければ毎回読む） |
| 11/25 3:21 | 2次判定: PR #4 をマージ・変数 `COLLECTOR_STAGE2_POST_MODEL = claude-haiku-5-5`。Haiku 5.5 のときだけの追記（当選者向けの案内・抽選販売のみの案内も抽選に。迷ったら抽選の行は入れない）、締切を残す直し（r27） | 変数を空にする（追記も外れる。締切を残す直しは全モデルに効く） |
| 11/25 3:47 | 取得を1日2回（6時・18時）に: PR #5（every3h.yml は 18:00 の1回・毎回 1次と2次を 45分ずつ待って受け取る・名簿に無い店の発見 14時間・補いの口は5ページまで・取得0件の知らせは2回）。cardbot #1870（止まりの知らせの予定を 18時だけ・一覧の古さの昼の基準 3→5時間・18時の回を Vercel から起こす） | 両方の PR を戻す |
| 11/25 3:50 | 朝の見回りの二重払いを止める: PR #6（投稿数の増え＝その間に DB に入った数の店は読まない。初日は試しで全部読んで取りこぼしを数え、0件なら次の朝から読まない） | 設定 `sweep_skip = off` |

戻した物: なし。1次判定はいまのモデルのまま。

## 画面から消えた抽選・誤って出た抽選・締切の抜け

切り替え後の本番の判定はまだ無いので 0件（数える前）。11/25〜11/27 の毎日 21:00 に、その日の Haiku 5.5 の2次判定から 100件を、いまのモデル（Haiku 4.5）と突き合わせる（1日 約 $0.24・上限 $0.40）。出たらその日のうちに変数を戻して報告する。

切り替え前の確かめ（12時の回 11/24）: 2次で抽選とした 28投稿のうち画面の口に入らなかった 19投稿は、15件が前の投稿と同じ回（重なり）、3件が後の投稿に置き換え、3件（ブックオフ名古屋みなと・magi仙台・スロイの2件）が締切なし。重なり・置き換えの先は 18件とも口に入っていた。ブックオフ名古屋みなとは自分の投稿のリポストで、元の投稿（11/18）が口に入っていた。magi仙台は当選1名のプレゼントで、出さない決まり。落とした物は0件。

## その日の実額（11/24）

- X（twitterapi.io）: 残高の減りで 00:15〜06:01 が $1.21、09:22〜翌00:15 が $6.46。06:01〜09:22 は途中に入金があり残高からは出せない（便の記録では $0.54 ＋ 買取の X の分）。合わせて 約 $8.2〜8.5。11/23 は $17.09。
  - 便の記録では、取得 $8.99・発見 $0.38・投稿数の見張り $0.13。
  - 記録のほうが残高より約 $1.3 多い。この日は検索の失敗（server）が多かったので、失敗した問い合わせも記録に数えている疑いがある（確かめていない）。
- Anthropic: 1次判定（バッチ）$0.675・2次判定（バッチ）$1.336・判定の便の記録の合計 $2.165・買取の X $1.346（X の分を含む）・サイト $0.176・リンク先 $0.027・発見の AI の分 約 $0.09。試し（Haiku 5.5 の比べ）は 11/24〜25 の合計で $1.60。
- GitHub の実行時間: card-crolling 505分（every3h 7回 270分ほか）、cardbot 248分。

## 試験

- card-crolling: tests/collector 509 passed, 1 skipped（PR #6 のあと）
- cardbot: 直した3本（stop-alert・crawl・heartbeat）81 passed。画面側の全部は 4,578 passed・2 failed。落ちた2本は手元に部品（@neondatabase/serverless・next）が無いためで、変更と関係ない。公開API の e2e は元から22分かかるので除いた（あとで直す一覧の件）。PR の Vercel の組み立ては成功し、本番の組み立ても 3:50 に成功した。
- ニュースのボット: tests/test_core.py 21 passed（11/24）

## 差分

### card-crolling PR #3（買取の読みのモデルの変数・画像の文字読みの控え）
```diff
diff --git a/.github/workflows/daily.yml b/.github/workflows/daily.yml
index 415326a..0e78310 100644
--- a/.github/workflows/daily.yml
+++ b/.github/workflows/daily.yml
@@ -23,6 +23,8 @@ env:
   COLLECTOR_DATABASE_URL: ${{ secrets.COLLECTOR_DATABASE_URL }}
   COLLECTOR_DISCORD_WEBHOOK_URL: ${{ secrets.COLLECTOR_DISCORD_WEBHOOK_URL }}
   CLOUD_VISION_API_KEY: ${{ secrets.CLOUD_VISION_API_KEY }}
+  # 買取の値段を読むモデル（リポジトリの変数。空なら今までのモデル。変数を消せば元に戻る。本人 2026-11-24）
+  COLLECTOR_BUYBACK_READ_MODEL: ${{ vars.COLLECTOR_BUYBACK_READ_MODEL }}
   # 米国から拒まれるページ（LivePocket の 202 など）を東京の中継で読み直す（リンク先の締切。2026-11-17）
   JP_FETCH_URL: https://torecanavi.app/api/fetch-jp
   JP_FETCH_TOKEN: ${{ secrets.JP_FETCH_TOKEN }}
diff --git a/.github/workflows/stores-weekly.yml b/.github/workflows/stores-weekly.yml
index 178bce9..d131a50 100644
--- a/.github/workflows/stores-weekly.yml
+++ b/.github/workflows/stores-weekly.yml
@@ -13,6 +13,8 @@ env:
   COLLECTOR_DATABASE_URL: ${{ secrets.COLLECTOR_DATABASE_URL }}
   COLLECTOR_DISCORD_WEBHOOK_URL: ${{ secrets.COLLECTOR_DISCORD_WEBHOOK_URL }}
   CLOUD_VISION_API_KEY: ${{ secrets.CLOUD_VISION_API_KEY }}
+  # 買取の値段を読むモデル（daily.yml と同じリポジトリの変数。空なら今までのモデル）
+  COLLECTOR_BUYBACK_READ_MODEL: ${{ vars.COLLECTOR_BUYBACK_READ_MODEL }}
   PYTHONUNBUFFERED: "1"
 jobs:
   stores:
diff --git a/collector/buyback.py b/collector/buyback.py
index 4324fae..1a682dd 100644
--- a/collector/buyback.py
+++ b/collector/buyback.py
@@ -10,8 +10,11 @@
 """
 
 import base64
+import hashlib
 import json
+import os
 import re
+import threading
 from datetime import date, datetime
 
 from collector import config
@@ -20,6 +23,14 @@
 from collector.store_sites import UA, load, urljoin_root
 
 MODEL = config.DEFAULT_JUDGE_MODEL
+
+
+def read_model() -> str:
+    """値段を読むモデル。`COLLECTOR_BUYBACK_READ_MODEL` で替える（空なら今までの MODEL。消せば元に戻る。本人 2026-11-24「設定1つで元に戻せる形で Haiku 5.5 に替える」）。
+    投稿の仕分け（classify）は MODEL のまま。単価表に無い名前は送らない"""
+    name = (os.environ.get("COLLECTOR_BUYBACK_READ_MODEL") or "").strip() or MODEL
+    config.require_model(name)
+    return name
 SYSTEM = """トレーディングカードの店の「買取価格」のページ（か買取表の画像）を渡します。**未開封の BOX・パック・セット商品（デッキ・カードセット・スペシャルBOX など）**の買取価格だけを表にしてください。
 * シングルカード（1枚のカード）・サプライ・ゲーム機・本・CD は入れない。**レアリティ別（「アルティメットレア ◯円」）・カード名や型番ごと（「メガゲンガーex 003/021」）の値段は、BOX の名前の見出しの下にあってもシングルなので入れない**
 * 買取の**条件の金額**（「1回で 45,000円以上の持ち込み」「上限◯円」「◯円以上で 5%UP」）は値段ではないので入れない
@@ -48,7 +59,8 @@ def ask_params(text: str, images: list[tuple[bytes, str]] | None = None) -> dict
     """値段を読む 1回ぶんのリクエスト。即時もバッチも、この同じ形を送る（2026-10-06 にバッチへ）。"""
     content = [{"type": "image", "source": {"type": "base64", "media_type": mt, "data": base64.b64encode(b).decode()}} for b, mt in (images or [])]
     content.append({"type": "text", "text": text[:60000]})
-    return {"model": MODEL, "max_tokens": 12000, "temperature": 0, "system": SYSTEM, "messages": [{"role": "user", "content": content}],
+    model = read_model()
+    return {"model": model, "max_tokens": 12000, **config.sampling(model), "system": SYSTEM, "messages": [{"role": "user", "content": content}],
             "output_config": {"format": {"type": "json_schema", "schema": SCHEMA}}}  # fmt: skip
 
 
@@ -64,8 +76,9 @@ def ask(cfg, text: str, images: list[tuple[bytes, str]] | None = None) -> tuple[
     from collector import llm
 
     client = anthropic.Anthropic(api_key=cfg.anthropic_api_key, timeout=180.0, max_retries=2)
-    r = client.messages.create(**ask_params(text, images))
-    cost = llm._cost(MODEL, r.usage.input_tokens, r.usage.output_tokens)
+    params = ask_params(text, images)
+    r = client.messages.create(**params)
+    cost = llm._cost(params["model"], r.usage.input_tokens, r.usage.output_tokens)
     return parse_ask(next((b.text for b in r.content if b.type == "text"), "{}"), r.stop_reason), cost
 
 
@@ -103,13 +116,14 @@ def batch_call(cfg, requests: list[tuple[str, dict]], max_minutes: int = 90, pol
         wait(poll_seconds)
         waited += poll_seconds
     out, cost = {}, 0.0
+    model_of = {cid: p.get("model", MODEL) for cid, p in requests}  # 読み取りと仕分けでモデルが違うことがある
     for b in batch_ids:
         if b in left:
             continue  # 時間内に終わらなかったバッチは使わない
         for custom_id, kind, text, stop_reason, tin, tout in api.results(b):
             if kind == "succeeded":
                 out[custom_id] = (text, stop_reason)
-                cost += llm.batch_cost(MODEL, tin, tout)
+                cost += llm.batch_cost(model_of.get(custom_id, MODEL), tin, tout)
     return out, cost
 
 
@@ -180,6 +194,33 @@ def ocr_hash(joined: str) -> str | None:
     return hashlib.md5(t.encode("utf-8")).hexdigest() if len(t) >= 40 else None
 
 
+#: 文字読みの控え（intake.ocr_cache）を X の買取の読みの並行の作業から使うときの錠（接続は1本）
+_OCR_LOCK = threading.Lock()
+
+
+def ocr_with_cache(cfg, db, data: bytes, client) -> tuple[list[str], bool]:
+    """(画像の文字認識の行, Cloud Vision に送ったか)。中身が同じ画像（バイトの md5）は前の結果を使い、Cloud Vision に送らない
+    （本人 2026-11-25「買取の画像の文字読みに、控え(画像の中身が同じなら読み直さない)を入れる」）。
+    表は 2次判定と同じ intake.ocr_cache。控えが読めない・書けないときは今までどおり毎回読む（読みは止めない）。"""
+    from collector import vision
+
+    key = hashlib.md5(data).hexdigest()
+    try:
+        with _OCR_LOCK:
+            got = db.rows("select rows from intake.ocr_cache where image_md5 = %s", (key,))
+        if got and isinstance(got[0][0], list):
+            return list(got[0][0]), False
+    except Exception:  # noqa: BLE001  表が無い・読めないときは読み直す
+        pass
+    rows = vision.ocr_rows(cfg.cloud_vision_api_key, data, client)
+    try:
+        with _OCR_LOCK:
+            db.execute("insert into intake.ocr_cache (image_md5, rows) values (%s, %s) on conflict do nothing", (key, json.dumps(rows, ensure_ascii=False)))
+    except Exception:  # noqa: BLE001
+        pass
+    return rows, True
+
+
 def copied_rows(db, source_id: str) -> list[dict]:
     """前の読みの値段の行を、AI の答えと同じ形にして返す（save にそのまま渡す）。"""
     return [{"game": g, "product": p, "official_name": o, "price": pr, "condition": cnd}
@@ -273,8 +314,8 @@ def read_sites(cfg, db, now: datetime, only: list[str] | None = None, http=None)
                 for img_url in all_imgs[:MAX_IMAGES * 2]:
                     try:
                         data = client.get(img_url).content
-                        rows_txt = vision.ocr_rows(cfg.cloud_vision_api_key, data, client)
-                        counts["ocr_images"] += 1
+                        rows_txt, sent = ocr_with_cache(cfg, db, data, client)
+                        counts["ocr_images" if sent else "ocr_cached"] += 1
                     except Exception:  # noqa: BLE001  1枚の失敗は1枚で終わらせる
                         continue
                     if not rows_txt:
@@ -447,7 +488,7 @@ def read_x(cfg, db, now: datetime, days: int = 14, max_posts: int = 5000, worker
     def prepare(row):
         """投稿 1件ぶんの読み取りの依頼（本文だけの 1回・画像ごと）を作る。画像は文字認識まで済ませる。AI にはまだ聞かない。"""
         post_id, handle, store_id, chain_key, posted_at, text, images, x_url, kind = row
-        specs, n_ocr = [], 0
+        specs, n_ocr, n_hit = [], 0, 0
         if kind == "sealed_prices" and PRICE.search(text or ""):
             # 本文に未開封品の買取価格が書いてある（本人 2026-10-03「ポスト本文にも買取価格が書いてあるかもしんないよ」）: 本文だけで 1回読む
             specs.append(("t", None, f"店の X の買取の投稿（{posted_at.astimezone(JST):%Y-%m-%d}）の本文:\n{text}", None, None))
@@ -456,8 +497,10 @@ def prepare(row):
             if img:
                 try:
                     data = client.get(img + ("&name=large" if "?" in img else "?name=large")).content
-                    ocr = vision.ocr_rows(cfg.cloud_vision_api_key, data, client) if cfg.cloud_vision_api_key else []
-                    n_ocr += 1
+                    if cfg.cloud_vision_api_key:
+                        ocr, sent = ocr_with_cache(cfg, db, data, client)
+                        n_ocr += sent
+                        n_hit += not sent
                 except Exception:  # noqa: BLE001
                     continue
             joined = "\n".join(ocr)
@@ -466,7 +509,7 @@ def prepare(row):
             mt = media_type(data) if data else None
             prompt = f"店の X の買取の投稿（{posted_at.astimezone(JST):%Y-%m-%d}）の本文:\n{text}\n\n画像の文字認識の結果（行ごと）:\n{joined}"
             specs.append((i, img, prompt, [(data, mt)] if data and mt and len(data) < 4_500_000 else None, ocr_hash(joined)))
-        return row, specs, n_ocr
+        return row, specs, n_ocr, n_hit
 
     def ask_now(prompt, imgs):
         """即時で読む（バッチを使わないとき・バッチで返ってこなかった分）。画像付きで失敗したら本文と文字認識だけで読み直す。"""
@@ -485,7 +528,7 @@ def ask_now(prompt, imgs):
     # 同じ店が前と同じ買取表を出し直した画像は、AI に聞かずに前の読みの値段を写す（本人 2026-10-11「なんとか安くする方法を考えて」:
     # 10日で 5,399回の読みのうち 1,174回（22%）が、同じ店の前の読みと値段の表が全く同じだった）。同じかどうかは画像の文字認識の結果で見る
     reuse: dict[str, str] = {}
-    for n, (row, specs, _) in enumerate(prepared):
+    for n, (row, specs, _, _) in enumerate(prepared):
         for k, spec in enumerate(specs):
             if spec[4]:
                 prev = db.rows("""select bs.source_id from intake.buyback_source bs
@@ -499,7 +542,7 @@ def ask_now(prompt, imgs):
     answers: dict[str, dict] = {}
     if use_batch:
         # 値段を読む依頼をまとめて Batch API（半額）へ（本人 2026-10-06「全部バッチでいいよ」）
-        reqs = [(f"p{n}-{k}", ask_params(spec[2], spec[3])) for n, (_, specs, _) in enumerate(prepared) for k, spec in enumerate(specs)
+        reqs = [(f"p{n}-{k}", ask_params(spec[2], spec[3])) for n, (_, specs, _, _) in enumerate(prepared) for k, spec in enumerate(specs)
                 if f"p{n}-{k}" not in reuse]
         got, c_batch = batch_call(cfg, reqs, api=api, sleep=sleep)
         cost += c_batch
@@ -509,10 +552,11 @@ def ask_now(prompt, imgs):
             except ValueError:
                 pass
         counts["asked_batch"] += len(answers)
-    for n, (row, specs, n_ocr) in enumerate(prepared):
+    for n, (row, specs, n_ocr, n_hit) in enumerate(prepared):
         post_id, handle, store_id, chain_key, posted_at, text, images, x_url, _kind = row
         counts["posts"] += 1
         counts["ocr_images"] += n_ocr
+        counts["ocr_cached"] += n_hit
         out, failed = [], False
         for k, (i, img, prompt, imgs, h) in enumerate(specs):
             if f"p{n}-{k}" in reuse:  # 前と同じ表: 前の読みの値段を写す（AI に聞かない）
diff --git a/collector/config.py b/collector/config.py
index 44df297..cab7731 100644
--- a/collector/config.py
+++ b/collector/config.py
@@ -32,14 +32,25 @@
 
 #: 判定の単価表（USD / 100万トークン）。**ここに無いモデル名は送信しない。**「最新」「latest」の別名は入れない（固定の名前だけ）。
 #: * claude-haiku-4-5: $1 / $5（見た: Claude API の現行モデル表 2026-09-19）
+#: * claude-haiku-5-5: $0.10 / $0.50（見た: Claude API の資料 2026-11-24）。temperature を付けると 400 になる（SAMPLING_FIXED）
 #: * grok-4.20-0309-non-reasoning: $1.25 / $2.50（見た: xAI の GET /v1/language-models 2026-09-19。画像の入力も同じ単価）
 #:   設計書 §4-5 の「Grok 4.1 Fast $0.2/$0.5」は、xAI の現行のモデル一覧に無い
 PRICES: dict[str, dict[str, float]] = {
     "claude-haiku-4-5": {"in": 1.00, "out": 5.00},
+    "claude-haiku-5-5": {"in": 0.10, "out": 0.50},
     "grok-4.20-0309-non-reasoning": {"in": 1.25, "out": 2.50},
 }
 
 
+#: temperature を受け付けないモデル（既定と違う値を送ると 400）。ここに入れたモデルには temperature を付けない
+SAMPLING_FIXED = ("claude-haiku-5-5",)
+
+
+def sampling(model: str) -> dict:
+    """リクエストに足す temperature。受け付けないモデルには何も足さない。"""
+    return {} if model in SAMPLING_FIXED else {"temperature": 0}
+
+
 #: 判定モデルの既定（実験3の結果。docs/assumptions.md J-1）。固定の名前で持つ
 DEFAULT_JUDGE_MODEL = "claude-haiku-4-5"
 
diff --git a/tests/collector/test_store_branches_buyback.py b/tests/collector/test_store_branches_buyback.py
index d614e78..2e522f1 100644
--- a/tests/collector/test_store_branches_buyback.py
+++ b/tests/collector/test_store_branches_buyback.py
@@ -1,9 +1,10 @@
 """公式サイトの店舗一覧と買取のページ（collector/store_branches.py・buyback.py）。ネットワーク・DB・LLM には出ない。"""
 
+import os
 import unittest
 from datetime import date
 
-from collector import buyback, store_branches
+from collector import buyback, config, store_branches
 
 
 class 店舗一覧(unittest.TestCase):
@@ -120,6 +121,55 @@ def test_時間内に終わらなければ空で返す(self):
         self.assertEqual((got, cost), ({}, 0.0))
 
 
+class 読むモデルの切り替え(unittest.TestCase):
+    """値段を読むモデルは COLLECTOR_BUYBACK_READ_MODEL で替える。空なら今までのモデル（本人 2026-11-24）。"""
+
+    def setUp(self):
+        self._old = os.environ.pop("COLLECTOR_BUYBACK_READ_MODEL", None)
+
+    def tearDown(self):
+        os.environ.pop("COLLECTOR_BUYBACK_READ_MODEL", None)
+        if self._old is not None:
+            os.environ["COLLECTOR_BUYBACK_READ_MODEL"] = self._old
+
+    def test_空なら今までのモデルで_temperature_を付ける(self):
+        p = buyback.ask_params("本文")
+        self.assertEqual(p["model"], buyback.MODEL)
+        self.assertEqual(p["temperature"], 0)
+
+    def test_haiku55_に替えると_temperature_を付けない(self):
+        os.environ["COLLECTOR_BUYBACK_READ_MODEL"] = "claude-haiku-5-5"
+        p = buyback.ask_params("本文")
+        self.assertEqual(p["model"], "claude-haiku-5-5")
+        self.assertNotIn("temperature", p)  # Haiku 5.5 は temperature を付けると 400
+
+    def test_仕分けは今までのモデルのまま(self):
+        os.environ["COLLECTOR_BUYBACK_READ_MODEL"] = "claude-haiku-5-5"
+        self.assertEqual(buyback.classify_params([("1", "h", "s", "c", None, "本文", [])])["model"], buyback.MODEL)
+
+    def test_単価表に無い名前は送らない(self):
+        os.environ["COLLECTOR_BUYBACK_READ_MODEL"] = "claude-latest"
+        with self.assertRaises(config.ConfigError):
+            buyback.ask_params("本文")
+
+    def test_バッチの額は依頼ごとのモデルの単価で数える(self):
+        class Api:
+            def submit(self, requests):
+                self.sent = requests
+                return "b"
+
+            def status(self, batch_id):
+                return {"processing_status": "ended"}
+
+            def results(self, batch_id):
+                for cid, _ in self.sent:
+                    yield cid, "succeeded", '{"as_of": null, "rows": []}', "end_turn", 1_000_000, 0
+
+        os.environ["COLLECTOR_BUYBACK_READ_MODEL"] = "claude-haiku-5-5"
+        _, cost = buyback.batch_call(None, [("p0-0", buyback.ask_params("本文"))], api=Api(), sleep=lambda s: None)
+        self.assertAlmostEqual(cost, 0.10 * 0.5)  # 入力100万トークン × $0.10 × バッチの半額
+
+
 class 読んだ印(unittest.TestCase):
     """AI が答えなかった投稿には読んだ印を付けない（10/6・10/8・10/9 に残高切れで全部失敗したまま印だけ付けていた）。"""
 
@@ -229,3 +279,97 @@ def test_文字認識の印(self):
         self.assertEqual(a, ocr_hash("30th CELEBRATION BOX  26,000円\n\nストームエメラルダ BOX 11,000円"))  # 空白の違いは同じ
         self.assertNotEqual(a, ocr_hash("30th CELEBRATION BOX 25,000円\nストームエメラルダ BOX 11,000円"))  # 値段が変われば別
         self.assertIsNone(ocr_hash("BOX"))  # 文字が少ない画像は印を付けない
+
+
+class 文字読みの控え(unittest.TestCase):
+    """本人 2026-11-25「買取の画像の文字読みに、控え(画像の中身が同じなら読み直さない)を入れる」。2次判定と同じ intake.ocr_cache を使う。"""
+
+    class Db:
+        def __init__(self, cached=None, broken=False):
+            self.cached, self.broken, self.stored = dict(cached or {}), broken, []
+
+        def rows(self, sql, params=()):
+            if self.broken:
+                raise RuntimeError("表が無い")
+            return [(self.cached[params[0]],)] if params[0] in self.cached else []
+
+        def execute(self, sql, params=()):
+            if self.broken:
+                raise RuntimeError("表が無い")
+            self.stored.append(params)
+
+    def test_同じ画像は送らない(self):
+        import hashlib
+        from unittest import mock
+
+        from collector import config
+
+        cfg = config.load({"CLOUD_VISION_API_KEY": "test"}, today="2026-11-25")
+        db = self.Db({hashlib.md5(b"img").hexdigest(): ["BOX 5,000円"]})
+        with mock.patch("collector.vision.ocr_rows", side_effect=AssertionError("送ってはいけない")):
+            self.assertEqual(buyback.ocr_with_cache(cfg, db, b"img", None), (["BOX 5,000円"], False))
+
+    def test_初めての画像は送って控える(self):
+        import hashlib
+        import json
+        from unittest import mock
+
+        from collector import config
+
+        cfg = config.load({"CLOUD_VISION_API_KEY": "test"}, today="2026-11-25")
+        db = self.Db()
+        with mock.patch("collector.vision.ocr_rows", return_value=["BOX 6,000円"]) as ocr:
+            self.assertEqual(buyback.ocr_with_cache(cfg, db, b"new", None), (["BOX 6,000円"], True))
+        ocr.assert_called_once()
+        self.assertEqual(db.stored, [(hashlib.md5(b"new").hexdigest(), json.dumps(["BOX 6,000円"], ensure_ascii=False))])
+
+    def test_控えが使えなくても読む(self):
+        from unittest import mock
+
+        from collector import config
+
+        cfg = config.load({"CLOUD_VISION_API_KEY": "test"}, today="2026-11-25")
+        with mock.patch("collector.vision.ocr_rows", return_value=["BOX 7,000円"]):
+            self.assertEqual(buyback.ocr_with_cache(cfg, self.Db(broken=True), b"x", None), (["BOX 7,000円"], True))
+
+    def test_読みの失敗は控えない(self):
+        from unittest import mock
+
+        from collector import config, vision
+
+        cfg = config.load({"CLOUD_VISION_API_KEY": "test"}, today="2026-11-25")
+        db = self.Db()
+        with mock.patch("collector.vision.ocr_rows", side_effect=vision.VisionError("http_500")):
+            with self.assertRaises(vision.VisionError):
+                buyback.ocr_with_cache(cfg, db, b"x", None)
+        self.assertEqual(db.stored, [])
+
+    def test_X_の読みで控えから取った枚数を数える(self):
+        """控えから取った画像は Cloud Vision の枚数（月の上限の数え）に入れず、ocr_cached に数える。"""
+        import hashlib
+        from datetime import datetime, timezone
+        from unittest import mock
+
+        from collector import config
+
+        post = ("111", "shop", 1, None, datetime(2026, 11, 24, tzinfo=timezone.utc), "買取表を更新", ["https://img/a.jpg", "https://img/b.jpg"],
+                "https://x.com/shop/status/111")  # fmt: skip
+
+        class Db(読んだ印.Db):
+            def rows(self, sql, params=()):
+                if "from intake.post" in sql:
+                    return [post]
+                if "ocr_cache" in sql:
+                    return [(["BOX 5,000円"],)] if params[0] == hashlib.md5(b"A").hexdigest() else []
+                return []
+
+        db = Db()
+        client = mock.MagicMock()
+        client.get.side_effect = lambda url: mock.MagicMock(content=b"A" if "a.jpg" in url else b"B")
+        cfg = config.load({"CLOUD_VISION_API_KEY": "test"}, today="2026-11-25")
+        with mock.patch.object(buyback, "classify_posts", return_value=({"111": "table_image"}, 0.0)), \
+                mock.patch.object(buyback, "ask", lambda cfg, text, images=None: ({"rows": []}, 0.0)), \
+                mock.patch("httpx.Client", return_value=client), mock.patch("collector.vision.ocr_rows", return_value=["BOX 6,000円"]) as ocr:  # fmt: skip
+            out = buyback.read_x(cfg, db, datetime(2026, 11, 25, tzinfo=timezone.utc))
+        self.assertEqual(ocr.call_count, 1)
+        self.assertEqual((out["ocr_images"], out["ocr_cached"]), (1, 1))
```

### card-crolling PR #4（2次判定の変数・Haiku 5.5 の追記・締切を残す直し）
```diff
diff --git a/.github/workflows/daily.yml b/.github/workflows/daily.yml
index 0e78310..cb5e094 100644
--- a/.github/workflows/daily.yml
+++ b/.github/workflows/daily.yml
@@ -25,6 +25,8 @@ env:
   CLOUD_VISION_API_KEY: ${{ secrets.CLOUD_VISION_API_KEY }}
   # 買取の値段を読むモデル（リポジトリの変数。空なら今までのモデル。変数を消せば元に戻る。本人 2026-11-24）
   COLLECTOR_BUYBACK_READ_MODEL: ${{ vars.COLLECTOR_BUYBACK_READ_MODEL }}
+  # 投稿の2次判定のモデル（本人 2026-11-25。空なら今までの claude-haiku-4-5。戻すときはリポジトリの変数を空にする）
+  COLLECTOR_STAGE2_POST_MODEL: ${{ vars.COLLECTOR_STAGE2_POST_MODEL }}
   # 米国から拒まれるページ（LivePocket の 202 など）を東京の中継で読み直す（リンク先の締切。2026-11-17）
   JP_FETCH_URL: https://torecanavi.app/api/fetch-jp
   JP_FETCH_TOKEN: ${{ secrets.JP_FETCH_TOKEN }}
diff --git a/.github/workflows/every3h.yml b/.github/workflows/every3h.yml
index 168713c..68bf028 100644
--- a/.github/workflows/every3h.yml
+++ b/.github/workflows/every3h.yml
@@ -14,6 +14,8 @@ concurrency:
 env:
   TWITTERAPI_IO_KEY: ${{ secrets.TWITTERAPI_IO_KEY }}
   ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
+  # 投稿の2次判定のモデル（本人 2026-11-25。空なら今までの claude-haiku-4-5。戻すときはリポジトリの変数を空にする）
+  COLLECTOR_STAGE2_POST_MODEL: ${{ vars.COLLECTOR_STAGE2_POST_MODEL }}
   COLLECTOR_DATABASE_URL: ${{ secrets.COLLECTOR_DATABASE_URL }}
   COLLECTOR_DISCORD_WEBHOOK_URL: ${{ secrets.COLLECTOR_DISCORD_WEBHOOK_URL }}
   CLOUD_VISION_API_KEY: ${{ secrets.CLOUD_VISION_API_KEY }}
diff --git a/collector/config.py b/collector/config.py
index cab7731..c857429 100644
--- a/collector/config.py
+++ b/collector/config.py
@@ -76,6 +76,7 @@ class Config:
     x_daily_usd: float = 13.0  # X を読む便の合計の1日（JST）の上限（collector/x_budget.py・本人 2026-11-21）
     judge_model_stage1: str = ""
     judge_model_stage2: str = ""
+    stage2_post_model: str = ""  # 投稿の2次判定だけのモデル（空なら judge_model_stage2）。リンク先・サイト・まとめの読みは変えない（本人 2026-11-25）
     stop_after_errors: int = 3
     #: 503 の束が続いたら止める数（2026-11-23。503 は課金されず束ごとに戻ることがあるので、ほかの失敗より多く待つ）
     stop_after_503: int = 10
@@ -191,6 +192,7 @@ def load(env: Mapping[str, str] | None = None, today: str | None = None) -> Conf
         x_daily_usd=_usd(env, "COLLECTOR_X_DAILY_USD", 13.0, UNLIMITED),
         judge_model_stage1=_text(env, "COLLECTOR_JUDGE_MODEL_STAGE1", DEFAULT_JUDGE_MODEL),
         judge_model_stage2=_text(env, "COLLECTOR_JUDGE_MODEL_STAGE2", DEFAULT_JUDGE_MODEL),
+        stage2_post_model=_text(env, "COLLECTOR_STAGE2_POST_MODEL"),
         stop_after_errors=_int(env, "COLLECTOR_STOP_AFTER_ERRORS", 3),
         stop_after_503=_int(env, "COLLECTOR_STOP_AFTER_503", 10),
         # 既定は割らない（2026-11-24 9時の回: 503 の待ちがふくらみ、2分で15店しか進まず便の上限 90分に当たる見込みになった）。"1" で割る形
diff --git a/collector/judge.py b/collector/judge.py
index 17b1c59..d004df2 100644
--- a/collector/judge.py
+++ b/collector/judge.py
@@ -301,7 +301,8 @@ def finish() -> JudgeResult:
         db.run_finish(run_id, datetime.now(now.tzinfo), c, cost, note)
         return JudgeResult(run_id, c, cost, note)
 
-    m1, m2 = cfg.judge_model_stage1, cfg.judge_model_stage2
+    # 投稿の2次判定のモデルは COLLECTOR_STAGE2_POST_MODEL（リポジトリの変数）で替える。空なら今までの judge_model_stage2（戻すときは変数を空にする）
+    m1, m2 = cfg.judge_model_stage1, cfg.stage2_post_model or cfg.judge_model_stage2
     if not m1 or not m2:
         notes.append("no_model")  # モデル名は固定で指定する。未指定のまま送らない
         return finish()
@@ -316,7 +317,7 @@ def finish() -> JudgeResult:
 
     by1 = f"{m1}@{llm.prompt_hash('stage1.md')}@stage1"
     # 後処理の規則を変えたら RULES_VERSION を上げる（LLM の応答は同じでも、保存する結果が変わる。--rejudge-stage2 の打ち直しの対象になる）
-    by2 = f"{m2}@{llm.prompt_hash('stage2.md')}.{postprocess.RULES_VERSION}@stage2"
+    by2 = f"{m2}@{llm.stage2_hash(m2)}.{postprocess.RULES_VERSION}@stage2"
     if redo_tag:  # 今の判定器で判定済みの投稿を、名前に印を足して打ち直す（--rejudge-stage2 --only-posts と一緒。文字認識を添えずに判定した投稿の読み直しなど）
         by2 += f"+{redo_tag}"
     c["judged_by"] = [by1, by2]
diff --git a/collector/llm.py b/collector/llm.py
index d6ad1c7..560e3e8 100644
--- a/collector/llm.py
+++ b/collector/llm.py
@@ -152,6 +152,25 @@ def prompt(name: str) -> str:
         return f.read()
 
 
+#: 2次判定の指示文に、このモデルのときだけ足す追記（本人 2026-11-25「2次判定を Haiku 5.5 に替える」。モデルの設定を戻せば追記も外れる）
+STAGE2_ADDENDUM = {"claude-haiku-5-5": "stage2_haiku55.md"}
+#: 考える分（adaptive thinking が既定で入る）も出力の上限に入るモデルに足す余裕。試し（2026-11-24・7日分 1,176件）と同じ 16,000
+THINKING_EXTRA_TOKENS = {"claude-haiku-5-5": 16000}
+
+
+def stage2_system(model: str, system: str, schema: dict | None = None) -> str:
+    """2次判定（STAGE2_SCHEMA の形）の指示文に、モデルごとの追記を足す。まとめX の抜き出しなど別の形には足さない。"""
+    add = STAGE2_ADDENDUM.get(model)
+    return system + prompt(add) if add and (schema is None or schema is STAGE2_SCHEMA) else system
+
+
+def stage2_hash(model: str) -> str:
+    """2次判定の `judged_by` に入れる印。追記を足すモデルは、追記の中身も混ぜる（追記を変えたら印が変わる）。"""
+    add = STAGE2_ADDENDUM.get(model)
+    h = prompt_hash("stage2.md")
+    return h if not add else h + "+" + hashlib.sha256(prompt(add).encode("utf-8")).hexdigest()[:6]
+
+
 def prompt_hash(name: str) -> str:
     """`judged_by` に入れる。プロンプトか schema が変われば値が変わる（過去分に打ち直せる）。"""
     schema = STAGE1_SCHEMA if name.startswith("stage1") else ROUNDUP_SCHEMA if name.startswith("roundup") else STAGE2_SCHEMA  # その段の schema だけを混ぜる
@@ -309,10 +328,11 @@ def stage2_params(model: str, system: str, text: str, images: list[tuple[bytes,
         for b, mt in images[:MAX_IMAGES_PER_REQUEST]
     ]
     content.append({"type": "text", "text": text})
+    system = stage2_system(model, system, schema)
     return {
         "model": model,
-        "max_tokens": max_tokens,
-        "temperature": 0,
+        "max_tokens": max_tokens + THINKING_EXTRA_TOKENS.get(model, 0),
+        **config.sampling(model),  # Haiku 5.5 は temperature を受け付けない（0 以外の値も既定以外は 400）
         # 毎回同じなのでキャッシュに乗せる。**1時間保つ**（2026-10-11: 5分のままだと、バッチの中の依頼が同時にばらばらに処理されて
         # ほぼ毎回書き込み（1.25倍）になっていた。1回あたり 書き込み 8,337・読み返し 4,168 トークン）。1時間の書き込みは 2倍・読み返しは 1割
         "system": [{"type": "text", "text": system, "cache_control": {"type": "ephemeral", "ttl": "1h"}}],
diff --git a/collector/postprocess.py b/collector/postprocess.py
index f84d1a3..107b772 100644
--- a/collector/postprocess.py
+++ b/collector/postprocess.py
@@ -25,7 +25,7 @@
 _TIME = re.compile(r"^([01]?\d|2[0-3]):([0-5]\d)$")
 
 #: 後処理の規則の版。規則を足したり変えたりしたら上げる（judged_by に入る。プロンプトのハッシュとは別）
-RULES_VERSION = "r26"  # r26: 本文が見出しで同じ弾の2商品以上を名乗れば、その商品の件を全部残す（拡張パックとプレミアムデッキセット。2026-10-10）。 r25: 全N種に当たっても、本文に「9種類からいずれか1個」があれば「選んで応募」へ（2026-10-07）。 r24: 1件を弾・商品ごとに分けるとき、当たった別名が同じ弾の別の当たった商品の別名の一部なら分けない（2026-10-06）。 r23: 種類を選んで応募する回（どれか1つ・いずれか）は全N種へ寄せず「選んで応募」の商品へ（2026-10-04）。 r22: 本文の見出しが1商品だけの投稿は、その商品の件だけにする（トレカステーション 2026-09-29）
+RULES_VERSION = "r27"  # r27: 締切の根拠の語句に日付が無くても、本文に同じ月日の締切の文があれば締切を残す（2026-11-25）。 r26: 本文が見出しで同じ弾の2商品以上を名乗れば、その商品の件を全部残す（拡張パックとプレミアムデッキセット。2026-10-10）。 r25: 全N種に当たっても、本文に「9種類からいずれか1個」があれば「選んで応募」へ（2026-10-07）。 r24: 1件を弾・商品ごとに分けるとき、当たった別名が同じ弾の別の当たった商品の別名の一部なら分けない（2026-10-06）。 r23: 種類を選んで応募する回（どれか1つ・いずれか）は全N種へ寄せず「選んで応募」の商品へ（2026-10-04）。 r22: 本文の見出しが1商品だけの投稿は、その商品の件だけにする（トレカステーション 2026-09-29）
 #: 抜けを数える項目（設計書 §4-6）。reason / confidence / is_lottery は数えない
 GAP_FIELDS = ("set_id", "product_id", "kind", "product_raw", "game", "apply_start", "apply_end", "apply_end_time",
               "how", "url", "limit", "announce", "announce_date")  # fmt: skip
@@ -369,6 +369,14 @@ def deadline_from_quote(quote: str, year: int, text: str = "") -> tuple[str, str
     return d.isoformat(), hhmm
 
 
+def deadline_in_text(end, text: str) -> bool:
+    """本文に、その月日の締切の文があるか（「11/25まで」「11月25日(水)終日で応募締切」「応募締切：11月25日」「受付期間 11/20〜11/25」）。
+    発売日・販売の開始（「11/25(水)より販売」）は当てない。"""
+    t = unicodedata.normalize("NFKC", text or "")
+    md = r"(?<!\d)%d\s*[/月]\s*%d(?!\d)" % (end.month, end.day)
+    return bool(re.search(md + r"[^\n]{0,30}?(まで|締切|〆|受付終了)", t) or re.search(r"(締切|〆|応募|受付|申込|申し込)[^\n]{0,30}?" + md, t))
+
+
 def check_deadline_quote(item: dict, text: str = "") -> dict:
     """締切は、根拠の語句（`apply_end_quote`）を写せたものだけ残す。
 
@@ -415,6 +423,11 @@ def check_deadline_quote(item: dict, text: str = "") -> dict:
         # **ラベルが1つも付いていない日付だけ**を疑う。ラベルの語を細かく当てない: イエローサブマリンのポスターの
         # 「申込み期間 8/5〜8/9」を、モデルが「中込み期間」と読み違えて写した（申→中）。語を当てにいくと本物の締切を消す
         why = "申し込みの詳細はこれから出す告知で、日付にラベルが無い（販売の期間の疑い）"
+    if why in ("根拠の語句が無い", "根拠の語句に締切の日付が無い") and deadline_in_text(end, text):
+        # 本文に同じ月日の締切の文（「11月25日(水)終日で応募締切」「11/25 23:59まで」）があれば、写し損ねただけなので残す
+        # （本人 2026-11-25「締切を残す直しは入れる」。試し 2026-11-24: Haiku 5.5 が時刻だけの「23:59まで」を写し、正しい締切が空になった）
+        out.setdefault("_fixed", []).append(f"apply_end:{out['apply_end']} を残した({why}・本文に同じ月日の締切の文)")
+        return out
     if why:
         out.setdefault("_fixed", []).append(f"apply_end:{out['apply_end']}→null({why})")
         out["apply_end"], out["apply_end_time"] = None, None
diff --git a/collector/prompts/stage2_haiku55.md b/collector/prompts/stage2_haiku55.md
new file mode 100644
index 0000000..7a7c7bc
--- /dev/null
+++ b/collector/prompts/stage2_haiku55.md
@@ -0,0 +1,9 @@
+
+
+# 追記（2026-11-25。上の決まりと食い違うところは、この追記を優先する）
+
+* 「事前抽選販売を行います」「事前抽選による販売を実施」「購入権抽選を実施」「再入荷・抽選販売」のように、対象のトレカを**これから抽選で売る**と知らせ、詳細の参照先（公式サイト・リンク・店頭の掲示）を示す投稿は、予告ではなく告知（`is_lottery=true`）。応募期間が書いていなければ `apply_end` は null
+* 抽選の件の `kind` は 店頭抽選・事前応募・オンライン抽選 のどれかにする（抽選の件を `その他`・`先着`・`結果発表` にしない）
+* 締切が本文・画像・引用元・続きの投稿の**どこかにあれば、必ず** `apply_end` に書く。`apply_end_quote` に締切の語句を写したなら `apply_end` を空にしない。「本日まで」「明日まで」「◯時まで」は投稿日から日付にする
+* **当選者向けの購入・受け取りの案内も `is_lottery=true` にする**（本人 2026-11-25。上の「結果報告」の決まりより優先）。「当選者の方は◯日までにご来店ください」「当選された方の購入期間」「当選確認ページはコチラ」のように、対象のトレカの抽選について当選者に購入・受け取りを案内する投稿。件は、その抽選の商品ごとに作り、`kind` は抽選の方法（店頭抽選・事前応募・オンライン抽選。分からなければ 事前応募）。当選者の購入・受け取りの期間は締切ではないので、`apply_end` は応募の締切が書いてあるときだけ入れる（無ければ null）。`reason` に「当選者向けの案内」と書く。「当選者にDMを送りました」「抽選は終了しました」「受付を終了しました」だけの結果報告は、今までどおり `is_lottery=false`
+* **応募の入口が無い「抽選販売のみ」の案内も `is_lottery=true` にする**（本人 2026-11-25。上の「販売方法の案内」の決まりより優先）。「◯◯は抽選販売のみとなります」「店頭販売（一般販売・当日販売）はございません」「当選された方のみ購入いただけます」のように、対象のトレカを抽選で売ることだけを知らせる投稿。件は、その商品ごとに作り、`kind` は 事前応募、`entry`・`platform` は `不明`、`how` と `apply_end` は null（書いていない応募先・期間を補わない）。`reason` に「抽選販売のみの案内（応募の入口なし）」と書く
diff --git a/tests/collector/test_stage2_haiku55.py b/tests/collector/test_stage2_haiku55.py
new file mode 100644
index 0000000..8946997
--- /dev/null
+++ b/tests/collector/test_stage2_haiku55.py
@@ -0,0 +1,64 @@
+"""2次判定を Haiku 5.5 に替える（本人 2026-11-25）。変数 COLLECTOR_STAGE2_POST_MODEL 1つで替えて戻せる形。"""
+import unittest
+from datetime import date
+
+from collector import config, llm, postprocess
+
+
+class 要求の形(unittest.TestCase):
+    def test_いまのモデルは今までと同じ(self):
+        p = llm.stage2_params("claude-haiku-4-5", "SYS", "本文", [])
+        self.assertEqual(p["temperature"], 0)
+        self.assertEqual(p["max_tokens"], llm.MAX_OUTPUT_TOKENS)
+        self.assertEqual(p["system"][0]["text"], "SYS")
+        self.assertEqual(llm.stage2_hash("claude-haiku-4-5"), llm.prompt_hash("stage2.md"))
+
+    def test_Haiku55は温度なし_考える分を足し_追記を足す(self):
+        p = llm.stage2_params("claude-haiku-5-5", "SYS", "本文", [])
+        self.assertNotIn("temperature", p)
+        self.assertEqual(p["max_tokens"], llm.MAX_OUTPUT_TOKENS + 16000)
+        text = p["system"][0]["text"]
+        self.assertTrue(text.startswith("SYS"))
+        self.assertIn("当選者向けの購入・受け取りの案内も `is_lottery=true`", text)
+        self.assertIn("抽選販売のみ", text)
+        self.assertNotIn("迷ったら", text)
+        self.assertNotEqual(llm.stage2_hash("claude-haiku-5-5"), llm.prompt_hash("stage2.md"))
+
+    def test_まとめの形には追記を足さない(self):
+        p = llm.stage2_params("claude-haiku-5-5", "SYS", "本文", [], llm.ROUNDUP_OUTPUT_TOKENS, llm.ROUNDUP_SCHEMA)
+        self.assertEqual(p["system"][0]["text"], "SYS")
+
+
+class 設定(unittest.TestCase):
+    def test_変数が空なら今までのモデル(self):
+        c = config.load({}, today="2026-11-25")
+        self.assertEqual(c.stage2_post_model or c.judge_model_stage2, "claude-haiku-4-5")
+
+    def test_変数で投稿の2次判定だけを替える(self):
+        c = config.load({"COLLECTOR_STAGE2_POST_MODEL": "claude-haiku-5-5"}, today="2026-11-25")
+        self.assertEqual(c.stage2_post_model, "claude-haiku-5-5")
+        self.assertEqual(c.judge_model_stage2, "claude-haiku-4-5")  # リンク先・サイト・まとめは今までどおり
+
+
+class 締切を残す直し(unittest.TestCase):
+    def test_本文に締切の文があれば残す(self):
+        item = {"apply_end": "2026-11-22", "apply_end_quote": "23:59まで"}
+        out = postprocess.check_deadline_quote(item, "応募：11月22日(日)23:59まで")
+        self.assertEqual(out["apply_end"], "2026-11-22")
+
+    def test_本文に無ければ今までどおり空にする(self):
+        item = {"apply_end": "2026-11-22", "apply_end_quote": "23:59まで"}
+        out = postprocess.check_deadline_quote(item, "11月22日発売")
+        self.assertIsNone(out["apply_end"])
+
+    def test_販売期間の型には当てない(self):
+        item = {"apply_end": "2026-09-20", "apply_end_quote": "【Aグループ】購入期間 9/16〜9/20"}
+        out = postprocess.check_deadline_quote(item, "購入期間 9/16〜9/20まで")
+        self.assertIsNone(out["apply_end"])
+
+    def test_文の当て方(self):
+        d = date(2026, 11, 25)
+        for t in ("※11月25日（水）終日で応募締切", "応募締切：11月25日(水)まで", "11/25 23:59まで", "受付期間 11/20〜11/25"):
+            self.assertTrue(postprocess.deadline_in_text(d, t), t)
+        for t in ("発売日 11/25", "11/25(水)より販売", "12/5まで", "111/25まで"):
+            self.assertFalse(postprocess.deadline_in_text(d, t), t)
```

### card-crolling PR #5（取得を1日2回・毎回判定を待つ・発見14時間・補いの口のページ・二重起動の見張り）
```diff
diff --git a/.github/workflows/daily.yml b/.github/workflows/daily.yml
index cb5e094..d9ebf54 100644
--- a/.github/workflows/daily.yml
+++ b/.github/workflows/daily.yml
@@ -65,7 +65,7 @@ jobs:
     needs: guard
     if: ${{ (github.event.schedule == '0 21 * * *' || github.event.inputs.stage == 'morning') && needs.guard.outputs.skip != '1' }}
     runs-on: ubuntu-latest
-    timeout-minutes: 120
+    timeout-minutes: 240  # 2026-11-25: 判定を待つ分（1次・2次 各45分まで）を足した
     steps:
       - uses: actions/checkout@v4
       - uses: actions/setup-python@v5
@@ -104,12 +104,27 @@ jobs:
         run: python -m collector count-probe-eval --kind sweep
       # 名簿に無い店の発見（2026-11-17 本人「抜けがないように新たな発見をするように」「動く仕組みにしろ」）。
       # 抽選の告知の検索から、名簿に無い店のアカウントを AI に確かめて足し、見つけた告知はその場で取り込む（このあとの判定に乗る）
-      - name: 名簿に無い店の発見（抽選の告知から）
+      - name: 名簿に無い店の発見（抽選の告知から。前の回（18時）から12時間あくので 14時間）
         if: ${{ !cancelled() }}
-        run: python -m collector x-discover --lookback-hours 6 --max-pages 40 --max-ask 30 --max-usd 0.3
+        run: python -m collector x-discover --lookback-hours 14 --max-pages 40 --max-ask 30 --max-usd 0.3
       - name: 判定（1次はバッチで送る）
         if: ${{ !cancelled() }}
         run: python -m collector judge
+      # **判定を便の中で受け取る**（本人 2026-11-25「判定を待って受け取る形を、毎回使う」）。終わらなければ 8:30 の collect で受け取る
+      - name: 1次判定のバッチが終わるまで待つ（45分まで）
+        if: ${{ !cancelled() }}
+        timeout-minutes: 50
+        run: python -m collector wait-batch --max-minutes 45 --poll-seconds 30
+      - name: 1次判定を受け取り、2次判定を送る
+        if: ${{ !cancelled() }}
+        run: python -m collector judge
+      - name: 2次判定のバッチが終わるまで待つ（45分まで）
+        if: ${{ !cancelled() }}
+        timeout-minutes: 50
+        run: python -m collector wait-batch --max-minutes 45 --poll-seconds 30
+      - name: 2次判定を受け取る
+        if: ${{ !cancelled() }}
+        run: python -m collector judge
   collect:
     needs: guard
     if: ${{ (github.event.schedule == '30 23 * * *' || github.event.inputs.stage == 'collect') && needs.guard.outputs.skip != '1' }}
diff --git a/.github/workflows/every3h.yml b/.github/workflows/every3h.yml
index 68bf028..601decd 100644
--- a/.github/workflows/every3h.yml
+++ b/.github/workflows/every3h.yml
@@ -1,12 +1,11 @@
-# 3時間ごとの取得（本人 2026-11-17「3時間に一回」）。
-# 1日1回だと、朝の取得のあとに出た告知が翌朝まで載らなかった（11/17 トレゲトとの突き合わせで 39件）。
-# 取得は前回の続きからしか読まないので、回数を増やしても読む投稿の数はほぼ同じ（1回ごとの上乗せは約 $0.13）。
-# **判定の受け取りを待たない**: 各回の頭で前の回に送った判定（バッチ）を受け取り、終わりに今回の分を送る。
-# 待つと runner の時間（お金）を使うため。朝 06:00 と 08:30 は daily.yml が動くので、その時刻は外す。
+# 夕方の取得（18:00 JST）。本人 2026-11-25「取得を1日2回（6時・18時）にする。判定を待って受け取る形を、毎回使う」。
+# 前は3時間ごと（本人 2026-11-17）。朝 06:00 は daily.yml の morning が動く。ファイル名は cardbot の心拍（COLLECTOR_DONE_EXTRA）と
+# 止まりの知らせが読むので変えない。取得は前回の続きから（1時間重ね）読むので、12時間あいても読む投稿は同じ。
+# **判定は便の中で待って受け取る**: 1次と2次のバッチが終わるまで待ち、結果を受け取ってからリンク先へ進む（次の回まで12時間待たせない）。
 name: every3h
 on:
   schedule:
-    - cron: "0 15,18,0,3,6,9,12 * * *" # JST 00:00 / 03:00 / 09:00 / 12:00 / 15:00 / 18:00 / 21:00
+    - cron: "0 9 * * *" # JST 18:00（本人 2026-11-25）
   workflow_dispatch:
 concurrency:
   group: collector
@@ -24,9 +23,36 @@ env:
   JP_FETCH_TOKEN: ${{ secrets.JP_FETCH_TOKEN }}
   PYTHONUNBUFFERED: "1"
 jobs:
+  # 2026-11-25: 18時の回は cardbot（Vercel）が時刻どおりに workflow_dispatch で起こす。GitHub の定期実行は保険として残し、
+  # 今日の 17時（JST）より後に手動の起動（Vercel か人）で同じ便が走っていれば何もしない（daily.yml の guard と同じ形）。
+  # 手動の回が失敗していたら走る。履歴が読めないときは走る（落とすより重ねる方を選ぶ）
+  guard:
+    runs-on: ubuntu-latest
+    timeout-minutes: 5
+    permissions:
+      actions: read
+      contents: read
+    outputs:
+      skip: ${{ steps.g.outputs.skip }}
+    steps:
+      - id: g
+        env:
+          GH_TOKEN: ${{ github.token }}
+        run: |
+          if [ "${{ github.event_name }}" != "schedule" ]; then echo "skip=0" >> "$GITHUB_OUTPUT"; exit 0; fi
+          since=$(date -u -d "$(TZ=Asia/Tokyo date +%F) 17:00 +0900" +%Y-%m-%dT%H:%M:%SZ)
+          n=$(gh api -X GET "repos/${{ github.repository }}/actions/workflows/every3h.yml/runs" -f event=workflow_dispatch -f per_page=20 -f "created=>=$since" --jq '[.workflow_runs[] | select(.conclusion == "success" or .status != "completed")] | length' 2>/dev/null) || n=0
+          if [ "${n:-0}" -gt 0 ]; then
+            echo "今日すでに手動の起動で夕方の便が走ったので、定期実行は何もしない"
+            echo "skip=1" >> "$GITHUB_OUTPUT"
+          else
+            echo "skip=0" >> "$GITHUB_OUTPUT"
+          fi
   cycle:
+    needs: guard
+    if: ${{ needs.guard.outputs.skip != '1' }}
     runs-on: ubuntu-latest
-    timeout-minutes: 90  # 2026-11-17: 初回が名寄せの鍵待ちで 60分の時間切れになった
+    timeout-minutes: 180  # 2026-11-17: 初回が名寄せの鍵待ちで 60分の時間切れ。2026-11-25: 12時間分の取得と、判定を待つ分（1次・2次 各45分まで）を足した
     steps:
       - uses: actions/checkout@v4
       - uses: actions/setup-python@v5
@@ -53,36 +79,27 @@ jobs:
         continue-on-error: true
         timeout-minutes: 10
         run: python -m collector count-probe-eval --kind supplement
-      - name: 名簿に無い店の発見（直近 6時間の抽選の告知から。GitHub の定期実行の遅れに備えて重ねる）
+      - name: 名簿に無い店の発見（直近 14時間の抽選の告知から。前の回から12時間あくので、定期実行の遅れの分も重ねる）
         if: ${{ !cancelled() }}
-        run: python -m collector x-discover --lookback-hours 6 --max-pages 40 --max-ask 30 --max-usd 0.3
+        run: python -m collector x-discover --lookback-hours 14 --max-pages 40 --max-ask 30 --max-usd 0.3
       - name: 判定（今回取った分を送る）
         if: ${{ !cancelled() }}
         run: python -m collector judge
-      # **判定の結果を次の回まで待たずに受け取る試し**（2026-11-24 本人「次の1回（12時の回）だけ、この形で動かして測る。そのあとは前の動きに戻す」）。
-      # 動くのは JUDGE_WAIT_IN_RUN に書いた日と時（JST・「2026-11-24T12」）に始まった回だけ（遅れて13時台に始まった回も含む）。空にすれば前の動き。
-      # 待つのは 1次・2次で 10分ずつ（計 20分まで）。終わらなければ、今までどおり次の回で受け取る（費用は掛からない）
-      - name: 判定を同じ便の中で受け取る試しの回か
-        id: jw
+      # **判定を便の中で受け取る**（本人 2026-11-25「判定を待って受け取る形を、毎回使う」。11/24 12時の回の試しと同じ形）。
+      # 1次・2次のバッチが終わるまで 45分ずつ待つ。終わらなければ、今までどおり次の回（翌朝6時）で受け取る（費用は掛からない）
+      - name: 1次判定のバッチが終わるまで待つ（45分まで）
+        if: ${{ !cancelled() }}
+        timeout-minutes: 50
+        run: python -m collector wait-batch --max-minutes 45 --poll-seconds 30
+      - name: 1次判定を受け取り、2次判定を送る
         if: ${{ !cancelled() }}
-        env:
-          JUDGE_WAIT_IN_RUN: "2026-11-24T12"
-        run: |
-          now=$(TZ=Asia/Tokyo date +%Y-%m-%dT%H); next=$(TZ=Asia/Tokyo date -d '-1 hour' +%Y-%m-%dT%H)
-          if [ -n "$JUDGE_WAIT_IN_RUN" ] && { [ "$now" = "$JUDGE_WAIT_IN_RUN" ] || [ "$next" = "$JUDGE_WAIT_IN_RUN" ]; }; then echo "on=1" >> "$GITHUB_OUTPUT"; echo "試しの回（$now）"; else echo "on=0" >> "$GITHUB_OUTPUT"; fi
-      - name: 試し：1次判定のバッチが終わるまで待つ（10分まで）
-        if: ${{ !cancelled() && steps.jw.outputs.on == '1' }}
-        timeout-minutes: 12
-        run: python -m collector wait-batch --max-minutes 10 --poll-seconds 30
-      - name: 試し：1次判定を受け取り、2次判定を送る
-        if: ${{ !cancelled() && steps.jw.outputs.on == '1' }}
         run: python -m collector judge
-      - name: 試し：2次判定のバッチが終わるまで待つ（10分まで）
-        if: ${{ !cancelled() && steps.jw.outputs.on == '1' }}
-        timeout-minutes: 12
-        run: python -m collector wait-batch --max-minutes 10 --poll-seconds 30
-      - name: 試し：2次判定を受け取る
-        if: ${{ !cancelled() && steps.jw.outputs.on == '1' }}
+      - name: 2次判定のバッチが終わるまで待つ（45分まで）
+        if: ${{ !cancelled() }}
+        timeout-minutes: 50
+        run: python -m collector wait-batch --max-minutes 45 --poll-seconds 30
+      - name: 2次判定を受け取る
+        if: ${{ !cancelled() }}
         run: python -m collector judge
       - name: リンク先の締切
         if: ${{ !cancelled() }}
diff --git a/collector/config.py b/collector/config.py
index c857429..3e8576d 100644
--- a/collector/config.py
+++ b/collector/config.py
@@ -82,7 +82,7 @@ class Config:
     stop_after_503: int = 10
     #: 503 の束を半分に割って投げ直す（2026-11-24 本人 F-1）。0 で前の動き（割らない）に戻す
     split_503: bool = False  # 9時の回で便が長くなりすぎたので既定は割らない（2026-11-24）
-    zero_posts_runs: int = 3
+    zero_posts_runs: int = 2  # 2026-11-25: 取得が1日2回になったので、3回続けて0件（36時間）では気づくのが遅い。2回（24時間）
     image_store: str = "none"
 
     def secrets(self) -> tuple[str, ...]:
@@ -197,7 +197,7 @@ def load(env: Mapping[str, str] | None = None, today: str | None = None) -> Conf
         stop_after_503=_int(env, "COLLECTOR_STOP_AFTER_503", 10),
         # 既定は割らない（2026-11-24 9時の回: 503 の待ちがふくらみ、2分で15店しか進まず便の上限 90分に当たる見込みになった）。"1" で割る形
         split_503=env.get("COLLECTOR_SPLIT_503", "0").strip() == "1",
-        zero_posts_runs=_int(env, "COLLECTOR_ZERO_POSTS_RUNS", 3),
+        zero_posts_runs=_int(env, "COLLECTOR_ZERO_POSTS_RUNS", 2),
         image_store=_text(env, "COLLECTOR_IMAGE_STORE", "none"),
     )
 
diff --git a/collector/fetch.py b/collector/fetch.py
index 88e92c9..0667dd5 100644
--- a/collector/fetch.py
+++ b/collector/fetch.py
@@ -18,7 +18,7 @@
 from collector import supplement_gate, x_budget
 from collector.clock import JST
 from collector.config import Config
-from collector.sources.base import Post, Source
+from collector.sources.base import Page, Post, Source
 
 #: 初めて取る handle をどこまで遡るか・取り直しの重なり（重なりは post_id で吸収）
 INITIAL_LOOKBACK = timedelta(hours=24)
@@ -27,6 +27,10 @@
 TIMELINE_AFTER = timedelta(days=14)
 #: 補いの口で取る投稿の古さの上限（最新20件のうち、これより古いものは保存しない）
 TIMELINE_LOOKBACK = timedelta(days=7)
+#: 補いの口で次のページも読む範囲（本人 2026-11-25「取得を1日2回（6時・18時）にする」「12時間あいても取りこぼさず」）。
+#: 1ページ（20件）がみなこれより新しければ、前の回からのあいだに20件を超えて出した店なので、次のページも読む。12時間＋重ね
+TIMELINE_REACH = timedelta(hours=14)
+TIMELINE_MAX_PAGES = 5
 #: 同時に取る束の数（2026-10-08 本人「4も直したい」→「はい進めていいです」。1本ずつ順に取って毎朝 約30分かかり、Actions の時間を使っていた）。
 #: 取るのだけを並べ、保存・cursor・数えは今までどおり束の順に 1本ずつ（中身は変わらない）
 FETCH_WORKERS = 4
@@ -250,7 +254,30 @@ def supplement() -> None:
 
         def pull_timeline(h):
             try:
-                return send(lambda: fetch_timeline(h)), None
+                get_page = getattr(source, "fetch_timeline_page", None)
+                if get_page is None:
+                    return send(lambda: fetch_timeline(h)), None
+                # 1ページ（最新20件）の最後の投稿がまだ TIMELINE_REACH より新しければ、次のページも読む（1日2回の便で、あいだに20件を超えて出した店を落とさない）
+                got, broken, cur = [], [], ""
+                for _ in range(TIMELINE_MAX_PAGES):
+                    box: dict = {}
+
+                    def call(c=cur, box=box):
+                        pg, box["next"] = get_page(h, c)
+                        return pg
+
+                    pg = send(call)
+                    if pg is BLOCKED:
+                        if not got:
+                            return BLOCKED, None
+                        break
+                    got += pg.posts
+                    broken += pg.broken
+                    cur = box.get("next") or ""
+                    mine = [p for p in pg.posts if p.handle == h.lower()]
+                    if not cur or not mine or mine[-1].posted_at < now - TIMELINE_REACH:
+                        break
+                return Page(posts=tuple(got), cost_usd=0.0, last=True, broken=tuple(broken)), None
             except Exception as e:  # 1アカウントの失敗は1アカウントで終わらせる
                 return None, e
 
diff --git a/tests/collector/test_judge_wait_in_run.py b/tests/collector/test_judge_wait_in_run.py
index 6ea7ab1..2f0f656 100644
--- a/tests/collector/test_judge_wait_in_run.py
+++ b/tests/collector/test_judge_wait_in_run.py
@@ -16,15 +16,18 @@ def test_待つ間隔を短くできる(self):
         self.assertEqual((a.max_minutes, a.poll_seconds), (10, 30))
         self.assertEqual(cli.build_parser().parse_args(["wait-batch"]).poll_seconds, 300, "毎日の便は今までどおり5分おき")
 
-    def test_試しの段は決めた回だけ動き_待つのは計20分まで(self):
-        steps = yaml.safe_load(open(WF, encoding="utf-8"))["jobs"]["cycle"]["steps"]
-        names = [s.get("name", "") for s in steps]
-        i = names.index("判定（今回取った分を送る）")
-        trial = steps[i + 2 : i + 6]
-        self.assertTrue(all("steps.jw.outputs.on == '1'" in s["if"] for s in trial))
-        waits = [s for s in trial if "wait-batch" in s["run"]]
-        self.assertEqual(sum(int(s["run"].split("--max-minutes ")[1].split()[0]) for s in waits), 20)
-        self.assertEqual(names[i + 6], "リンク先の締切", "試しのあとは今までどおりリンク先へ")
+    def test_毎回_判定を待って受け取ってからリンク先へ(self):
+        """本人 2026-11-25「判定を待って受け取る形を、毎回使う」。日付の条件は付けない。待つのは 1次・2次で 45分ずつ。"""
+        for wf, job in ((WF, "cycle"), (os.path.join(os.path.dirname(WF), "daily.yml"), "morning")):
+            steps = yaml.safe_load(open(wf, encoding="utf-8"))["jobs"][job]["steps"]
+            runs = [s.get("run", "") for s in steps]
+            first = runs.index("python -m collector wait-batch --max-minutes 45 --poll-seconds 30")
+            self.assertEqual(runs[first - 1], "python -m collector judge", wf)
+            self.assertEqual(runs[first : first + 4], ["python -m collector wait-batch --max-minutes 45 --poll-seconds 30", "python -m collector judge",
+                                                      "python -m collector wait-batch --max-minutes 45 --poll-seconds 30", "python -m collector judge"], wf)
+            for s in steps[first : first + 4]:
+                self.assertNotIn("steps.jw", s.get("if", ""), wf)
+        self.assertIn('cron: "0 9 * * *"', open(WF, encoding="utf-8").read(), "夕方 18時（JST）の1回だけ")
 
 
 if __name__ == "__main__":
diff --git a/tests/collector/test_lessons_ops.py b/tests/collector/test_lessons_ops.py
index 6e89852..bcc70c9 100644
--- a/tests/collector/test_lessons_ops.py
+++ b/tests/collector/test_lessons_ops.py
@@ -80,11 +80,11 @@ def test_case18_RetryAfter120は待たずにrate_limited(self):
 
     def test_case19_取得0件が続いたら異常(self):
         db = FakeDb()
-        results = [run(db, FakeSource([[page([])]]), now=NOW + timedelta(hours=i)) for i in range(3)]
-        self.assertEqual([r.note for r in results[:2]], [None, None])  # 1回の0件は「無かった」として1行残すだけ
-        self.assertEqual(len(db.runs), 3)
-        self.assertIn("zero_posts", results[2].note)  # COLLECTOR_ZERO_POSTS_RUNS=3 回続いたら鳴らす
-        self.assertEqual(results[2].exit_code, 1)
+        results = [run(db, FakeSource([[page([])]]), now=NOW + timedelta(hours=12 * i)) for i in range(2)]
+        self.assertEqual(results[0].note, None)  # 1回の0件は「無かった」として1行残すだけ
+        self.assertEqual(len(db.runs), 2)
+        self.assertIn("zero_posts", results[1].note)  # 1日2回の便（2026-11-25）なので、COLLECTOR_ZERO_POSTS_RUNS=2 回（24時間）続いたら鳴らす
+        self.assertEqual(results[1].exit_code, 1)
 
     def test_case20_upsertは冪等(self):
         db = FakeDb()
@@ -554,3 +554,39 @@ def post(self, url, json=None):
         self.assertEqual(db.runs[0][1][0]["sent"], True)
         self.assertEqual(db.runs[0][1][0]["kind"], "alert")
         self.assertIsNone(db.runs[0][1][1])
+
+
+class 補いの口を次のページまで(unittest.TestCase):
+    """本人 2026-11-25「取得を1日2回（6時・18時）にする」「12時間あいても取りこぼさず」。1ページ（20件）がみな新しければ次のページも読む。"""
+
+    def src_with_pages(self, pages):
+        src = FakeSource([[page([post(1, "shop_a")])]])
+        calls = []
+
+        def get_page(h, cursor=""):
+            calls.append(cursor)
+            n = int(cursor or 0)
+            return pages[n], (str(n + 1) if n + 1 < len(pages) else "")
+        src.fetch_timeline_page = get_page
+        src.fetch_timeline = lambda h: (_ for _ in ()).throw(AssertionError("1ページの口は使わない"))
+        return src, calls
+
+    def test_最後の投稿がまだ新しければ次のページも読む(self):
+        p1 = page([post(10 + i, "shop_b", minutes_ago=30 + i) for i in range(20)])  # 20件とも直近
+        p2 = page([post(40, "shop_b", minutes_ago=60 * 10), post(41, "shop_b", minutes_ago=60 * 20)])  # 10時間前・20時間前
+        src, calls = self.src_with_pages([p1, p2, page([post(60, "shop_b", minutes_ago=60 * 30)])])
+        r = run(FakeDb(blind=["shop_b"]), src)
+        self.assertEqual(calls, ["", "1"])  # 20時間前まで届いたので3ページ目は読まない
+        self.assertEqual(r.counts["timeline_new"], 22)
+
+    def test_1ページ目で古い投稿まで届けば次は読まない(self):
+        p1 = page([post(10, "shop_b", minutes_ago=30), post(11, "shop_b", minutes_ago=60 * 20)])
+        src, calls = self.src_with_pages([p1, page([post(60, "shop_b")])])
+        run(FakeDb(blind=["shop_b"]), src)
+        self.assertEqual(calls, [""])
+
+    def test_読むのは5ページまで(self):
+        pages = [page([post(100 * k + i, "shop_b", minutes_ago=10 + k) for i in range(20)]) for k in range(8)]
+        src, calls = self.src_with_pages(pages)
+        run(FakeDb(blind=["shop_b"]), src)
+        self.assertEqual(len(calls), fetch.TIMELINE_MAX_PAGES)
```

### card-crolling PR #6（朝の見回りの二重払いを止める）
```diff
diff --git a/collector/sweep_gate.py b/collector/sweep_gate.py
index e2c1b84..a5bb4dd 100644
--- a/collector/sweep_gate.py
+++ b/collector/sweep_gate.py
@@ -117,3 +117,54 @@ def read_one(get_page, handle: str, since: datetime, max_pages: int = MAX_PAGES)
 def search_stopped(note: str | None) -> bool:
     words = [w.strip() for w in (note or "").split(",")]
     return any(w in SEARCH_STOP_WORDS for w in words)
+
+
+# ── 検索が動いた朝の二重払いを止める（本人 2026-11-25「朝の見回りの二重払いを止める」） ──
+# 店ごとに「前に読んでからの投稿数の増え」と「その間に DB に入った（検索などで取れた）その店の投稿の数」を比べ、同じならその店は読まない。
+# 合わない店・数が読めない店・前回の記録が無い店は今までどおり読む。
+# 最初は試し（shadow）: 読まないと判定した店も今までどおり読み、新しく入った投稿（取りこぼし）を数えて記録する。
+# 取りこぼし 0件の試しの日があれば、次の回から読まない形（on）になる。設定 intake.setting の sweep_skip で off / shadow / on に固定できる
+SKIP_SETTING = "sweep_skip"
+
+
+def skip_mode(db) -> str:
+    """'off' / 'shadow' / 'on'。設定があればそれ。無ければ、最後の試しの記録で取りこぼしが0件なら on、それ以外は shadow。"""
+    try:
+        v = (db.setting(SKIP_SETTING) or "").strip() if hasattr(db, "setting") else ""
+    except Exception:  # noqa: BLE001
+        v = ""
+    if v in ("off", "shadow", "on"):
+        return v
+    last = None
+    try:
+        last = db.rows("""select counts -> 'skip_shadow' from intake.run where command = 'timeline-sweep' and finished_at is not null
+                          and counts ? 'skip_shadow' order by started_at desc limit 1""")  # fmt: skip
+    except Exception:  # noqa: BLE001
+        return "shadow"
+    rec = last[0][0] if last and last[0] else None
+    if not isinstance(rec, dict):
+        return "shadow"
+    return "on" if rec.get("would_skip", 0) > 0 and not rec.get("misses") and not rec.get("unchecked") else "shadow"
+
+
+def posts_since(db, since_of: dict[str, datetime], now: datetime) -> dict[str, int]:
+    """店ごとに、その時刻より後に投稿され DB に入っている投稿の数（lower(handle) で数える）。"""
+    if not since_of:
+        return {}
+    hs = list(since_of)
+    rows = db.rows("""select b.h, count(p.post_id) from unnest(%s::text[], %s::timestamptz[]) as b(h, at)
+                      left join intake.post p on lower(p.handle) = b.h and p.posted_at > b.at and p.posted_at <= %s
+                      group by b.h""", ([h.lower() for h in hs], [since_of[h] for h in hs], now))  # fmt: skip
+    got = {h: int(n) for h, n in rows}
+    return {h: got.get(h.lower(), 0) for h in hs}
+
+
+def same_count(handles: list[str], counts_now: dict, base: dict[str, tuple[int, datetime]], have: dict[str, int]) -> list[str]:
+    """投稿数の増えと、DB に入った投稿の数が同じ店（読まなくてよい店）。"""
+    out = []
+    for h in handles:
+        n, b = counts_now.get(h), base.get(h)
+        if isinstance(n, int) and b is not None and h in have and n - b[0] == have[h]:
+            out.append(h)
+    return out
+
diff --git a/collector/timeline_sweep.py b/collector/timeline_sweep.py
index 9fc2f8a..0a58291 100644
--- a/collector/timeline_sweep.py
+++ b/collector/timeline_sweep.py
@@ -81,9 +81,24 @@ def run(cfg, db, now: datetime, max_usd: float = MAX_USD, source=None, workers:
     if gated:
         p = sweep_gate.plan(hs, counts_now, base, now)
         hs, since_of = p.read, p.since
+    # **検索が動いた朝の二重払いを止める**（本人 2026-11-25）: 投稿数の増えと、その間に DB に入った投稿の数が同じ店は読まない（試しの間は読んで確かめる）
+    mode, would_skip = ("gated" if gated else sweep_gate.skip_mode(db)), []
+    if not gated and mode != "off" and base and counts_now:
+        try:
+            have = sweep_gate.posts_since(db, {h: base[h][1] for h in hs if h in base}, now)
+            would_skip = sweep_gate.same_count(hs, counts_now, base, have)
+        except Exception:  # noqa: BLE001  数えられないときは今までどおり全部読む
+            would_skip, mode = [], "shadow"
+    total = len(hs)
+    if mode == "on":
+        skip_set = set(would_skip)
+        hs = [h for h in hs if h not in skip_set]
     counts, cost, stopped = Counter(handles=len(hs)), 0.0, False
     if gated:
         counts["gated_skipped"] = len(p.skipped)
+    if mode == "on":
+        counts["skipped_same_count"] = total - len(hs)
+    new_by: dict[str, int] = {}
     read_ok: set[str] = set()
     step = max(1, workers * 5)
     # X の1日の上限: 1回分（step 店 × 最大ページ）の最悪の額を残して止める（超えそうになったら止める・上限は超えない）
@@ -104,6 +119,7 @@ def run(cfg, db, now: datetime, max_usd: float = MAX_USD, source=None, workers:
                 failed = []
                 if posts:
                     new, dup, failed = db.upsert_posts(posts, now)
+                    new_by[h] = new
                     counts["posts_new"] += new
                     counts["posts_dup"] += dup
                     counts["posts_failed"] += len(failed)
@@ -112,6 +128,12 @@ def run(cfg, db, now: datetime, max_usd: float = MAX_USD, source=None, workers:
                 counts["swept"] += 1
     out = dict(counts)
     out["mode"] = "gated" if gated else "full"
+    out["skip_mode"] = mode
+    if mode == "shadow" and would_skip:
+        # 試し: 読まないと判定した店も読んだ。そこで新しく入った投稿があれば、それが「読まなかったら落としていた」投稿
+        swept = read_ok | set(new_by)
+        out["skip_shadow"] = {"would_skip": len(would_skip), "misses": sorted(h for h in would_skip if new_by.get(h, 0) > 0),
+                              "unchecked": sorted(h for h in would_skip if h not in swept)}
     # 読んだ店の投稿数と時刻を残す（検索が止まった回の「前回」・collector/sweep_gate.py）。投稿数の記録が無い回は前の値を持ち越す
     if hasattr(db, "sweep_base"):
         out["sweep_base"] = sweep_gate.dump_base(sweep_gate.next_base(base, {h: n for h, n in counts_now.items() if isinstance(n, int)}, read_ok, now))
diff --git a/tests/collector/test_sweep_gate.py b/tests/collector/test_sweep_gate.py
index 8df8dba..4f80d4e 100644
--- a/tests/collector/test_sweep_gate.py
+++ b/tests/collector/test_sweep_gate.py
@@ -215,3 +215,62 @@ def test_前回の記録が無ければ止まった朝でも全部読む(self):
 
 if __name__ == "__main__":
     unittest.main()
+
+
+class 朝の見回りの二重払いを止める(unittest.TestCase):
+    """本人 2026-11-25「店ごとに、前に読んでからの投稿数の増えと、その間に検索で取れた件数を比べる。同じなら、その店は読まない」
+    「最初の1日は、読まないと判定した店も今までどおり読んで、取りこぼしが0件かを確かめる」。"""
+
+    class Db(朝の見回りで.Db):
+        def __init__(self, base, users, have, setting=None, last_shadow=None):
+            super().__init__(None, base, users)
+            self.have, self.set, self.last_shadow = have, setting, last_shadow
+
+        def setting(self, key):
+            return self.set
+
+        def rows(self, sql, params=None):
+            if "skip_shadow" in sql:
+                return [(self.last_shadow,)] if self.last_shadow is not None else []
+            if "unnest" in sql:
+                return [(h, self.have.get(h, 0)) for h in params[0]]
+            return [(h,) for h in ("up", "same")]
+
+    B = 朝の見回りで.B
+    U = {"up": {"n": 11}, "same": {"n": 6}}  # up は 1件増え、same も 1件増えた
+
+    def _src(self):
+        return Pages({"up": [([post(1, "up", 1), post(2, "up", 4)], "c"), ([post(4, "up", 30)], "")], "same": [([post(3, "same", 2)], "")]})
+
+    def test_最初は試し_読まない判定の店も読んで取りこぼしを数える(self):
+        # same: 増え 1・DB に入った 1 → 読まない判定。でも試しなので読む。読んだら新しい投稿 3 が入った → 取りこぼし
+        src, db = self._src(), self.Db(self.B, self.U, {"up": 0, "same": 1})
+        got = timeline_sweep.run(None, db, NOW, source=src, workers=1)
+        self.assertEqual(got["skip_mode"], "shadow")
+        self.assertEqual(sorted({h for h, _ in src.calls}), ["same", "up"])
+        self.assertEqual(db.finished[0]["skip_shadow"], {"would_skip": 1, "misses": ["same"], "unchecked": []})
+
+    def test_取りこぼし0件の試しの次からは読まない(self):
+        src, db = self._src(), self.Db(self.B, self.U, {"up": 0, "same": 1}, last_shadow={"would_skip": 5, "misses": [], "unchecked": []})
+        got = timeline_sweep.run(None, db, NOW, source=src, workers=1)
+        self.assertEqual(got["skip_mode"], "on")
+        self.assertEqual({h for h, _ in src.calls}, {"up"})
+        self.assertEqual(got["skipped_same_count"], 1)
+        self.assertEqual(db.finished[0]["sweep_base"]["same"][0], 5, "読まなかった店は前回の記録を持ち越す（次の朝も同じ比べ方）")
+
+    def test_試しで取りこぼしがあれば読まない形にしない(self):
+        src, db = self._src(), self.Db(self.B, self.U, {"up": 0, "same": 1}, last_shadow={"would_skip": 5, "misses": ["x"], "unchecked": []})
+        self.assertEqual(timeline_sweep.run(None, db, NOW, source=src, workers=1)["skip_mode"], "shadow")
+
+    def test_数が合わない店_数が読めない店は読む(self):
+        users = {"up": {"n": 11}}  # same の数は読めない
+        src, db = self._src(), self.Db(self.B, users, {"up": 2, "same": 0}, setting="on")  # up は増え1・DB 2 → 合わない
+        got = timeline_sweep.run(None, db, NOW, source=src, workers=1)
+        self.assertEqual(sorted({h for h, _ in src.calls}), ["same", "up"])
+        self.assertEqual(got.get("skipped_same_count"), 0)
+
+    def test_設定で止められる(self):
+        src, db = self._src(), self.Db(self.B, self.U, {"up": 0, "same": 1}, setting="off")
+        got = timeline_sweep.run(None, db, NOW, source=src, workers=1)
+        self.assertEqual(got["skip_mode"], "off")
+        self.assertNotIn("skip_shadow", db.finished[0])
```

### cardbot PR #1870（止まりの知らせ・18時の回を起こす・一覧の古さ）
```diff
diff --git a/web/app/api/stop-alert/route.js b/web/app/api/stop-alert/route.js
index 2cca1c629..5a263caaa 100644
--- a/web/app/api/stop-alert/route.js
+++ b/web/app/api/stop-alert/route.js
@@ -204,7 +204,7 @@ export async function GET(request) {
       { kind: "start", key: "fail2:nyuka-watch.yml", detail: "（試し）nyuka-watch の直近2回: failure・failure" },
       { kind: "start", key: "kv:site", detail: "（試し）site の KV: HTTP 400" },
       { kind: "start", key: "api:openai", detail: "（試し）openai: 残高切れ" },
-      { kind: "start", key: "late:every3h.yml", detail: "（試し）3時間ごとの便: 予定から60分たってまだ始まっていない" },
+      { kind: "start", key: "late:every3h.yml", detail: "（試し）夕方の便（18時）: 予定から60分たってまだ始まっていない" },
       { kind: "recover", key: "lotteries_stale", detail: "（試し）戻ったときはこの形で1回だけ届きます", since: now - 3600000 },
     ];
     // 送れなかった種類だけを、次の回に流し直す（送れたものは二度送らない）
diff --git a/web/app/api/watch/crawl.mjs b/web/app/api/watch/crawl.mjs
index 36812589b..9323f1d29 100644
--- a/web/app/api/watch/crawl.mjs
+++ b/web/app/api/watch/crawl.mjs
@@ -161,6 +161,9 @@ export const COLLECTOR_JOBS = [
   { key: "sites", hour: 7, workflow: "sites.yml", inputs: {}, title: "sites" },
   { key: "roundup", hour: 8, workflow: "roundup.yml", inputs: {}, title: "roundup" },
   { key: "collect", hour: 8, min: 30, workflow: "daily.yml", inputs: { stage: "collect" }, title: "daily collect" },
+  // 夕方の取得（2026-11-25 本人「取得を1日2回（6時・18時）にする」）。1日1回の便は GitHub の定期実行の遅れ（2〜3時間）がそのまま
+  // 結果の遅れになるので、朝の回と同じくこちらで時刻を持って起こす。向こうの定期実行は保険（今日すでに起こした回があれば何もしない）
+  { key: "evening", hour: 18, workflow: "every3h.yml", inputs: {}, title: "every3h" },
 ];
 
 /* cardbot 自身の workflow を時刻どおりに起こす（収集 v2 の回と同じ仕掛け）。
diff --git a/web/app/api/watch/crawl.test.mjs b/web/app/api/watch/crawl.test.mjs
index c214fe6bc..898bd82d5 100644
--- a/web/app/api/watch/crawl.test.mjs
+++ b/web/app/api/watch/crawl.test.mjs
@@ -336,6 +336,7 @@ test("収集の朝の回: 6:00 morning・7:00 sites・8:00 roundup・8:30 collec
     ["sites", 7, 0, "sites.yml", "sites"],
     ["roundup", 8, 0, "roundup.yml", "roundup"],
     ["collect", 8, 30, "daily.yml", "daily collect"],
+    ["evening", 18, 0, "every3h.yml", "every3h"],
   ]);
   assert.deepEqual(回("morning").inputs, { stage: "morning" });
   assert.deepEqual(回("collect").inputs, { stage: "collect" });
diff --git a/web/app/api/watch/heartbeat.mjs b/web/app/api/watch/heartbeat.mjs
index 6bb5cf028..3a81b4014 100644
--- a/web/app/api/watch/heartbeat.mjs
+++ b/web/app/api/watch/heartbeat.mjs
@@ -254,7 +254,7 @@ export async function checkHeartbeat({ now = new Date(), lastRun, kv, dispatch,
    11/17 に収集が 3時間ごとの便を足したのに、ここが daily / sites / roundup しか見ていなかったので、
    3時間ごとの便が取った抽選は、ほかの便が成功するか定時の巡回が来るまで画面に出なかった
    （11/22 は 15:27〜20:50 の約5時間20分、一覧が止まった。11/17〜11/22 の遅れの中央 1.4時間・最長 32.3時間）。
-   **COLLECTOR_JOBS には足さない**（あちらは Vercel が時刻で起こす名簿。every3h は GitHub の定期実行で動く）。 */
+   2026-11-25: every3h は 18時の1回になり、COLLECTOR_JOBS（Vercel が時刻で起こす名簿）にも入った。重ねて書いても1つに数える。 */
 export const COLLECTOR_DONE_EXTRA = ["every3h.yml"];
 
 export function collectorWorkflows(jobs) {
diff --git a/web/app/api/watch/heartbeat.test.mjs b/web/app/api/watch/heartbeat.test.mjs
index ce3ed1b8b..9849a02cf 100644
--- a/web/app/api/watch/heartbeat.test.mjs
+++ b/web/app/api/watch/heartbeat.test.mjs
@@ -451,7 +451,8 @@ const 成功 = (h, m = 0) => ({ conclusion: "success", updated_at: jst(h, m).toI
 
 test("見る便に 3時間ごとの便を足す。時刻で起こす名簿には足さない（2026-11-22）", () => {
   assert.deepEqual(collectorWorkflows(COLLECTOR_JOBS), ["daily.yml", "sites.yml", "roundup.yml", "every3h.yml"]);
-  assert.ok(!COLLECTOR_JOBS.some((j) => j.workflow === "every3h.yml"), "every3h を Vercel が時刻で起こすことになる");
+  // 2026-11-25: every3h は 18時の1回になり、Vercel が時刻で起こす名簿にも入った（二重に数えない）
+  assert.equal(collectorWorkflows(COLLECTOR_JOBS).filter((w) => w === "every3h.yml").length, 1);
 });
 
 test("3時間ごとの便が前回の巡回のあとに成功していれば起こす（2026-11-22）", async () => {
diff --git a/web/app/lib/stop-alert.mjs b/web/app/lib/stop-alert.mjs
index 9e0a39c10..78961e4c3 100644
--- a/web/app/lib/stop-alert.mjs
+++ b/web/app/lib/stop-alert.mjs
@@ -21,9 +21,11 @@
    DB は便の間に止まっていて、10分おきに起こすと計算の額が増える）。GitHub は窓口（REST）だけを読み、GitHub の定期実行には頼らない。 */
 
 export const JST_MS = 9 * 3600 * 1000;
-export const DAY_LIMIT_H = 3;
+// 昼の基準は 5時間（2026-11-25: 収集の取得が1日2回（6時・18時）になり、3時間ごとの便のあとの巡回が無くなった。
+// 一覧を書く巡回は 6・9:12・13・15:12・18時の便のあと・21:12・22時で、昼のあいだは最大で約4.5時間あく。3時間のままだと毎日誤って鳴る）
+export const DAY_LIMIT_H = 5;
 export const NIGHT_LIMIT_H = 8;
-/** 昼（この時から24時まで）は3時間で鳴らす。 */
+/** 昼（この時から24時まで）は DAY_LIMIT_H 時間で鳴らす。 */
 export const DAY_START_HOUR = 9;
 /** 便が始まるまでの猶予（予定の時刻から） */
 export const LATE_MIN = 60;
@@ -78,7 +80,8 @@ export function checkApis(health, at) {
 
 /* ── 収集の便の予定（card-crolling .github/workflows の cron と同じ。変えたらここも変える） ── */
 export const COLLECTOR_SCHEDULES = {
-  "every3h.yml": { label: "3時間ごとの便", slots: [[15, 0], [18, 0], [0, 0], [3, 0], [6, 0], [9, 0], [12, 0]] },  // UTC
+  // 2026-11-25 本人「取得を1日2回（6時・18時）にする」: every3h.yml は 18:00 JST の1回だけ（朝 6時は daily.yml）
+  "every3h.yml": { label: "夕方の便（18時）", slots: [[9, 0]] },  // UTC
   "daily.yml": { label: "毎日の便", slots: [[21, 0], [23, 30]] },
 };
 
@@ -141,7 +144,7 @@ export const TITLES = {
   "fail2:update-data.yml": "データの更新の便 update-data が2回続けて失敗",
   "kv:site": "KV（サイト用）に読み書きできない",
   "kv:tracking": "KV（計測用）に読み書きできない",
-  "late:every3h.yml": "収集の3時間ごとの便が始まっていない",
+  "late:every3h.yml": "収集の夕方の便（18時）が始まっていない",
   "late:daily.yml": "収集の毎日の便が始まっていない",
   github_api: "GitHub の実行の履歴が読めない（便の見張りができない）",
 };
diff --git a/web/app/lib/stop-alert.test.mjs b/web/app/lib/stop-alert.test.mjs
index ab8e16490..0dc2434a6 100644
--- a/web/app/lib/stop-alert.test.mjs
+++ b/web/app/lib/stop-alert.test.mjs
@@ -10,16 +10,18 @@ import {
 
 const jst = (s) => Date.parse(`${s}+09:00`);
 
-test("一覧の古さ: 昼は3時間・夜は8時間（本人 2026-11-22 の選択）", () => {
+test("一覧の古さ: 昼は5時間・夜は8時間（本人 2026-11-22 の選択。2026-11-25 取得が1日2回になり昼を5時間に）", () => {
   // 昼 15:00、最後の更新 12:30 → 2.5時間 → まだ
   assert.equal(checkFreshness("2026-11-22T12:30:00+09:00", jst("2026-11-22T15:00:00")).bad, false);
-  // 昼 15:00、最後の更新 11:59 → 3時間超 → 鳴る
-  assert.equal(checkFreshness("2026-11-22T11:59:00+09:00", jst("2026-11-22T15:00:00")).bad, true);
+  // 昼 13:00、最後の更新 9:12（nyuka-watch）→ 3.8時間 → 1日2回の便ではふだんの空きなので鳴らさない
+  assert.equal(checkFreshness("2026-11-22T09:12:00+09:00", jst("2026-11-22T13:00:00")).bad, false);
+  // 昼 15:00、最後の更新 9:59 → 5時間超 → 鳴る
+  assert.equal(checkFreshness("2026-11-22T09:59:00+09:00", jst("2026-11-22T15:00:00")).bad, true);
   // 夜 05:00、最後の更新 前の日 22:14 → 6.8時間 → 夜の基準 8時間なので鳴らない（過去7日の毎晩の空き）
   assert.equal(checkFreshness("2026-11-21T22:14:00+09:00", jst("2026-11-22T05:00:00")).bad, false);
   // 夜 07:00、最後の更新 前の日 22:30 → 8.5時間 → 鳴る
   assert.equal(checkFreshness("2026-11-21T22:30:00+09:00", jst("2026-11-22T07:00:00")).bad, true);
-  // 朝 09:00 になっても朝の更新（ふだん 6時台）が無い → 昼の基準 3時間で鳴る
+  // 朝 09:00 になっても朝の更新（ふだん 6時台）が無い → 昼の基準 5時間で鳴る
   assert.equal(checkFreshness("2026-11-22T00:31:00+09:00", jst("2026-11-22T09:00:00")).bad, true);
   // 11/21 21:33 から止まった件（KV の無料枠）は、昼のうちの 11/22 00:33 までに鳴っていた
   assert.equal(checkFreshness("2026-11-21T21:33:00+09:00", jst("2026-11-22T00:40:00")).bad, false);  // 夜に入ると 8時間の基準
@@ -39,14 +41,17 @@ test("データの更新の便: 終わった直近2回がどちらも失敗な
   assert.equal(checkTwoFailures("update-data.yml", [r("failure", "a"), r("failure", "b")]).key, "fail2:update-data.yml");
 });
 
-test("収集の便: 予定の時刻から1時間たっても始まっていなければ鳴る", () => {
-  const now = jst("2026-11-22T16:05:00");  // 15:00 JST（06:00 UTC）の予定から 65分
-  assert.equal(new Date(lastDueSlot(COLLECTOR_SCHEDULES["every3h.yml"].slots, now)).toISOString(), "2026-11-22T06:00:00.000Z");
-  assert.equal(checkStarted("every3h.yml", [{ created_at: "2026-11-22T03:10:15Z" }], now).bad, true);
-  assert.equal(checkStarted("every3h.yml", [{ created_at: "2026-11-22T06:24:00Z" }], now).bad, false);  // 24分遅れで始まった
-  // 予定から 59分なら、まだ前の予定（12:00 JST）を見る
-  const early = jst("2026-11-22T15:59:00");
-  assert.equal(new Date(lastDueSlot(COLLECTOR_SCHEDULES["every3h.yml"].slots, early)).toISOString(), "2026-11-22T03:00:00.000Z");
+test("収集の便: 予定の時刻から1時間たっても始まっていなければ鳴る（2026-11-25 夕方の便は 18時の1回）", () => {
+  const now = jst("2026-11-22T19:05:00");  // 18:00 JST（09:00 UTC）の予定から 65分
+  assert.equal(new Date(lastDueSlot(COLLECTOR_SCHEDULES["every3h.yml"].slots, now)).toISOString(), "2026-11-22T09:00:00.000Z");
+  assert.equal(checkStarted("every3h.yml", [{ created_at: "2026-11-21T09:10:15Z" }], now).bad, true);
+  assert.equal(checkStarted("every3h.yml", [{ created_at: "2026-11-22T09:24:00Z" }], now).bad, false);  // 24分遅れで始まった
+  // 取りやめた時刻（21時・0時・3時・9時・12時・15時）では鳴らない: 22:05 にも前の日の 18時の回を見るだけ
+  assert.equal(checkStarted("every3h.yml", [{ created_at: "2026-11-22T09:01:00Z" }], jst("2026-11-22T22:05:00")).bad, false);
+  assert.equal(checkStarted("every3h.yml", [{ created_at: "2026-11-22T09:01:00Z" }], jst("2026-11-23T16:05:00")).bad, false);
+  // 予定から 59分なら、まだ前の日の予定を見る
+  const early = jst("2026-11-22T18:59:00");
+  assert.equal(new Date(lastDueSlot(COLLECTOR_SCHEDULES["every3h.yml"].slots, early)).toISOString(), "2026-11-21T09:00:00.000Z");
   // 毎日の便: 08:30 JST（23:30 UTC）の予定、09:31 に始まっていない
   assert.equal(checkStarted("daily.yml", [{ created_at: "2026-11-21T21:01:00Z" }], jst("2026-11-22T09:31:00")).bad, true);
   assert.equal(checkStarted("daily.yml", [{ created_at: "2026-11-21T23:31:00Z" }], jst("2026-11-22T09:31:00")).bad, false);
@@ -94,6 +99,6 @@ test("送れなかった知らせは次の回にもう一度送る。送れて
 test("知らせの文: 試しには試しと書く", () => {
   const t = message({ kind: "start", key: "late:every3h.yml", detail: "d" }, 0, true);
   assert.match(t, /^【試し/);
-  assert.match(t, /収集の3時間ごとの便が始まっていない/);
+  assert.match(t, /収集の夕方の便（18時）が始まっていない/);
   assert.match(message({ kind: "recover", key: "api:openai", detail: "d", since: 0 }, 7200000), /戻った（外の API（openai）が使えない）.*\n.*\n止まっていた時間: 2\.0時間/);
 });
```

### ニュースのボット（D:\tenbaiCroll。git の外）
```diff
--- /dev/fd/63	2026-11-25 03:51:52.000000000 +0900
+++ /dev/fd/62	2026-11-25 03:51:52.000000000 +0900
@@ -212,15 +212,14 @@
 
 ai:
   # 判定に使う Claude のモデル名
-  model: claude-opus-5-5
+  model: claude-haiku-5-5
   # 考える深さ(low / medium / high)。判定だけなので low で十分です
   effort: low
   # モデルごとの考える量(model の1行だけで替えて戻せるように。Haiku 5.5 は試しと同じ medium。2026-11-24)
   effort_by_model:
     claude-haiku-5-5: medium
   # 影のモデル: 同じ記事をこのモデルでも判定して shadow_judgments に残すだけ(通知しない)。1日 約 $0.03。
-  # 2026-11-24 本人「替える前に、1日だけ両方を動かして、Discord に出す・出さないを全部突き合わせる」。突き合わせが済んだら消す
-  shadow_model: claude-haiku-5-5
+  # 2026-11-24 本人「替える前に、1日だけ両方を動かして、Discord に出す・出さないを全部突き合わせる」。2026-11-25 本人「いますぐ Haiku 5.5 に替える。影は止める」で影の行を消した。戻すときは model の行を claude-opus-5-5 に
   # 1回の実行で AI 判定する最大件数(超えた分は次回に回す。料金の上限の目安)
   max_items_per_run: 50
   # AI が安全上の理由で回答を拒否したとき、別のモデルで自動的に再判定する
--- /dev/fd/63	2026-11-25 03:51:56.000000000 +0900
+++ /dev/fd/62	2026-11-25 03:51:56.000000000 +0900
@@ -96,6 +96,22 @@
 """
 
 
+#: Claude Haiku 5.5 にだけ足す点の付け方（本人 2026-11-24。試しで Opus と食い違った 11件が全部そろい、合っていた 200件は崩れなかった2行）
+HAIKU55_RULES = """
+
+## 追記(点の付け方)
+* 店ひとつの、いつもの抽選販売の告知(応募方法・締切の案内、フォロー&リポスト)は score 2 にする。チェーン全体・全国の販売方法の変更は 3 以上
+* 詐欺・偽物・トラブルの注意喚起は、本文が途中まででも relevant=true として扱い、分かる範囲で要約する
+"""
+#: サーバー側の切り替え(fallbacks)を受け付けないモデル(付けると 400)
+NO_SERVER_FALLBACK = ("claude-haiku-5-5",)
+
+
+def system_prompt(model: str) -> str:
+    """モデルごとの指示文。Opus は今までと同じ(キャッシュも同じ)。"""
+    return SYSTEM_PROMPT + (HAIKU55_RULES if model.startswith("claude-haiku-5-5") else "")
+
+
 def _user_message(item: Item) -> str:
     today = datetime.now(JST).strftime("%Y-%m-%d")
     lines = [
@@ -116,8 +132,9 @@
     def __init__(self, api_key: str, ai_cfg: dict):
         self.client = anthropic.Anthropic(api_key=api_key or None, max_retries=3, timeout=120)
         self.model = ai_cfg.get("model", "claude-opus-5-5")
-        self.effort = ai_cfg.get("effort")  # 未指定ならモデルの既定値(effort 非対応のモデル用)
-        self.use_fallback = bool(ai_cfg.get("refusal_fallback", True))
+        # 未指定ならモデルの既定値(effort 非対応のモデル用)。effort_by_model があればモデルごとの値(model の1行だけで替えて戻せるように)
+        self.effort = (ai_cfg.get("effort_by_model") or {}).get(self.model, ai_cfg.get("effort"))
+        self.use_fallback = bool(ai_cfg.get("refusal_fallback", True)) and self.model not in NO_SERVER_FALLBACK
 
     def _request(self, user_text: str, max_tokens: int) -> dict:
         kwargs: dict = dict(
@@ -125,7 +142,7 @@
             max_tokens=max_tokens,
             # 指示文は毎回同じなので、1時間のキャッシュに乗せる(2026-11-22 本人了承。中身・モデル・effort・出力の上限は同じ。
             # 判定を使う回の間隔は中央 約59分で、5分のキャッシュでは毎回書き直しになるため 1時間を選んだ)
-            system=[{"type": "text", "text": SYSTEM_PROMPT, "cache_control": {"type": "ephemeral", "ttl": "1h"}}],
+            system=[{"type": "text", "text": system_prompt(self.model), "cache_control": {"type": "ephemeral", "ttl": "1h"}}],
             messages=[{"role": "user", "content": user_text}],
             output_config={"format": {"type": "json_schema", "schema": SCHEMA}},
         )
--- /dev/fd/63	2026-11-25 03:51:56.000000000 +0900
+++ /dev/fd/62	2026-11-25 03:51:56.000000000 +0900
@@ -217,6 +217,10 @@
                 to_judge = []
             else:
                 judge = Judge(cfg["secrets"]["anthropic_api_key"], cfg["ai"])
+                # 影のモデル: 同じ記事を別のモデルでも判定して記録するだけ(通知には使わない。本人 2026-11-24)
+                shadow_model = str(cfg["ai"].get("shadow_model") or "").strip()
+                shadow = (Judge(cfg["secrets"]["anthropic_api_key"], {**cfg["ai"], "model": shadow_model})
+                          if shadow_model and shadow_model != judge.model else None)
             for it in to_judge:
                 try:
                     j = judge.judge(it)
@@ -229,6 +233,18 @@
                 if j is None:
                     j = Judgment(False, "その他", 1, "(AIが判定を拒否したため除外)", "-", "-")
                 store.save_judgment(it.key, j)
+                if shadow is not None:
+                    sj, err = None, None
+                    try:
+                        sj = shadow.judge(it)
+                        if sj is None:
+                            sj = Judgment(False, "その他", 1, "(AIが判定を拒否したため除外)", "-", "-")
+                    except Exception as e:  # 影の失敗は本番の判定・通知に響かせない
+                        err = f"{type(e).__name__}: {e}"[:300]
+                        log.warning("影のモデルの判定に失敗: %s (%s)", it.title, err)
+                    store.save_shadow(it.key, it.title, shadow.model, judge.model, j, sj, should_notify(j),
+                                      None if sj is None else should_notify(sj), err)
+                    report.stats["影の判定"] += 1
                 report.stats["AI判定"] += 1
                 report.judged.append((it, j))
                 if should_notify(j):
--- /dev/fd/63	2026-11-25 03:51:56.000000000 +0900
+++ /dev/fd/62	2026-11-25 03:51:56.000000000 +0900
@@ -31,6 +31,20 @@
     notified_at TEXT
 );
 CREATE INDEX IF NOT EXISTS idx_items_first_seen ON items(first_seen);
+-- 影のモデルの判定(本人 2026-11-24「1日だけ両方を動かして、Discord に出す・出さないを全部突き合わせる」)。通知には使わない
+CREATE TABLE IF NOT EXISTS shadow_judgments (
+    key TEXT NOT NULL,
+    model TEXT NOT NULL,
+    judged_at TEXT NOT NULL,
+    title TEXT,
+    main_model TEXT,
+    main_judgment TEXT,
+    shadow_judgment TEXT,
+    main_notify INTEGER,
+    shadow_notify INTEGER,
+    error TEXT,
+    PRIMARY KEY (key, model)
+);
 CREATE TABLE IF NOT EXISTS source_state (
     name TEXT PRIMARY KEY,
     value TEXT NOT NULL
@@ -94,6 +108,17 @@
         )
         self.conn.commit()
 
+    def save_shadow(self, key: str, title: str, model: str, main_model: str, main: Judgment, shadow: Judgment | None,
+                    main_notify: bool, shadow_notify: bool | None, error: str | None) -> None:
+        self.conn.execute(
+            """INSERT OR REPLACE INTO shadow_judgments(key, model, judged_at, title, main_model, main_judgment, shadow_judgment,
+               main_notify, shadow_notify, error) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
+            (key, model, datetime.now(UTC).isoformat(), title, main_model, json.dumps(main.__dict__, ensure_ascii=False),
+             json.dumps(shadow.__dict__, ensure_ascii=False) if shadow else None, int(main_notify),
+             None if shadow_notify is None else int(shadow_notify), error),
+        )
+        self.conn.commit()
+
     def load_judgment(self, row: sqlite3.Row) -> Judgment | None:
         if not row or not row["judgment"]:
             return None
```
