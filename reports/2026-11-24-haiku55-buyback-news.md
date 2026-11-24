# Haiku 5.5 への切り替え: 買取の読み取りとニュースのボット（レビュー用・2026-11-24）

本人の指示（2026-11-24）で、買取の値段の読み取りとニュースのボットの判定を Claude Haiku 5.5 に替える準備をした。どちらも、このレビューのあとで設定を入れるまで、今の動きは変わらない。2次判定は 11/10〜11/16 の7日分を流している途中で、結果は別の報告で出す。1次判定は今のモデルのままにする（替えても額が減らないため）。

## だめだったもの・戻らなかったもの

買取: Haiku 5.5 は、商品名が表に無く箱の絵の小さな文字にしか無い行を外す（画像15枚で 446行のうち 91行）。考える量を high にする形で 81行中 19行（うち約3行は誤り）、指示文に「箱の絵の文字も読む」と足す形で 16行が戻ったが、残りの約6割は戻らなかった。今回の切り替えには、どちらの形も入れていない。

買取: いま有効な買取表を全部読み直すと 1,119枚・見込み 約 $2.5（文字読み $1.68・Haiku 5.5 約 $0.82）になる。本人の決めた $1 を超えるので、読み直しはしていない。

2次判定の締切: 「締切の根拠の語句には月日の入った文を写す」の1行を指示文に足しても、Haiku 5.5 は時刻だけの文（「23:59まで」）を写し続けた。この形はやめ、あとの処理の側で、本文に同じ月日の締切の文があれば締切を残す形を試した（下）。

## 1. 買取（card-crolling PR #3）

https://github.com/shinonomeheta-ai/card-crolling/pull/3

これまで買取のモデルは buyback.MODEL に固定で、替える口が無かった。値段を読む所（ask_params・ask）だけが、リポジトリの変数 COLLECTOR_BUYBACK_READ_MODEL を見るようにした。空なら今までの claude-haiku-4-5 で、変数を消せば元に戻る。投稿の仕分けは今までのモデルのまま。単価表に claude-haiku-5-5（$0.10 / $0.50。Claude API の資料で確認）を足した。Haiku 5.5 は temperature を付けると 400 なので付けない。バッチの額は、依頼ごとのモデルの単価で数える。daily.yml と stores-weekly.yml は、この変数を渡す。画像の文字読み（Cloud Vision）は今までどおり使う。

試験: tests/collector 487 passed, 1 skipped（足した5件: 既定のモデル・Haiku 5.5 で temperature なし・仕分けはそのまま・単価表に無い名前は送らない・バッチの額）。

いま画面に出ている買取の値段の誤り（いま有効な買取表の画像から無作為に20枚。画像を目で見て数えた）:

| | 行 |
|---|---|
| 画面の行 | 109 |
| 正しい | 84 |
| 誤り | 25（23%） |

誤りがあった画像は 20枚中6枚で、どれも隣の商品の値段にずれる形だった（30th のプレミアムデッキセットとフューチャリスティックボックスの値段が入れ替わる、ロケット団の栄光に メガブレイブの値段が付く など）。本文に値段が書いてある投稿、商品名が印刷された買取表、1商品だけの画像は全部正しかった。

食い違いの多い順の15枚（446行）では、Haiku 5.5 は正しい 332・誤り 23・抜け 91、今のモデルは正しい 96 だった。プラモデルとシングルカードの買取表の3件は、Haiku 5.5 が0行で正しく、今のモデルは 99行ずつ誤って入れていた。

## 2. ニュースのボット（D:\tenbaiCroll。git の管理外。元のファイルは D:\tenbaiCroll-backup-20261124 に控えた）

指示文に試しの2行を足し、モデルの1行（config.yaml の ai.model）だけで Haiku 5.5 と Opus を替えられるようにした。2行は Haiku 5.5 のときだけ足すので、Opus の指示文とキャッシュは今までと同じ（18:16・18:20 の回もキャッシュの読み 2,649 トークンで変わっていない）。Haiku 5.5 はサーバー側の切り替え（fallbacks）を付けると 400 なので付けない。考える量は effort_by_model でモデルごとに持つ（Opus は今の low のまま）。

替える前に1日両方を動かすため、影のモデル（ai.shadow_model）を足した。同じ記事を影のモデルでも判定して shadow_judgments の表に残すだけで、通知には使わない。影が落ちても本番の判定と通知は止めない。設定はまだ入れていない。入れると1日 約180件 × 約 $0.00015 ＝ 約 $0.03 かかる。

試験: tests 21 passed（足した2件: Haiku 5.5 の指示文・fallbacks・effort と、影は記録するだけで通知に使わない）。

試しの数え直し: 通知の設定（exclude_categories に 販売ルール変更）を当てると、前に「Opus と食い違った11件」と数えたうち10件はもともと Discord に出ない種類だった。実際に出る・出ないが変わるのは、詐欺の注意喚起の1件（足した2行で Haiku 5.5 も出す側にそろった）。

差分:

```diff
--- 元/judge.py	2026-11-22 18:35:26.970531700 +0900
+++ tenbaiCroll/tenbai_bot/judge.py	2026-11-24 18:04:00.965993000 +0900
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
--- 元/runner.py	2026-11-22 18:35:39.190904100 +0900
+++ tenbaiCroll/tenbai_bot/runner.py	2026-11-24 18:04:00.966992100 +0900
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
--- 元/db.py	2026-10-06 00:53:57.674720900 +0900
+++ tenbaiCroll/tenbai_bot/db.py	2026-11-24 18:04:00.965993000 +0900
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

## 3. 2次判定の締切（コードはまだ変えていない）

締切を空にした4投稿のうち3投稿（furu1_amshitoro・cardushikawa の2投稿）は、試しの入力を作ったときに画像が取れていなかった（今は取れない）。締切はその画像にあったので、Haiku 5.5 の読み違いではなく、試せなかった。trsttoyohashi は、Haiku 5.5 が 11/22 23:59 と読んだのに、根拠の語句に時刻だけの文を写したため、あとの処理（check_deadline_quote）が締切を外していた。

あとの処理で、根拠の語句に月日が無くても、本文（引用元・続きを含む）に同じ月日の締切の文（「11月22日23:59まで」「応募…11/22」）があれば締切を残す形を、試しの結果に当て直した（費用なし）。締切は 14投稿中 6投稿が戻り（trsttoyohashi・cardshopgalaxy を含む）、正しかった 100投稿の抽選と締切は1件も崩れなかった。残りは、画像が取れなかった3投稿と、どちらが正しいとも言えない hobibi（「対象期間」）と cardrush（当選連絡の日）。

## 4. 画像の文字読み（読むだけ）

2次判定: 11/17〜11/23 に判定に送った画像 7,317枚のうち、文字読み（Cloud Vision）に送ったのは 3,835枚。残りの 47.6% は控え（ocr_cache。画像の中身の md5）で省けている。省けていないのは、初めて見る画像だから。

買取: 控えを使っておらず、読んだ画像は毎回文字読みに送っている。7日で 4,159枚を読み、2,573枚を買取表として残した。そのうち 620枚（24%）は、文字が前に読んだ買取表とまったく同じだった（同じ表の投稿し直し）。1,586枚（38%）は、文字を読んだあとで未開封品の語が無いとして捨てている（シングルの買取表・店の写真）。

月の上限（OCR_MONTHLY_IMAGES）はコードでは 80,000枚。メモの「30,000枚」は古い。

## 5. 12時・15時の回

12時の回: 抽選 28投稿のうち、画面の口（lottery_golden・lottery_branch）に入ったのは 9投稿。その分（10件）は全部画面に出て、取れてから画面まで 真ん中 52分・最長 72分。残りの19投稿は口に入っておらず、口で外された理由はまだ見ていない。

15時の回: 2次判定の結果を受け取ったのは次の回の 18:20。そのため、画面のデータの最後の出し直し（17:37）にはまだ無い。

今日の X の合計（0時から 18時台まで）: $8.63（fetch $8.36・x-discover $0.27）。

## 費用

この作業の実額: $0.9226（Haiku 5.5 の試し・買取の抜けの試し・文字読み5枚を含む。上限 $2）。7日分の2次判定（見込み 約 $0.53）は、18時の回が終わってから流す。
