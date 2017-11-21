# プロジェクト構成 - mix

- Mix - Elixirのプロジェクト管理ツール

### プロジェクト作成
`mix new projectname`

### 実行

#### 式の実行
```sh
$ mix run -e ' ... '
```
- アプリケーションのコンテキストで評価される(すごい 👏 )
- 変更があれば式の実行前にアプリを再コンパイルする

#### iex
```sh
$ iex -S mix
```

### 規約

- モジュール名とディレクトリ構造を対応させる (規約)
    - 例 : Issuesモジュールの入れ子のCLIモジュール

    - cli.ex
    ```elixir
    defmodule Issues.CLI do
        ...
    end
    ```

    - ディレクトリ構成
    ```
    lib
    | ---- issues
    |       |------cli.ex
    ---------------issues.ex
    ```

## コマンドラインインタフェース

- モジュール名 : `Project.CLI` (規約)
- エントリポイント : `run` (規約)

## テスト ExUnit
- elixirのテストフレームワーク : ExUnit
- `$ mix test` でテスト実行
- 特筆することなし

## ライブラリ
### 組み込みのライブラリ
- Elixirのライブラリ
- Erlangのライブラリ : [ここ](http://erlang.org/doc/applications.html)
### 外部ライブラリ
- パッケージマネージャ : hex
- http://hex.pm

#### 外部ライブラリの追加
- `mix.exs`のdeps関数に依存関係を追加
```elixir
  defp deps do
    [
      {:httpoison, "~> 0.8"}
    ]
  end
```
- `$ mix deps` - 依存関係のチェック
- `$ mix deps.get` - 依存関係のDL
- → `/deps/` 以下に依存ライブラリのプロジェクトが追加される(ソースも見られる)

#### 外部ライブラリを別アプリケーションとして実行

- (まだ完全には理解していない)　→ II部でやるらしい
- elixirでは外部ライブラリをメインプロセス外の別アプリケーションとして起動できる
- mix.exs
```elixir
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :httpoison]]
  end
```
- 書籍では`:extra_application`ではなく`:application`
- [ドキュメント](https://hexdocs.pm/mix/Mix.Tasks.Compile.App.html)を見ると

  > :applications - all applications your application depends on at runtime. By default, this list is automatically inferred from your dependencies. Any extra Erlang/Elixir dependency must be specified in :extra_applications. Mix and other tools use the application list in order to start your dependencies before starting the application itself.

  > :extra_applications - a list of Erlang/Elixir applications that you want started before your application. For example, Elixir’s :logger or Erlang’s :crypto.

- よくわからん
- :extra_applicationのほうがThe most commonly used options ってかいてある

#### パッケージング

- コード+依存関係をまとめてパッケージングできる
- Erlangのescriptユーティリティをつかう
- プリコンパイルしてZip
 
 - mix.exs の escriptコンフィグ
   - `main_module:` : main関数を含むモジュール名
   - escriptの仕事
    - 指定したメイン関数にコマンドライン引数を[[文字]]としてわたす

- パッケージング実行
```sh
$ mix escript.build
```

## ロギング
- logger
  - デフォルトのmix.exsに設定済み
  - debug,info,warn,errorのレベル
  - config.exsで設定
  ```elixir
  config :logger, compile_time_purge_level: :info
  ```
  - Logger.debug "文字列 #{func()}" → debugレベルが無視されていたとしても毎回`func()`呼ばれる
  - アリティ0の関数も引数に取れる　→　必要時だけ文字列に埋め込み
  ```elixir
  Logger.debug fn -> "文字列 #{func()}" end
  ```

## ドキュメントのテスト
ドキュメントにテストコードと結果を貼っておくとテストしてくれる

- ドキュメント側
```elixir
@doc """
iex> Issues.TableFormatter.printable("a")
"a"
```
- `iex(1) > `とかなってても大丈夫だからiexからコピペでok

- テストの設定(`/test/doc_test.exs`)
```elixir
defmodule DocTest do
  use ExUnit.Case
  doctest Issues.TableFormatter
end
```

## ドキュメンテーションツール
ExDoc
