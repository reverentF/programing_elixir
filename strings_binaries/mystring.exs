defmodule MyString do
    # StringsAndBinaries-1
    def printable?(str) do
        Enum.all?(str, &(&1 >= ?\s && &1 <= ?~))
    end

    # StrindsAndBinaries-2
    def anagram?([], []), do: true
    def anagram?(str1 = [head|tail], str2) do
        if Enum.member?(str2, head) do
            anagram?(tail, List.delete(str2, head))
        else
            false
        end
    end
    def anagram?(_, _), do: false

    # StringsAndBinaries-4
    def calculate(str) do
        [str1, op, str2] = Enum.chunk_by(str, &(&1 == ?\s)) |> Enum.reject(&(&1 == ' '))
        _calc(_atoi(str1), op, _atoi(str2))
    end
    defp _atoi(str) do
        Enum.reduce(str, 0, fn(x, acc) -> (x - ?0) + acc*10 end)
    end
    defp _calc(num1, '+', num2) do
        num1 + num2
    end
    defp _calc(num1, '-', num2) do
        num1 - num2
    end
    defp _calc(num1, '*', num2) do
        num1 * num2
    end
    defp _calc(num1, '/', num2) do
        num1 / num2
    end

    # StringsAndBinaries-5
    def center(str_list) do
        max_length = Enum.max_by(str_list, &String.length/1) |> String.length
        Enum.map(str_list, &(IO.puts(_centering(&1, max_length))))
    end
    defp _centering(str, max_length) do
        len1 = Float.floor(max_length / 2)
        len2 = Float.floor(String.length(str) / 2)
        space_num = round(len1 - len2)
        String.duplicate(" ", space_num) <> str
    end
    
end

IO.puts("StringsAndBinaries-1")
str = 'cat'
IO.inspect(MyString.printable?(str))
str2 = str ++ [0]
IO.inspect(MyString.printable?(str2))

IO.puts("StringsAndBinaries-2")
IO.inspect(MyString.anagram?('cat', 'tac'))
IO.inspect(MyString.anagram?('abc', 'dcba'))
IO.inspect(MyString.anagram?('abcd', 'bca'))
IO.inspect(MyString.anagram?('abcd', 'abcd'))

IO.puts("StringsAndBinaries-3")
IO.inspect("['cat' | 'dog'] == [[?c, ?a, ?t], ?d, ?o, ?g]")
IO.inspect(['cat' | 'dog'] == [[?c, ?a, ?t], ?d, ?o, ?g])

IO.puts("StringsAndBinaries-4")
IO.inspect("MyString.calculate('1 + 2')")
IO.inspect(MyString.calculate('1 + 2'))
IO.inspect("MyString.calculate('1 * 2')")
IO.inspect(MyString.calculate('1 * 2'))
IO.inspect("MyString.calculate('1 / 2')")
IO.inspect(MyString.calculate('1 / 2'))
IO.inspect("MyString.calculate('1 - 2')")
IO.inspect(MyString.calculate('1 - 2'))

IO.puts("StringsAndBinaries-4")
IO.inspect(MyString.center(["cat", "zebra", "elephant"]))