# Piktochart

[![CI Ruby](https://github.com/olegantonyan/piktochart/actions/workflows/tests.yml/badge.svg)](https://github.com/olegantonyan/piktochart/actions/workflows/tests.yml)

Calculate the total products price with delivery and offers.

## Usage

There are 2 ways to use this gem.

### 1. As a gem

Add to your Gemfile:

```ruby
gem "piktochart", github: "olegantonyan/piktochart"
```

Use `Piktochart::Basket` class to add products and calculate the total price:
```ruby
basket = ::Piktochart::Basket.new
basket.add("G01")
basket.total #=> 2990
```

Configure the product catalog, delivery, offer rules if needed:

```ruby
# app/initializers/piktochart.rb
::Piktochart.configure do |config|
  config.catalog = ::Piktochart::Catalog.new([
    ::Piktochart::Catalog::Product.new(code: "rpg", name: "Rocket launcher", price: 30_000),
    ::Piktochart::Catalog::Product.new(code: "k7", name: "Killer7", price: 77_700),
    ::Piktochart::Catalog::Product.new(code: "prl", name: "PRL 412", price: 0)
  ])
  config.delivery_rules = ::Piktochart::DeliveryRules.new([
    ->(total_order_price) { total_order_price > 50_000 ? 0 : 146 } # free delivery for orders over 50k
  ])
  config.offer_rules = ::Piktochart::OfferRules.new([
    ->(products) { products.count == 9 ? -100_500 : 0 }, # scammy offer - why not?
    ->(products) { products.count == 3 ? 200 : 0 },
    ->(products) { products.count { it.code == "rpg" } > 2 ? 1000 : 0 } # 1k off when buying 3+ rocket launchers
  ])
end
```

If you don't override the global config, a default one will be used (see `lib/piktochart.rb`).

You can pass `catalog`, `delivery_rules`, `offer_rules` to `Piktochart::Basket` constructor to override the global config:

```ruby
basket = ::Piktochart::Basket.new(catalog: ::Piktochart::Catalog.new(..., offer_rules: ...)
```

A delivery rule and/or an offer rule can be any object that respondents to `call`. For delivery rules it must accept a number - total price of all products. For offer rules it must accept an array of products.

### 2. As a standalone executable

Run `exe/piktochart` binary interactively and enter the product codes when prompted:

```shell
$ exe/piktochart
```

Or non-interactively:
```shell
$ echo "G01" | exe/piktochart

Products catalog:
[R01] Red Widget - $32.95
[G01] Green Widget - $24.95
[B01] Blue Widget - $7.95
Enter your product codes separated by whitespace
Your basket: G01
Total price: $29.90
```

## Assumptions

1. The price is always in USD cents as an Integer. Price formatting assumes USD currency by default but allows to override the formatter. In case of multiple currencies extract Price class that incapsulates the currency and the value.
2. A default offer "buy one red widget, get the second half price" assumed to be applied only once no matter how many even number red widgets there are.
3. The gem is a standard way of writing Ruby libraries and executables, it's complete and "production-ready", with tests, CI setup, README, etc.
4. Use latest Ruby version.
