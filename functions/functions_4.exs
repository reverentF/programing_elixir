prefix = fn pre_str ->
            fn string ->
                "#{pre_str} #{string}"
            end
        end

mrs = prefix.("Mrs")
IO.inspect(mrs.("Smith"))
IO.inspect(prefix.("Elixir").("Rocks"))