defmodule ExCheckout do
  @moduledoc """
  ## Checkout System

  A flexible and extensible checkout system designed for a supermarket chain to scan items, manage a cart, and calculate the total price based on dynamic pricing rules.

  """

  @green_tea 3.11
  @strawberry 5.0
  @coffee 11.23
  @descount_strawberry 4.5


  def scan(list_of_products) do
    list_of_products
    |> Enum.frequencies()
    |> Enum.map(fn {key, value} -> calculate_total(key, value) end)
    |> Enum.sum()
  end

  def calculate_total("GR1", number_of_product) do
    case quotient_and_remainder(number_of_product) do
      %{quotient: quotient, remainder: 0} ->
        quotient * @green_tea

      %{quotient: quotient, remainder: _remainder} ->
        quotient * @green_tea + @green_tea
    end
  end

  def calculate_total("SR1", number_of_product) do
    case number_of_product >= 3 do
      true ->
        number_of_product * @descount_strawberry

      false ->
        number_of_product * @strawberry
    end
  end

  def calculate_total("CF1", number_of_product) do
    case number_of_product >= 3 do
      true ->
        number_of_product * @coffee * 2 / 3

      false ->
        number_of_product * @coffee
    end
  end

  defp quotient_and_remainder(dividend) do
    quotient = div(dividend, 2)
    remainder = rem(dividend, 2)
    %{quotient: quotient, remainder: remainder}
  end
end
