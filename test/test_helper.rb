$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "piktochart"

require "minitest/autorun"

def build_basket(*codes, **basket_kwargs)
  ::Piktochart::Basket.new(**basket_kwargs).tap do |basket|
    codes.each { basket.add(it) }
  end
end
