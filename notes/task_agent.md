# タスクとエージェント
- 抽象化の度合い

    高レイヤ - GenServer > タスク/エージェント > spawn, send, receive - 低レイヤ
- OTPサーバとして実装されているので分散可能

## タスク
```elixir
worker = Task.async(fn -> SomeFunction() end)
result = Task.await(worker)
```
- `Task.async` : 与えられた関数を実行するプロセスを生成
- `Task.await` : タスクの終了待ち

### タスクの監視
- タスクはOTPサーバとして実装されている
    - 監視ツリーに組み込める

1. `start_link()`を使う
    - `Task.async`の代わりに`Task.start_link`を使うことでプロセスがリンクされる
    - →　タスクが死んだら親プロセスも死ぬ
    - (`Task.async`の場合は`Task.await`の待ちで親が死ぬ)
2. スーパーバイザから監視
    ```elixir
    import Supervisor.Spec

    children = [
        worker(Task, [fn -> do_something() end])
    ]
    supervise children, strategy: :one_for_one
    ```
    - 普通の他のワーカーと同様に指定可能

## エージェント
- 状態を持つバックグラウンドプロセス
- 状態にはマップやキーワードリストも取れる
    - → 本の例ではオブジェクトっぽく使ってるように見える

#### 扱い方
- 起動
    ```elixir
    {:ok, pid} = Agent.start(fn -> 1 end, name:Sum)
    ```
    - 関数を初期状態として渡す
    - 命名も可能
- 状態の取得
    ```elixir
    Agent.get(Sum, &(&1))
    ```
    - 渡した関数を、関数の状態に対して適用した結果を返す
    - →　`&(&1)`だったら状態がそのまま返るね
    - PIDか名前で指定
- 状態の更新
    ```elixir
    Agent.update(Sum, $($1 + 1))
    ```
    - 与えた関数でエージェントの状態を更新
