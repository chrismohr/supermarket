require 'rspec'
require '/Users/cmohr/play/beans/supermarket.rb'

describe Receipt::LineItem do

  subject { Receipt::LineItem.new(product: product, quantity: quantity) }

  let(:name)             { "Beans" }
  let(:item_price)       { 65 }
  let(:three_item_price) { 100 }
  let(:quantity)         { 1 }

  let(:single_item_strategy)        { PricingStrategy.new(price_in_cents: item_price, qualifying_quantity: 1) }
  let(:three_for_a_dollar_strategy) { PricingStrategy.new(price_in_cents: three_item_price, qualifying_quantity: 3) }

  let(:product) { Product.new(name: name, pricing_strategies: pricing_strategies) }

  let(:pricing_strategies) { [single_item_strategy, three_for_a_dollar_strategy] }

  it "has a name" do
    expect(subject.name).to eq(name)
  end

  it "has a price_in_cents" do
    expect(subject.price_in_cents).to eq(item_price)
  end

  it "#formatted_price" do
    expect(subject.formatted_price).to eq("$0.65")
  end

  context "quantity of 3" do
    let(:quantity) { 3 }

    it "#price_in_cents" do
      expect(subject.price_in_cents).to eq(three_item_price)
    end
  end

  context "quantity of 4" do
    let(:quantity) { 4 }

    it "#price_in_cents" do
      expect(subject.price_in_cents).to eq(three_item_price + item_price)
    end
  end

  context "quantity of 5" do
    let(:quantity) { 5 }

    it "#price_in_cents" do
      expect(subject.price_in_cents).to eq(three_item_price + item_price * 2)
    end
  end

  context "fractional price" do
    let(:item_price) { 199 }
    let(:quantity) { 0.25 }

    it "#price_in_cents" do
      expect(subject.price_in_cents).to eq(50)
    end
  end
end
