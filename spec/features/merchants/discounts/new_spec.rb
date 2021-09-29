require 'rails_helper'

RSpec.describe 'merchant discounts new page' do
  before :each do
    @merch1 = create(:merchant)
    @merch2 = create(:merchant)
    @disc1 = @merch1.discounts.create!(percentage: 20, threshold: 5)
    @disc2 = @merch1.discounts.create!(percentage: 50, threshold: 25)
    @disc3 = @merch1.discounts.create!(percentage: 10, threshold: 2)
    @disc4 = @merch2.discounts.create!(percentage: 15, threshold: 20)

    visit new_merchant_discount_path(@merch1)
  end

  it 'has a form to fill out the percentage and threshold' do
    expect(page).to have_field(:percentage)
    expect(page).to have_field(:threshold)
    expect(page).to have_button("Create Discount")
  end

  it 'creates the new discount when the form is submitted' do
    fill_in(:percentage, with: 60)
    fill_in(:threshold, with: 100)
    click_button("Create Discount")

    expect(current_path).to eq(merchant_discounts_path(@merch1))
    expect(page).to have_link("60% off 100 items")
  end

  it 'flashes a notice when the form is filled out incorrectly' do
    click_button("Create Discount")

    expect(page).to have_content("Discount not created. Invalid Input")
    expect(current_path).to eq(new_merchant_discount_path(@merch1))
  end
end
