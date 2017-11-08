defmodule Control do
    def ok!({:ok, data}), do: data
    def ok!({_, reason}), do: raise RuntimeError, message: "reason: #{reason}"
end