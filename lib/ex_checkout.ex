defmodule ExCheckout do
  @moduledoc """
  ExCheckout is a flexible and extensible checkout system designed for a supermarket chain.
  It manages a cart, scans items, and calculates the total price dynamically based on predefined pricing rules.
  Dynamic pricing rules supported such as:
  - Buy-One-Get-One-Free
  - Bulk Discounts
  - Volume Discounts
  """
  @green_tea 3.11
  @strawberry 5.0
  @coffee 11.23
  @descount_strawberry 4.5

  @product_catalog %{
    "GR1" => %{price: @green_tea, rule: :bogo},
    "SR1" => %{price: @strawberry, discount_price: @descount_strawberry, rule: :bulk},
    "CF1" => %{price: @coffee, rule: :volume_discount}
  }

  @doc """
  Scans a list of product codes, validates them, calculates their total price based on predefined pricing rules,
  and returns the total price.

  ## Example
    iex> ExCheckout.scan(["GR1", "SR1", "CF1"])
    19.34
  """
  @spec scan(list(String.t())) :: float()
  def scan(list_of_products) do
    list_of_products
    |> Enum.filter(&valid_product?/1)
    |> Enum.frequencies()
    |> Enum.map(fn {key, value} -> calculate_total(key, value) end)
    |> Enum.sum()
    |> Kernel.+(0.0)
    |> Float.round(2)
  end

  @doc """
  Calculates the total price for a given product code and quantity based on its pricing rules.

  ## Example
    iex> ExCheckout.calculate_total("GR1", 4)
    6.22
  """
  @spec calculate_total(String.t(), non_neg_integer()) :: float()
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

  @doc """
  check product is valid(part of the products in the catalog)
  """
  @spec valid_product?(String.t()) :: boolean()
  def valid_product?(product_code) do
    Map.has_key?(@product_catalog, product_code)
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
    if quantity >= 3 do
      Float.round(quantity * discount_price, 2)
    else
      Float.round(quantity * price, 2)
    end
  end

  @doc false
  defp calculate_volume_discount(price, quantity) do
    # Price of CF1 drops to two-thirds if 3 or more CF1s are purchased.
    if quantity >= 3 do
      Float.round(quantity * price * 2 / 3, 2)
    else
      Float.round(quantity * price, 2)
    end
  end
end
