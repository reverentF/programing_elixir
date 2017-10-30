defmodule Func do
    # ModulesAndFunctions-4
    def sum(0), do: 0
    def sum(n), do: n + sum(n-1)
    # ModulesAndFunctions-5    
    def gcd(x, 0), do: x
    def gcd(x, y), do: gcd(y, rem(x, y))
    # ModulesAndFunctions-6
    def guess(actual, s..e) do
        guess_value = div(s+e,2)
        IO.puts("Is it #{guess_value}")
        _guess(guess_value, actual, s..e)
    end

    def _guess(guess_value, actual, s..e) when guess_value == actual do
        IO.puts(guess_value)
    end
    def _guess(guess_value, actual, s..e) when guess_value > actual do
        guess(actual, s..(guess_value-1))
    end
    def _guess(guess_value, actual, s..e) when guess_value < actual do
        guess(actual, (guess_value+1)..e)
    end

end