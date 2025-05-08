require "forwardable"

module Piktochart
  class OfferRules
    include ::Enumerable
    extend ::Forwardable

    def_delegators :rules, :each, :size, :inspect, :to_s

    def initialize(rules)
      @rules = rules
      freeze
    end

    def call(products)
      sum { it.call(products) }
    end

    private

    attr_reader :rules
  end
end
