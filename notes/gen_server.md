# OTP : サーバー

## 概要
- OTP : Open Telecom Platform
    - 電話交換機
- Erlang + DB(Mnesia) + ライブラリ

## ビヘイビア
- ビヘイビア : プロセスが従うOTPの規約
    - 具体例 : サーバ用ビヘイビア(`GenServer`), イベントハンドラ用, 有限ステートマシン(!)用 ... etc
- スーパーバイザ : プロセスの死活監視用の特別なビヘイビア

## OTPサーバ
- コールバック関数を実装するだけでいい感じにやってくれる

### Genserver
```elixir
use Genserver
```
- Genserverビヘイビアが追加される
    -  → デフォルトのコールバックが定義される
    - 必要なもののみ上書き

#### `handle_call()`

```elixir
  def handle_call(request, from, state) do
    ...
    {:reply, reply_ody, next_state}
  end
```
- `request` : クライアントが渡した最初の引数
- `from` : クライアントのPID
- `state` : サーバの状態


- `handle_call`でやること
    - OTPにタプルを返す

    ```elixir
    {:reply, reply_ody, next_state}指示
    - `next_state` : サーバーの次の状態(次の`handle_call`)
    ```
    - `:reply` : OTPに2つ目の変数(`reply_ody`)を返すよう指示
    - `next_state` : サーバーの次の状態(次の`handle_call()`の呼び出しの最後の引数)

#### サーバーの起動
```elixir
{:ok, pid} = GenServer.start_link(Module.Server, initial_state)
```
- GenServerに新しい自前のサーバのプロセスを追加・開始
- `spawn_link`のようなもの

##### オプションの指定

- `GenServer.start_link()`の第3引数でオプションを指定可能
- 例
    1. `:trace` : デバッグトレース
    ```elixir
    iex(1)> {:ok, pid} = GenServer.start_link(Stack.Server, [5, "cat", 9], [deug: [:trace]])
    {:ok, #PID<0.124.0>}
    iex(2)> GenServer.call(pid, :pop)
    *DBG* <0.124.0> got call pop from <0.122.0>
    *DBG* <0.124.0> sent 5 to <0.122.0>, new state [<<99,97,116>>,9]
    5
    iex(3)> GenServer.call(pid, :pop)
    *DBG* <0.124.0> got call pop from <0.122.0>
    *DBG* <0.124.0> sent <<"cat">> to <0.122.0>, new state [9]
    "cat"
    iex(4)> GenServer.call(pid, :pop)
    *DBG* <0.124.0> got call pop from <0.122.0>
    *DBG* <0.124.0> sent 9 to <0.122.0>, new state []
    9
    ```

    2. `:name` PIDの命名
    ```elixir
    iex> {:ok, pid} = GenServer.start_link(Stack.Server, [5, "cat", 9], name: :stack)
    iex> GenServer.call(:stack, :pop)
    5
    ```

    3. `:statistics` : 統計情報の保存

#### サーバーの呼び出し
```elixir
GenServer.call(pid, :request)
```
- `GenServer.start_link()`で得たサーバプロセスのpidにメッセージを投げる
- `:request` : サーバのアクションを指定するのに使ったりする
    - 2つ以上の引数が要る場合にはタプルを投げる
    ```elixir
    GenServer.call(server_pid, {:action, value})
    ```

#### サーバーの呼び出し(返事を待たない)

- クライアント側にreplyを送らない場合はcastを使う
- `handle_call() <-> GenServer.call()`
- `handle_cast() <-> GenServer.cast()`
    - 対応関係があるので注意

- サーバー側
```elixir
  def handle_cast(request, state) do
    ...
    {:noreply, next_state}
  end
```

- クライアント側

```elixir
GenServer.cast(pid, :request)
```

### sysモジュール
- システムメッセージのインタフェース
- 例 : `get_status()` : ステータスメッセージの表示
```elixir
iex(2)> :sys.get_status(pid)
{:status, #PID<0.131.0>, {:module, :gen_server},
 [["$initial_call": {Stack.Server, :init, 1},
   "$ancestors": [#PID<0.129.0>, #PID<0.51.0>]], :running, #PID<0.129.0>,
  [trace: true],
  [header: 'Status for generic server <0.131.0>',
   data: [{'Status', :running}, {'Parent', #PID<0.129.0>},
    {'Logged events', []}], data: [{'State', [5, "cat", 9]}]]]}
```

- サーバーに`format_status()`を定義することでステータスメッセージをフォーマット可能

### サーバモニタリングツール
```elixir
iex > :oserver.start
```
GUIのモニタリングツールが起動する :clap:

### GenServerコールバック
- `init(start_arguments)`
    - サーバの開始時に呼ばれる、初期化用
    - `start_arguments` : `handle_call()`の第2引数
- `handle_call(request, from, state)`
    - レスポンス
        - `{:reply, result, new_state [, :hiernate | timeout]}`
        - `{:noreply, new_state [, :hiernate | timeout]}`
        - `{:stop, reason, [:reply ,] new_state}`
            - `:hiernate` : サーバの状態をメモリから退避(メモリの節約)
- `handle_cast(request, state)`
    - レスポンス
        `:noreply`, `:stop`
- `handle_info(info, state)`
    - _call, _cast以外から来るメッセージの処理
        - timeoutなど
- `terminate(reason, state)`
    - 終了時に呼ばれる
- `code_change(from_version, state, extra)`
    - ホットデプロイの際に状態表現が変わった場合、その対応用
- `format_status(reason, [pdict, state])`
    - ステータスメッセージのカスタマイズ

### サーバーのインタフェース

- GenServerの呼び出し方やリクエストの方法などを、外部から隠蔽するためにサーバーモジュールでAPIを実装する
- 慣習でサーバの起動関数名は`start_link()`
- 注意 : `handle_call()`などはOTP側から呼べるようにプライベートにはしない
