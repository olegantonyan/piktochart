require "forwardable"

require_relative "delivery_rules/delivery_rule"

module Piktochart
  class DeliveryRules
    include ::Enumerable
    extend ::Forwardable

    class InvalidError < ::StandardError; end
    class NotApplicableError < ::StandardError; end

    def_delegators :rules, :each, :size, :inspect, :to_s

    def initialize(rules)
      @rules = rules
      validate!
      freeze
    end

    def call(total_order_price)
      filter_map { it.call(total_order_price) }.min || (raise NotApplicableError, "no applicable delivery rules")
    end

    private

    attr_reader :rules

    def validate!
      raise InvalidError, "must have at least 1 delivery rule" if rules.empty?
    end
  end
end
