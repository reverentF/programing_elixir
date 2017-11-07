defmodule MyList do
    # def sum(list), do: _sum(list, 0)
    # # private
    # defp _sum([], total),   do: total
    # defp _sum([head|tail], total), do: _sum(tail, head+total)

    # ListsAndRecursion-0
    def sum([]), do: 0
    def sum([head | tail]), do: head + sum(tail)

    # ListsAndRecursion-1
    def mapsum([], _), do: 0
    def mapsum([head|tail], func), do: func.(head) + mapsum(tail, func)

    # ListsAndRecursion-2
    def max([head|tail]), do: _max(tail, head)   
    defp _max([], maxval), do: maxval
    defp _max([head|tail], maxval) when head >= maxval, do: _max(tail, head)
    defp _max([head|tail], maxval) when head < maxval, do: _max(tail, maxval)
    
    # ListsAndRecursion-3
    def caesar([], _), do: []
    # ちょっと汚い
    def caesar([head|tail], n), do: [_caesar(head, n)] ++ caesar(tail, n)
    defp _caesar(x, n) when (x + n) > ?z, do: (x + n) - (?z - ?a + 1)
    defp _caesar(x, n), do: x + n

    # ListsAndRecursion-4
    def span(to, to), do: [to]
    def span(from, to) when from < to, do: [from] ++ span(from+1, to)
    
    # ListsAndRecursion-7
    def span_prime(from \\ 2, to) do
        with list = span(2, to)
        do
            for x <- span(from, to), Enum.all?(list, &(&1 >= x or rem(x,&1) != 0)), do: x
        end
    end
end