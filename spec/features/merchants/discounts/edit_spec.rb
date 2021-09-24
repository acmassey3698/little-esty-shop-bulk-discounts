require 'rails_helper'

RSpec.describe 'merchant discounts edit' do
  before :each do
    @merch1 = create(:merchant)
    @merch2 = create(:merchant)
    @disc1 = @merch1.discounts.create!(percentage: 20, threshold: 5)
    @disc2 = @merch1.discounts.create!(percentage: 50, threshold: 25)
    @disc3 = @merch1.discounts.create!(percentage: 10, threshold: 2)
    @disc4 = @merch2.discounts.create!(percentage: 15, threshold: 20)

    visit edit_merchant_discount_path(@merch1, @disc1)
  end

  it 'has a form to fill out the percentage and threshold' do
    expect(page).to have_field(:percentage, with: @disc1.percentage)
    expect(page).to have_field(:threshold, with: @disc1.threshold)
    expect(page).to have_button("Edit Discount")
  end

  it 'edits the discount when information is changed' do
    fill_in(:percentage, with: 30)
    fill_in(:threshold, with: 8)
    click_button("Edit Discount")

    expect(current_path).to eq(merchant_discounts_path(@merch1))
    expect(page).to have_content("Discount Updated Successfully")

    @disc1.reload

    within "#discount-#{@disc1.id}" do
      expect(page).to have_content("30% off 8 items")
      expect(page).to_not have_content("20% off 5 items")
    end
  end

  it 'does not allow invalid inputs in the edit form' do
    fill_in(:percentage, with: -100)
    fill_in(:threshold, with: 0)
    click_button("Edit Discount")

    expect(current_path).to eq(edit_merchant_discount_path(@merch1, @disc1))
    expect(page).to have_content("Edit Unsuccessful. Try Again.")
  end
end
