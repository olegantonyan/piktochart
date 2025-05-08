require_relative "piktochart/version"
require_relative "piktochart/catalog"
require_relative "piktochart/basket"
require_relative "piktochart/delivery_rules"
require_relative "piktochart/offer_rules"
require_relative "piktochart/offer_rules/buy_one_red_widget_get_second_half_price"

module Piktochart
  class Configuration
    attr_accessor :catalog, :delivery_rules, :offer_rules

    # rubocop: disable Metrics/MethodLength, Layout/FirstArrayElementIndentation
    def initialize
      @catalog = ::Piktochart::Catalog.new([
        ::Piktochart::Catalog::Product.new(code: "R01", name: "Red Widget", price: 3295),
        ::Piktochart::Catalog::Product.new(code: "G01", name: "Green Widget", price: 2495),
        ::Piktochart::Catalog::Product.new(code: "B01", name: "Blue Widget", price: 795)
      ])
      @delivery_rules = ::Piktochart::DeliveryRules.new([
        ::Piktochart::DeliveryRules::DeliveryRule.new(greater_than: 0, price: 495),
        ::Piktochart::DeliveryRules::DeliveryRule.new(greater_than: 5000, price: 295),
        ::Piktochart::DeliveryRules::DeliveryRule.new(greater_than: 9000, price: 0)
      ])
      @offer_rules = ::Piktochart::OfferRules.new([
        ::Piktochart::OfferRules::BuyOneRedWidgetGetSecondHalfPrice.new
      ])
    end
    # rubocop: enable Metrics/MethodLength, Layout/FirstArrayElementIndentation
  end

  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield(config)
    end
  end
end
