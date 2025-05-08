require "forwardable"

require_relative "delivery_rules/delivery_rule"

module Piktochart
  class DeliveryRules
    include ::Enumerable
    extend ::Forwardable

    def_delegators :rules, :each, :size, :inspect, :to_s

    def initialize(rules)
      @rules = rules
      freeze
    end

    def call(total_order_price)
      filter_map { it.call(total_order_price) }.min
    end

    private

    attr_reader :rules
  end
end
