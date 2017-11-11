# 複数のプロセスを使う

## Elixirのプロセス

ElixirのプロセスはErlang VMのアーキテクチャのおかげで、
大量に作ってもパフォーマンスが落ちない
- OSのプロセスとは異なるので注意
- Erlang VM上でElixirのプロセスが複数動いている感じだろうか(後で調べる)

## アクターモデル
- Elixirが採用しているモデル
- 他のプロセスと何も共有しない
- 他のプロセスとメッセージを送受信
- 詳しく載ってないので後で別資料で学ぶ


## プロセスの起動

```elixir
spawn(module, :function, [args])
```
- 返り値 : PID
- プロセスの生成のみで、いつ実行されるか分からない

## メッセージの送受信

### メッセージの送信
```elixir
send target_pid, message
```
- `target_pid` : 送信先プロセスのPID
- `message` : 送信するメッセージ

### メッセージの受信
```elixir
receive do
    {:ok, message} -> IO.puts message
end
```
- receive で受け取ったメッセージに対してパターンマッチングし処理内容を分岐
- caseみたいな感じ？
- マッチするものがなかったらスルー
- ガード節も使える

### タイムアウト
```elixir
receive do
        # 通常の処理 (パターンマッチング)
        {:ok, message} -> ...
        ...
    after 500 ->
        # タイムアウト後の処理
        IO.puts "Time out"
end
```
- `after [number]` でnumberミリ秒後タイムアウト

### 複数メッセージを受け取る
- メッセージを受け取るとreceive節を抜ける
    - →　メッセージをずっと受け取りたい場合は？
        - 再帰を使う

```elixir
def greet do
  receive do
    {:ok, message} ->
      IO.puts "Message Received : #{message}"
      greet
  end
end
```
こんな感じ

#### Q. 再帰でループしてメモリ使い切らない？
- Elixirの*末尾呼び出しの最適化*によっていい感じになる
    - 末尾再帰だったら再帰の代わりに関数の先頭へジャンプ
- 自動で末尾再帰に変換してくれるわけではなさそうなので注意

### プロセス数の上限解放

```sh
$ elixir --erl "+P 1000000" -r chain.ex -e "Chain.run(1_000_000)"
```

## プロセスの死活

### リンク

```elixir
spawn_link (module, :function, [args])
```

- 片方が死ぬと片方もつられて死ぬ
- 子が死ぬ　→　親が死ぬ、逆も

```elixir
Process.flag(:trap_exit, true)
spawn_link (module, :function, [args])
```

`:trap_flag`を立てると釣られて死なずに、死亡メッセージ(`:EXIT`)を受け取れる

## モニタ(監視)

- 片方が死んでも一緒に死なない
- 親が子の終了通知を受け取れる
- 一方通行さん

```elixir
spawn_monitor(module, :function, [args])
```
- 返り値 : `{pid, reference}`
- `reference` : 生成されたモニタの識別値
- 子が終了したら(正常/異常問わず) `:DOWN`メッセージを受け取る


- `Process.monitor`で既に作られているプロセスをモニタできる
- でもモニタリング開始前に死ぬこともあるから`spawn_monitor`で

#### WorkingWithMultiProcesses-3,4,5

1. spawn_link
    - 子プロセス正常終了
        - 親受信開始
        - 親がメッセージを受け取る
        - 親死なない
    - 子プロセス異常終了
        - 親死亡(受信開始前に)
    - 子プロセス例外
        - 親例外を受け取りそのまま例外スロー(受信開始前に)
2. spawn_monitor
    - 子プロセス正常終了
        - 親受信開始
        - 親がメッセージ受信
        - 親が子の:DOWNメッセージ受信
    - 子プロセス例外
        - 親受信開始
        - 親がメッセージ受信
        - 親が子の:DOWNメッセージ受信(異常終了の旨)
    - 子プロセス例外
        - 親受信開始
        - 親がメッセージ受信
        - 親が子の:DOWNメッセージ受信    
        ```elixir
        {:DOWN, #Reference<0.0.3.0>, :process, #PID<0.76.0>,
        {%RuntimeError{message: "Child raise exception."},
        [{Spawn, :child, 2, [file: 'multi_process/exercises.exs', line: 9]}]}}
        ```
        - DOWNメッセージに例外が入っている
        - *親は例外投げない*


