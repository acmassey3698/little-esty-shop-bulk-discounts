require 'rails_helper'

RSpec.describe 'merchant items new page' do
  before :each do
    @merchant = Merchant.create!(name: "Steve")
  end

  it 'has a form' do
    visit new_merchant_item_path(@merchant)

    expect(page).to have_content("Add New Item to #{@merchant.name}")
    expect(page).to have_field("Name")
    expect(page).to have_field("Description")
    expect(page).to have_field("Unit price")
  end

  it 'creates a new item' do
    visit new_merchant_item_path(@merchant)

    fill_in('Name', with: 'Keyboard')
    fill_in('Description', with: 'RGB')
    fill_in('Unit price', with: 4000)
    click_on "Create Item"

    expect(current_path).to eq("/merchants/#{@merchant.id}/items")

    within("#disabled") do
      expect(page).to have_content("Keyboard")
    end
  end

  it 'returns an error when a field is invalid' do
    visit new_merchant_item_path(@merchant)

    fill_in('Name', with: 'Keyboard')
    click_on "Create Item"

    expect(current_path).to eq(new_merchant_item_path(@merchant))
    expect(page).to have_content("Item not created. Information missing")
  end
end
