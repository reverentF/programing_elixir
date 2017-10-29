fizzbuzz = fn
    0, 0, _ -> "FIzzBuzz"
    0, _, _ -> "Fizz"
    _, 0, _ -> "Buzz"
    _, _, a -> a
end

n_fizzbuzz = fn n -> fizzbuzz.(rem(n,3),rem(n,5),n) end

doFizzBuzz = fn n -> Enum.map(1..n, n_fizzbuzz) end

IO.inspect(doFizzBuzz.(20))