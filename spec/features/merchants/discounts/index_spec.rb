require 'rails_helper'

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
    within "#discount-#{@disc1.id}" do
      expect(page).to have_link("#{@disc1.percentage}% off #{@disc1.threshold} items")
    end

    within "#discount-#{@disc2.id}" do
      expect(page).to have_link("#{@disc2.percentage}% off #{@disc2.threshold} items")
    end

    within "#discount-#{@disc3.id}" do
      expect(page).to have_link("#{@disc3.percentage}% off #{@disc3.threshold} items")
    end

    expect(page).to_not have_link("#{@disc4.percentage}% off #{@disc4.threshold} items")
  end

  it 'links to the discount show page when the link is clicked' do
    within "#discount-#{@disc1.id}" do
      click_link("#{@disc1.percentage}% off #{@disc1.threshold} items")
    end

    expect(current_path).to eq(merchant_discount_path(@merch1, @disc1))
  end

  it 'has a link to create a new discount' do
    expect(page).to have_button("Create New Bulk Discount")
  end

  it 'links to the discount creation form' do
    click_button("Create New Bulk Discount")
    expect(current_path).to eq(new_merchant_discount_path(@merch1))
  end
end
