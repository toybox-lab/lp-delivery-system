# LP事業部 — 設計・進捗・ナレッジ

## 事業概要
レオン（Claude Code）が直接LP制作を担当する一気通貫システム。
ヒアリングから納品まで、美月さんの確認ステップを1回だけ挟んで完結する。

## システム構成
| 役割 | ツール |
|------|--------|
| LP HTML生成 | レオン（Claude Code）が直接作成 |
| コード保存 | GitHub（toybox-lab/lp-delivery-system） |
| LP公開 | GitHub Pages（toybox-lab.github.io/lp-delivery-system） |
| メール送信 | Gmail MCP（ym.toybox@gmail.com） |
| 案件記録 | Googleスプレッドシート「LP制作案件管理」 |
| ヒアリング | Googleフォーム（ID: 18nmXDrW_WLU3CW6Zq9a3U1am-fKAwZ0pgfWZxiddcwU） |

※ n8nは現在停止中（APIクレジット切れ）。レオン直接作成フローを運用中。

## 現在のフロー
1. ここならっでお客様から依頼が入る
2. 美月さんがここならのメッセージでヒアリングフォームURLを送る
3. お客様がGoogleフォームに回答
4. 美月さんがレオンに「ヒアリング届いたよ、LP作って」と声かける
5. レオンがGoogleフォームの回答を確認してLPを作成
6. GitHubに保存 → GitHub PagesでURL発行
7. レオンが美月さんにGmailで完成報告（URL付き）
8. 美月さんがここならのメッセージにURLを貼って納品

## 修正フロー（設計中）
- LP納品と同時に修正ヒアリングフォームを送付
- フォームURL: https://toybox-lab.github.io/lp-delivery-system/correction-form.html
- 最大3回無償修正・4回目は追加決済
- 修正データは `correction-patterns.md` に蓄積

## 今後の拡張計画
- リサーチエージェント（競合・業界トレンド調査）
- 画像生成エージェント
- LPアドバイザーとの日程調整（Googleカレンダー連携）
- ヒアリングシート2種類（お客様向け簡易版・アドバイザー向け詳細版）

## 設計思想
- テンプレートなし・AIがHTMLを直接生成（自由度重視）
- 修正データを蓄積して品質を継続的に向上
- 全エージェントが作業前にこのフォルダを参照する
