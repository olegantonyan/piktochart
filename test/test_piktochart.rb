require "test_helper"

class TestPiktochart < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Piktochart::VERSION
  end

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

  private

  def build_basket(*codes)
    ::Piktochart::Basket.new.tap do |basket|
      codes.each { basket.add(it) }
    end
  end
end
