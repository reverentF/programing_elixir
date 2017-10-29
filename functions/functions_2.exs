fizzbuzz = fn
    0, 0, _ -> "FIzzBuzz"
    0, _, _ -> "Fizz"
    _, 0, _ -> "Buzz"
    _, _, a -> a
end

IO.inspect(fizzbuzz.(0,0,1))
IO.inspect(fizzbuzz.(0,1,1))
IO.inspect(fizzbuzz.(1,0,1))
IO.inspect(fizzbuzz.(1,1,2))

    