# Xの下書き: コピーで改行が消えないようにし、本文の URL をリンクにする

## 指示

本人 2026-09-26:

> 管理画面のXの下書きについてなんだけど、下書きをコピペしてXに貼り付けようとすると改行が消えてしまう。
> あとURLが、Xの下書きで出しているURLがハイパーリンクじゃなくてクリックで飛ばないから、URLが合ってるか確認しづらい。
> そこちょっと直せる？

## PR

https://github.com/shinonomeheta-ai/cardbot/pull/1675 （ブランチ `x-draft-copy-links`・b0956554c・origin/main 167b85847 から）

## 原因（推測を含む）

* 「投稿を作る」画面のプレビュー（`XPreviewCard` の `.xprev-body`）は、改行を CSS（`white-space: pre-wrap`）で見せているだけ
* ここを選んでコピーすると、ブラウザは HTML も一緒にクリップボードへ渡す。その HTML には改行が無い
* X の入力欄は HTML の形を優先して読むので、貼ると改行が消える（推測。X への貼り付けそのものは試していない）
* 入力欄（textarea）からのコピーなら改行は残る
* プレビューの本文は文字をそのまま出していて、URL がリンクになっていなかった

## 直したこと

| ファイル | 変更 |
| --- | --- |
| `web/app/admin/x-post-preview.js` | プレビューの本文の URL をリンクに（`LinkedText`）。選んでコピーしたときは改行つきの文字（text/plain）だけを渡す（`onCopy`）。実際の本文のプレビューに「📋 本文をコピー」（`CopyTextButton`）。本文のリンクの一覧（`DraftLinks`） |
| `web/app/admin/x-queue-panel.js` | 「Xの下書き」の画面（入力欄だけ）に、入力欄の下にコピーのボタンと本文のリンクの一覧（新規投稿・各下書き） |
| `web/app/lib/x-text.mjs` | 本文を文字と URL に分ける（`splitLinks`・`urlsIn`）。文末の句読点・括弧は URL に含めない。分けたものをつなぐと元の本文 |
| `web/app/globals.css` | リンクの色（X と同じ青）とボタンの並び |

本文そのもの（保存する文面・X に出る文面）は変えていない。

## 確かめたこと（手元）

* `node --test web/app/lib/x-text.test.mjs web/app/admin/nav-cleanup.test.mjs web/app/x-next.test.mjs`: 38件 OK
* `cd web && node --test app`: 落ちる 42件は、直す前（origin/main 167b85847）と名前で突き合わせて同じ（差 0）
* 直した 2つの部品は esbuild で JSX として読み込める

## 未確認

* `npx next build` は手元で流していない（web build check に任せる）
* 実際の X への貼り付けは試していない
* マージの条件のうち、レビュー担当の承認はまだ無い（本人の操作を待つ）
