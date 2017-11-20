defmodule My do
  defmacro unless(condition, clauses) do
    do_clauses = Keyword.get(clauses, :do, nil)
    else_clauses = Keyword.get(clauses, :else, nil)
    quote do
      case unquote(condition) do
        false -> unquote(do_clauses)
        nil -> unquote(do_clauses)
        true -> unquote(else_clauses)
      end
    end
  end
end

defmodule Test do
  require My
  My.unless 1==2 do
    IO.puts("unless 1==2 do")
  else
    IO.puts("unless 1==2 else")  
  end
end