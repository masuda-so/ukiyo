# Ukiyo

[日本語](README.md) | [English](README.en.md)

## 概要

Ukiyoは、選んだ画像とキャプションを端末内に保存するビジュアル日記です。対応する端末では、端末上で動作する文章作成支援も利用できます。

## 主な機能と制約

### 主な画面

- Lens
- Assistant
- Pro
- Settings

### 主な機能

システムの写真ピッカーからは、選択された項目だけを取得します。画像の向きを補正し、長辺を最大1,600ピクセルに縮小・圧縮したうえで、SwiftDataの外部ストレージに保存します。保存した画像は確認・削除できます。写真日記の無料機能はProなしでも利用できます。

### アシスタントと購入

アシスタントには有効なProの利用権が必要です。対応する端末と言語でApple Foundation Modelsを使用します。Proでは、対応する端末で利用者が明示的に起動するApple Image Playgroundも提供します。選んだ写真は新しい浮世絵・木版画風の画像を作るための参考としてシステムに渡し、その写真自体を変換するものではありません。結果にはAI生成であることを表示し、明示的に保存した場合にだけ元の写真と生成結果を別々に保存します。

ローカルのStoreKit設定には、次の商品を定義しています。

- `llc.ether.ukiyo.pro.daily`：自動更新しない24時間のDaily Pass。
- `llc.ether.ukiyo.pro.monthly`：自動更新の月額プラン。
- `llc.ether.ukiyo.pro.yearly`：自動更新の年額プラン。

起動時の購入権利の照合が終わるまで、Proの商品一覧には確認中の表示を出します。Daily Passが有効な間は同じパスを購入候補から外し、期限後に再表示します。購入の復元は、アシスタントが利用できない場合もPro画面と設定画面から実行できます。

App Store Connectの商品登録、本番価格、審査用情報の準備は、別途必要なリリース作業です。

## 導入と使い方

Xcodeで`ukiyo.xcodeproj`を開き、共有スキーム`ukiyo`を選択します。
ビルドとテストの手順は[構成と検証](Docs/Structure.md)、端末要件とリリース条件は[リリース条件](Docs/Release.md)を参照してください。
ローカルStoreKit設定は購入テスト用で、本番販売が可能であることの証明ではありません。

## サポートと関連資料

- [リポジトリ構成と検証](Docs/Structure.md)
- [製品の範囲](Docs/Product.md)
- [プライバシーポリシー](Docs/Privacy.md)
- [利用規約](Docs/Terms.md)
- [実装の参照元](Docs/References.md)
- [リリース条件](Docs/Release.md)
- [App Store提出記録](Docs/App-Store-Submission.md)
- [第三者の権利表記](THIRD_PARTY_NOTICES.md)

公開サイトのパス：

- `https://ether-llc.com/apps/ukiyo/privacy/`
- `https://ether-llc.com/apps/ukiyo/terms/`
- `https://ether-llc.com/apps/ukiyo/support/`

署名、検証、アップロード、公開、リリースには、リポジトリ外での作業も必要です。

## 開発と貢献

製品の問い合わせ先は上記のサポートURLです。リポジトリを変更する場合は、上記の実装の参照元とリリース条件を確認し、変更内容と検証結果をPRに記載してください。PRの説明とレビューコメントは日本語を基本とします。利用者が別の言語を指定した場合は、その指定を優先します。

作業時の共通方針は[AGENTS.md](AGENTS.md)を参照してください。
