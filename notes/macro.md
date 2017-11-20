# マクロ

- コンパイラの中間表現の話から始まるから闇っぽいなあと敬遠しそうになったけど、
演習やったらそんなでもなかった
- 理解のために, ごば氏のまとめ見たら死ぬほど分かりやすかったからここではまとめない

#### 滅茶苦茶簡易なまとめ
- `quote`関数
    - ブロックの中身を未評価のまま返す
    - マクロ呼び出し部にブロックの中身をコード片として埋め込むイメージ
- `unquote`関数
    - 中身を評価して返す
    - unquote部分を遅延評価するイメージ
    - マクロ展開時ではなくコード実行時に評価される

#### 注意点
- 関数定義とかもマクロにできる
- 関数名はアトムとして渡さないといけないので注意
    - ダメ
    ```elixir
    funcname = "func_#{number}"
    def unquote(funcname)(args) do: ...
    ```
    - ok
    ```elixir
    funcname = :"func_#{number}"
    def unquote(funcname)(args) do: ...
    ```