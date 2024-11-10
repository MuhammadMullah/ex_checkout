# ExCheckout

A flexible and extensible checkout system designed for a supermarket chain to manage a cart, scan items, and calculate the total price dynamically based on predefined pricing rules.

## Features

## Features

- Product Scanning:
  - Add products to a cart and calculate the total price dynamically.
- Flexible Pricing Rules:
  - Buy-One-Get-One-Free for Green Tea (`GR1`).
  - Bulk Discount for Strawberries (`SR1`): Price drops from £5.00 to £4.50 when buying 3 or more.
  - Volume Discount for Coffee (`CF1`): Price reduces to two-thirds of the original price when buying 3 or more.
- Scalable architecture:
  - Designed to accommodate new products and pricing rules with minimal changes.

## Usage

### Prerequisites

- Elixir (1.17 or later)
- Mix (included with Elixir)

### Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/MuhammadMullah/ex_checkout.git
   cd ex_checkout

2. Install Dependancies:
   ```bash
   mix deps.get

3. Install Dependancies:
   ```bash
   mix test

## Example Usage

  ```bash
  iex> ExCheckout.scan(["GR1", "SR1", "CF1"])
  19.34
