module Piktochart
  class OfferRules
    class BuyOneRedWidgetGetSecondHalfPrice
      def call(products)
        red_widgets = products.select { it.code == "R01" }
        if red_widgets.count >= 2
          (red_widgets.first.price / 2.0).round
        else
          0
        end
      end
    end
  end
end
