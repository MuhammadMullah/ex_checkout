defmodule ExCheckoutTest do
  use ExUnit.Case
  doctest ExCheckout

  alias ExCheckout

  describe "scan/1" do
    test "calculates total for a valid basket with mixed products" do
      assert ExCheckout.scan(["GR1", "SR1", "CF1"]) == 19.34
    end

    test "returns 0.0 for an empty basket" do
      assert ExCheckout.scan([]) == 0.0
    end

    test "ignores invalid product codes and calculates total for valid products" do
      assert ExCheckout.scan(["GR1", "INVALID", "CF1"]) == 14.34
    end

    test "calculates total for basket with multiple GR1" do
      assert ExCheckout.scan(["GR1", "GR1", "GR1", "GR1"]) == 6.22
    end

    test "calculates total for basket with multiple SR1" do
      assert ExCheckout.scan(["SR1", "SR1", "SR1", "SR1"]) == 18.00
    end

    test "calculates total for basket with multiple CF1" do
      assert ExCheckout.scan(["CF1", "CF1", "CF1", "CF1"]) == 29.95
    end
  end

  describe "valid_product?/1" do
    test "returns true for valid product codes" do
      assert ExCheckout.valid_product?("GR1") == true
      assert ExCheckout.valid_product?("SR1") == true
      assert ExCheckout.valid_product?("CF1") == true
    end

    test "returns false for invalid product codes" do
      assert ExCheckout.valid_product?("INVALID") == false
    end
  end

  describe "calculate_total/2" do
    test "calculates total for GR1 with buy-one-get-one-free rule" do
      assert ExCheckout.calculate_total("GR1", 5) == 9.33
    end

    test "calculates total for SR1 with bulk discount (3 or more items)" do
      assert ExCheckout.calculate_total("SR1", 3) == 13.50
    end

    test "calculates total for CF1 with volume discount (3 or more items)" do
      assert ExCheckout.calculate_total("CF1", 3) == 22.46
    end

    test "returns 0 for invalid product codes" do
      assert ExCheckout.calculate_total("INVALID", 2) == 0.0
    end
  end
end
