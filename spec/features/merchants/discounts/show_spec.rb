require 'rails_helper'

RSpec.describe 'merchants discounts index' do
  before :each do
      @merch1 = create(:merchant)
      @merch2 = create(:merchant)
      @disc1 = @merch1.discounts.create!(percentage: 20, threshold: 5)
      @disc2 = @merch1.discounts.create!(percentage: 50, threshold: 25)
      @disc3 = @merch1.discounts.create!(percentage: 10, threshold: 2)
      @disc4 = @merch2.discounts.create!(percentage: 15, threshold: 20)

      visit merchant_discount_path(@merch1, @disc1)
  end

  it 'Shows threshold and percentage' do
    expect(page).to have_content("Quantity Threshold: #{@disc1.threshold}")
    expect(page).to have_content("Percent Discount: #{@disc1.percentage}%")
  end
end
