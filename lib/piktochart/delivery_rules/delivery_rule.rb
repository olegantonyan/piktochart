module Piktochart
  class DeliveryRules
    class DeliveryRule
      def initialize(price:, greater_than:)
        @price = price
        @greater_than = greater_than
        freeze
      end

      def call(total_order_price)
        return unless total_order_price > greater_than

        price
      end

      private

      attr_reader :price, :greater_than
    end
  end
end
