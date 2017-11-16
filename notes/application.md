# OTP : アプリケーション

- OTPの世界のアプリケーション
    - ディスクリプタでひとまとめにされたコード
        - ディスクリプタ : コードの依存関係, global名前空間をランタイムに伝える
    - 動的リンクライブラリ(dll)や共有オブジェクト(so)に似ている
    - コンポーネントやサービス

## アプリケーション仕様ファイル
- コンパイルすると`appname.app`ファイルが作成される
    - `./_build/`以下を探すとあった
- アプリケーションの実行に必要な情報がここに保存されるらしい

## OTPアプリケーションの作成

### アプリケーションのトップレベルモジュールの設定
- `mix.exs`で指定する
```elixir
def application do
  # ここで指定
end
```

#### `mod:` オプション
```elixir
def application do
  [
    extra_applications: [:logger],
    mod: {Stack.Application, []}
  ]
end
```
- アプリケーションのメインエントリポイントのモジュールを指定
- OTPはこのモジュールが`start`関数を実装していると想定する
- start関数の引数も指定(この例だと空のリスト)
- start関数の実体は`lib/app_name/application.ex`にある
- ライブラリの場合はstart関数で初期化をしたりする

#### `registerd:` オプション
- アプリケーションが登録する予定の名前を列挙
```elixir
def application do
  [
    extra_applications: [:logger],
    mod: {Stack.Application, []},
    registered: [Stack.Server]
  ]
end
```

#### `env:` オプション
```elixir
def application do
  [
    ...
    env: {initial_value: [initial, value]},
    ...
  ]
end
```
- `Application.get_env()`でどこのコードからでも参照できる
- 初期値はこれで指定するといいよね

## リリース
Erlangには堅牢なリリース管理システムもある:clap:

##### 用語
- リリース(release) : アプリケーション実行に必要なもの(依存関係や設定)を束ねたもの
- デプロイ(deployment) : あるリリースを動作可能な環境に配置する方法
- ホットアップグレード(hot upgrade) : アプリケーションを停止することなく更新すること

### EXRM
- EXRM : Elixirのリリースマネージャ
    - Erlangのrelxパッケージの上に実装
