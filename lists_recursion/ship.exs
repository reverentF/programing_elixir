# ListsAndRecursion-8
defmodule Ship do
    def ship(orders, tax_rates) do
        Stream.map(orders, &(_ship(&1, tax_rates)))
        |> Enum.to_list
    end

    defp _ship(order = [id: _, ship_to: loc, net_amount: amount], tax_rates) do
        tax = amount * Keyword.get(tax_rates, loc, 0)
        total = amount + tax
        Keyword.put(order, :total_amount, total)
    end
end

tax_rates = [ NC: 0.075, TX: 0.08 ]
orders = [ [ id: 123, ship_to: :NC, net_amount: 100.00 ],
    [ id: 124, ship_to: :OK, net_amount:  35.50 ],
    [ id: 125, ship_to: :TX, net_amount:  24.00 ],
    [ id: 126, ship_to: :TX, net_amount:  44.80 ],
    [ id: 127, ship_to: :NC, net_amount:  25.00 ],
    [ id: 128, ship_to: :MA, net_amount:  10.00 ],
    [ id: 129, ship_to: :CA, net_amount: 102.00 ],
    [ id: 120, ship_to: :NC, net_amount:  50.00 ] ]
IO.inspect(Ship.ship(orders, tax_rates))