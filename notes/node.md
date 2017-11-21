# ノード

- Beam : Erlang VMの一種、今主流のやつ
    - 単なるインタプリタではなく、スケジューリング他色々やってくれる
    - 他のノードと接続できる
        - 同マシン上, LAN, WAN上問わず接続可能

## ノードの名前

```elixir
iex(1)> Node.self
:nonode@nohost
```

- 自分で名前つけるとき
```sh
$ iex --name test@hoge
$ iex --sname test # @以下は自動的にマシン名が振られる
```

## 他ノードへの接続

```elixir
Node.connect :"node_name@machine_name"
```
- `:"..."`なのは多分@がアトムリテラルに使えないから
- マシン名が正しくないと接続できない(?)
    - "hoge@fuga" とかには接続できなかった
    - "hoge2@fuga" から(同マシン名)からも不可
- LAN/WAN上の別マシンに接続するには別途ポートの設定とかいるっぽい

## 接続確認

```elixir
Node.list
```
- 接続したノードが一覧
- 接続された側も既にリストにある→双方向
- 接続済みのノードグループに接続すると全部繋がる
    - `test1@machine` <-> `test2@machine` が接続済み
    - `test1@machine`と`test3@machine`を繋ぐ
    ```elixir
    iex(test1@machine) > Node.conenct :"test3@machine"
    ```
    - 全部繋がる
    ```elixir
    iex(test1@machine)3> Node.list
    [:test2@machine, :test3@machine]
    
    iex(test2@machine)2> Node.list
    [:test1@machine, :test3@machine]
    ```

## 他ノードでのプロセスの実行
```elixir
Node.spawn(node_name, function)
```
- 指定したノードでプロセスが作られ、関数が実行される :clap:

- `#PID<xxxx.xx.x>`
    - ノード番号.プロセス番号.プロセス番号(?)
        - プロセス番号下位, 上位ビットらしい
        - ノード番号0 : 自分

## ノード間接続のセキュリティ
- クッキーを使って接続権限のチェックを行う
```sh
$ iex --sname test --cookie test_cookie
```
- *クッキーは平文で送信されるので公開ネットワークを介するときは注意*

- cookie設定しても適当なマシン名(`test@hoge <-> teset2@hoge`)では接続できなかった

## プロセスの名前

名前をつける
```elixir
:global.register_name(name, pid)
```

名前からプロセス番号を得る
```elixir
:global.whereis_name(name)
```

#### 名付けのタイミング
- プロセスの名前はグローバルに保存される
- 対処法
    - mix.exsにアプリケーションが登録する名前をリストアップ可能
    - アプリケーション開始時にプロセスの名前を登録するのが一般的
    - これ対処になってるのか...?

## I/O
- Erlang VMにおける入出力はI/Oサーバを介して行う
- I/Oサーバの実態はプロセスなのでPIDを持つ
- 他ノードのI/Oサーバにももちろん接続可能
