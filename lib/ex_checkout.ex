defmodule ExCheckout do
  @green_tea 3.11
  @strawberry 5.0
  @coffee 11.23
  @descount_strawberry 4.5

  @product_catalog %{
    "GR1" => %{price: @green_tea, rule: :bogo},
    "SR1" => %{price: @strawberry, discount_price: @descount_strawberry, rule: :bulk},
    "CF1" => %{price: @coffee, rule: :volume_discount}
  }

  def scan(list_of_products) do
    list_of_products
    |> Enum.filter(&is_valid_product?/1)
    |> Enum.frequencies()
    |> Enum.map(fn {key, value} -> calculate_total(key, value) end)
    |> Enum.sum()
  end

  @doc false
  def calculate_total(product_code, quantity) do
    case @product_catalog[product_code] do
      %{rule: :bogo, price: price} ->
        calculate_bogo(price, quantity)

      %{rule: :bulk, price: price, discount_price: discount_price} ->
        calculate_bulk(price, discount_price, quantity)

      %{rule: :volume_discount, price: price} ->
        calculate_volume_discount(price, quantity)

      _ ->
        0
    end
  end

  @doc false
  defp calculate_bogo(price, quantity) do
    # every second green tea is free
    # Split the total quantity into pairs (buy-one-get-one-free applies to pairs)
    {quotient, remainder} = {div(quantity, 2), rem(quantity, 2)}
    quotient * price + remainder * price
  end

  @doc false
  defp calculate_bulk(price, discount_price, quantity) do
    # Price drops to £4.50 per each  SR1 if 3 or more SR1s are purchased.
    if quantity >= 3, do: quantity * discount_price, else: quantity * price
  end

  @doc false
  defp calculate_volume_discount(price, quantity) do
    # Price of CF1 drops to two-thirds if 3 or more CF1s are purchased.
    if quantity >= 3, do: quantity * price * 2 / 3, else: quantity * price
  end

  @doc false
  defp is_valid_product?(product_code) do
    # check product is valid(part of the products in the catalog)
    Map.has_key?(@product_catalog, product_code)
  end
end
