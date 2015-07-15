require 'virtus'

class PricingStrategy
  include Virtus.model
  attribute :price_in_cents, Integer
  attribute :qualifying_quantity, Integer
end

class Product
  include Virtus.model
  attribute :name, String
  attribute :pricing_strategies, [PricingStrategy]
end

class Receipt
  class LineItem
    include Virtus.model
    attribute :product, Product
    attribute :quantity, Float

    def name
      product.name
    end

    def formatted_price
      "$" + "#{price_in_cents}".rjust(3, "0").insert(-3, ".")
    end

    def price_in_cents
      unpriced_quantity = quantity
      total = 0
      while ps = pricing_strategy(unpriced_quantity)
        unpriced_quantity -= ps.qualifying_quantity
        total += ps.price_in_cents
      end
      total += default_pricing_strategy.price_in_cents * unpriced_quantity
      total.round
    end

  private

    def sorted_pricing_strategies
      product.pricing_strategies.sort_by(&:qualifying_quantity).reverse
    end

    def pricing_strategy(quantity)
      sorted_pricing_strategies.find { |ps| ps.qualifying_quantity <= quantity }
    end

    def default_pricing_strategy
      sorted_pricing_strategies.last
    end
  end
end
