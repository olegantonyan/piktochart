require "English"

require "test_helper"

class TestPiktochart < Minitest::Test
  def test_sample_basket1
    assert_equal 3785, build_basket("B01", "G01").total
  end

  def test_sample_basket2
    assert_equal 5437, build_basket("R01", "R01").total
  end

  def test_sample_basket3
    assert_equal 6085, build_basket("R01", "G01").total
  end

  def test_sample_basket4
    assert_equal 9827, build_basket("B01", "B01", "R01", "R01", "R01").total
  end

  def test_delivery_rules_cannot_be_empty
    assert_raises(::Piktochart::DeliveryRules::InvalidError) do
      build_basket("R01", "R01", delivery_rules: ::Piktochart::DeliveryRules.new([]))
    end
  end

  def test_no_applicable_delivery_rules
    assert_raises(::Piktochart::DeliveryRules::NotApplicableError) do
      build_basket("R01", "R01", delivery_rules: ::Piktochart::DeliveryRules.new([proc {}])).total
    end
  end

  def test_adding_non_existing_product
    assert_raises(::IndexError) do
      build_basket("R01", "R01").add("nope")
    end
  end

  def test_with_custom_product_catalog_offers_delivery # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
    delivery_rules = ::Piktochart::DeliveryRules.new([
      ->(total_order_price) { total_order_price > 50_000 ? 0 : 146 } # free delivery for orders over 50k
    ])
    offer_rules = ::Piktochart::OfferRules.new([
      ->(products) { products.count == 9 ? -100_500 : 0 }, # scammy offer - why not?
      ->(products) { products.count == 3 ? 200 : 0 },
      ->(products) { products.count { it.code == "rpg" } > 2 ? 1000 : 0 } # 1k off when buying 3+ rocket launchers
    ])
    catalog = ::Piktochart::Catalog.new([
      ::Piktochart::Catalog::Product.new(code: "rpg", name: "Rocket launcher", price: 30_000),
      ::Piktochart::Catalog::Product.new(code: "k7", name: "Killer7", price: 77_700),
      ::Piktochart::Catalog::Product.new(code: "prl", name: "PRL 412", price: 0)
    ])

    assert_equal 146, build_basket("prl", delivery_rules:, offer_rules:, catalog:).total
    assert_equal 30_146, build_basket("rpg", delivery_rules:, offer_rules:, catalog:).total
    assert_equal 107_500, build_basket("k7", "rpg", "prl", delivery_rules:, offer_rules:, catalog:).total
    assert_equal 422_600,
                 build_basket("k7", "rpg", "prl", "k7", "rpg", "prl", "k7", "rpg", "prl", delivery_rules:,
                                                                                          offer_rules:, catalog:).total
    assert_equal 0, build_basket("prl", "prl", "prl", delivery_rules:, offer_rules:, catalog:).total
  end

  def test_cli # rubocop: disable Metrics/MethodLength
    result = `echo "R01 G01" | exe/piktochart`

    expected = <<~STR
      Products catalog:
      [R01] Red Widget - $32.95
      [G01] Green Widget - $24.95
      [B01] Blue Widget - $7.95
      Enter your product codes separated by whitespace
      Your basket: R01 G01
      Total price: $60.85
    STR
    assert $CHILD_STATUS.success?
    assert_equal expected, result
  end
end
