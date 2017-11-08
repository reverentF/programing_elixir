# ControlFlow-1
defmodule FizzBuzz do
    def upto(n) do
        1..n |> Enum.map(&_fizzbuzz/1)
    end

    defp _fizzbuzz(n) do
        case {rem(n,3), rem(n,5)} do
            {0, 0} -> "FizzBuzz"
            {0, _} -> "Fizz"
            {_, 0} -> "Buzz"
            {_, _} -> n
        end
    end
end