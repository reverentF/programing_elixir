# 文字列

## 式の埋め込み

- 文字列中に#{}で式を埋め込める

```elixir
iex(1)> lang = "elixir"
"elixir"
iex(2)> "Hello, #{String.capitalize lang}"
"Hello, Elixir"
```

## ヒアドキュメント記法

- ドキュメント用の記法
- `"""`か`'''`で囲む

```elixir
iex(3)> IO.write """
...(3)>     this
...(3)>         is
...(3)>     test
...(3)>     """
this
    is
test
:ok
```
- 先頭空行破棄
- 末尾`""" (''')`のインデントに合わせて先頭の空白を削除

- ちなみに`"""`の後に空行を入れないと怒られる
```sh
iex(4)> IO.write """ a
** (SyntaxError) iex:4: heredoc start must be followed by a new line after """
```

## シジル(Sigil)

- ある種のリテラルを簡潔に表せる記法
- [ドキュメント](http://elixir-ja.sena-net.works/getting_started/19.html)
- 形式
```
~[タイプを示す1字][区切り文字]...[区切り文字]<オブション>
 ```
- 例
```elixir
iex(4)> ~c"this is test of #{lang}"
'this is test of elixir'
iex(5)> ~w"this is test of #{lang}"
["this", "is", "test", "of", "elixir"]
iex(6)> ~s"this is test of #{lang}"
"this is test of elixir"
```
- 正規表現`~r/.../`もこれ
- 区切り文字を`"""`or`'''`にするとヒアドキュメントとして扱われる
- 自前で定義もできる

# シングルクォートとダブルクォート

- シングルクォート : 文字コードのリスト
- ダブルクォート : 文字列(バイナリで表現)
```elixir
iex(9)> [head|tail] = "cat"
** (MatchError) no match of right hand side value: "cat"

iex(9)> [head|tail] = 'cat'
'cat'
iex(10)> head
99
iex(11)> tail
'at'
```

- 文字列用のライブラリはダブルクォートにしか働かなかったりする

## バイナリ

- バイナリリテラル
```
 << 項, ... >>
```

- ビット数の指定
```elixir
iex(13)> b = << 1::size(2), 1::size(3)>>
<<9::size(5)>>
```
- 01 001 -> 01001 -> 9

- そのほか
```elixir
iex(12)> f = << 2.5 :: float >>
<<64, 4, 0, 0, 0, 0, 0, 0>>
iex(13)> f = << 2.5 >>
** (ArgumentError) argument error
iex(14)> test = << 1, f::binary >>
<<1, 64, 4, 0, 0, 0, 0, 0, 0>>
```

## 文字列
- 文字列はバイナリで表現される
    - 必ずしも[バイナリのサイズ == 文字列のサイズ]ではないことに注意
    ```elixir
        iex(15)> test = "this is test"
        "this is test"
        iex(16)> String.length test
        12
        iex(17)> byte_size test
        12
        iex(18)> test = "∫x+y"
        "∫x+y"
        iex(19)> String.length test
        4
        iex(20)> byte_size test
        6
    ```

## バイナリとパターンマッチ
- 疑わしければフィールドの型を指定せよ
- バイナリ版headとtail
```
<< head::utf8, tail::binary >> = "string"
```
- 例
```elixir
iex(21)> << head::utf8, tail::binary >> = "string"
"string"
iex(22)> head
115
iex(23)> tail
"tring"
iex(24)> << "str", tail::binary >> = "string"
"string"
iex(25)> tail
"ing"
```