module Piktochart
  class Basket
    attr_reader :products, :delivery_rules, :offer_rules, :catalog

    def initialize(delivery_rules: ::Piktochart.config.delivery_rules, offer_rules: ::Piktochart.config.offer_rules,
                   catalog: ::Piktochart.config.catalog)
      @products = []
      @delivery_rules = delivery_rules
      @offer_rules = offer_rules
      @catalog = catalog
    end

    def add(code)
      products << catalog[code]
    end
    alias << add

    def total
      subtotal = products.sum(&:price)
      offers = offer_rules.call(products)
      subtotal_with_offers = subtotal - offers
      delivery = delivery_rules.call(subtotal_with_offers)
      [subtotal_with_offers + delivery, 0].max
    end
  end
end
