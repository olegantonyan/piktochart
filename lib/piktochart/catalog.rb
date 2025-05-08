require "forwardable"

require_relative "catalog/product"

module Piktochart
  class Catalog
    include ::Enumerable
    extend ::Forwardable

    def_delegators :products, :each, :size, :inspect, :to_s

    def initialize(products)
      @products = products
      freeze
    end

    def [](code)
      find { it.code == code } || (raise ::IndexError, "no such product code: #{code}")
    end

    private

    attr_reader :products
  end
end
