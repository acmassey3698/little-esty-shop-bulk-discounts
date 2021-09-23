require 'rails_helper'

# Merchant Bulk Discounts Index
#
# As a merchant
# When I visit my merchant dashboard
# Then I see a link to view all my discounts
# When I click this link
# Then I am taken to my bulk discounts index page
# Where I see all of my bulk discounts including their
# percentage discount and quantity thresholds
# And each bulk discount listed includes a link to its show page

RSpec.describe 'merchants discounts index' do
  before :each do
      @merch1 = create(:merchant)
      @merch2 = create(:merchant)
      @disc1 = @merch1.discounts.create!(percentage: 20, threshold: 5)
      @disc2 = @merch1.discounts.create!(percentage: 50, threshold: 25)
      @disc3 = @merch1.discounts.create!(percentage: 10, threshold: 2)
      @disc4 = @merch2.discounts.create!(percentage: 15, threshold: 20)

      visit merchant_discounts_path(@merch1)
  end

  it 'shows all discounts associated with the merchant' do
    save_and_open_page

    expect(page).to have_content("#{@disc1.percentage}% off #{@disc1.threshold} items")
    expect(page).to have_content("#{@disc2.percentage}% off #{@disc2.threshold} items")
    expect(page).to have_content("#{@disc3.percentage}% off #{@disc3.threshold} items")

    expect(page).to_not have_content("#{@disc4.percentage}% off #{@disc4.threshold} items")
  end
end
