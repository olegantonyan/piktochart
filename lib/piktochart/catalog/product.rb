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

      def to_s
        "#{name} (#{code}) - #{format("$%.2f", price / 100.0)}"
      end
      alias inspect to_s
    end
  end
end
