module Piktochart
  class Catalog
    class Product
      attr_reader :code, :name, :price

      def initialize(code:, name:, price:)
        @name = name
        @price = price
        @code = code
        freeze
      end

      def to_s(price_formatter: ->(value) { format("$%.2f", value / 100.0) })
        "[#{code}] #{name} - #{price_formatter.call(price)}"
      end
      alias inspect to_s
    end
  end
end
