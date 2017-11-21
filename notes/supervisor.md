# OTP: スーパーバイザ
- Elixirの思想 : クラッシュさせてしまえ
    - → エラーが発生したらアプリケーションをダウンさせてしまう
    - → アプリケーションを多数のプロセスで構成
        - エラーが起きたらプロセスが死ぬ
        - 他のプロセスに影響はない
        - 死んだプロセスだけ再起動させる

- スーパーバイザ : プロセスの監視・再起動を行う

## スーパーバイザ
- 1つ以上のワーカープロセスを管理する
- OTPスーパーバイザを使ったプロセス


### スーパーバイザの作成
```sh
$ mix new --sup app_name
```
~~`app_name/lib/app_name.ex`に設定が追加される~~
`app_name/lib/app_name/application.ex`になってた

### 監視対象の指定
- `application.ex`で設定

```elixir
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # worker(Stack.Worker, [arg1, arg2, arg3])
      worker(Stack.Server, [[1,2,3]])
    ]

    opts = [strategy: :one_for_one, name: Stack.Supervisor]
    Supervisor.start_link(children, opts)
  end
```

- start関数のchildrenに監視対象を指定
- worker関数を使う
    - `start_link()`の引数も指定
- スーパーバイザプロセスが各サーバの`start_link`を呼び出す
    - 名前指定するところがないからサーバ起動関数名`start_link`は固定？

### プロセスの死亡・再起動
- サーバプロセスがエラーで死ぬ
    - → 自動的にスーパーバイザがプロセスを再起動
- *注意* : プロセスは死亡前の状態を保持せず、状態が初期値に戻る

#### 再起動時の状態の保持
- ステートレスなサーバーでは、再起動時に状態が保持されないのは困る
    - → サーバープロセスの外部に状態を保持するワーカープロセス(スタッシュ)を作る
        - スタッシュが一般的な名前であるのかは不明
- スタッシュの要件 : サーバープロセスより長生きであること
    - 単純につくる
    - サーバープロセスとは別に監視する

#### 監視ツリー
```
トップレベルのスーパーバイザ
|- スタッシュワーカー
|- サブスーパーバイザ
    |- サーバーワーカー
```

実装はコードで

- `use Supervisor`
- スーパバイザの起動も`start_link`関数を上書き
- `strategy:`あたりは未だ不明
- スタッシュのPIDをリレーで渡していくあたりがいまいち？
