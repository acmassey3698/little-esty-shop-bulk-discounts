require 'rails_helper'

RSpec.describe 'merchants items show page' do
  before :each do
    @merchant = Merchant.create!(name: "Steve")
    @merchant_2 = Merchant.create!(name: "Kevin")
    @item_1 = @merchant.items.create!(name: "Lamp", description: "Sheds light", unit_price: 5)
    @item_2 = @merchant.items.create!(name: "Toy", description: "Played with", unit_price: 10)
    @item_3 = @merchant.items.create!(name: "Chair", description: "Sit on it", unit_price: 50)
    @item_4 = @merchant_2.items.create!(name: "Table", description: "Eat on it", unit_price: 100)
  end

  it "shows items attributes" do
    visit "/merchants/#{@merchant.id}/items/#{@item_1.id}"

    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_1.description)
    expect(page).to have_content(@item_1.unit_price)
  end

  it "shows items attributes" do
    visit "/merchants/#{@merchant.id}/items/#{@item_1.id}"

    expect(page).to have_button("Update Item")
  end

  it "redirects you to edit page after clicking update item" do
    visit "/merchants/#{@merchant.id}/items/#{@item_1.id}"

    click_on "Update Item"

    expect(current_path).to eq("/merchants/#{@merchant.id}/items/#{@item_1.id}/edit")
  end
end