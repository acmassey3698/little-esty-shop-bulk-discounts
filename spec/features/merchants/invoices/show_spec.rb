require 'rails_helper'

RSpec.describe 'Merchant Invoices Show page' do
  before(:each) do
    @merch1 = create(:merchant)
    @merch2 = create(:merchant)
    @cust1 = create(:customer)
    @cust2 = create(:customer)
    @cust3 = create(:customer)
    @cust4 = create(:customer)
    @cust5 = create(:customer)
    @cust6 = create(:customer)
    @cust7 = create(:customer)
    @item1 = create(:item, merchant: @merch1)
    @item2 = create(:item, merchant: @merch1)
    @item3 = create(:item, merchant: @merch1)
    @item4 = create(:item, merchant: @merch2)
    @item5 = create(:item, merchant: @merch2)
    @item6 = create(:item, merchant: @merch2)
    @invoice1 = create(:invoice, customer: @cust1)
    @invoice2 = create(:invoice, customer: @cust2)
    @invoice3 = create(:invoice, customer: @cust3)
    @invoice4 = create(:invoice, customer: @cust4)
    @invoice5 = create(:invoice, customer: @cust5)
    @invoice6 = create(:invoice, customer: @cust6)
    @invoice7 = create(:invoice, customer: @cust7)
    @invoice8 = create(:invoice, customer: @cust7)
    InvoiceItem.create(item: @item1, invoice: @invoice1, status: 1, quantity: 15, unit_price: 1000)
    InvoiceItem.create(item: @item2, invoice: @invoice1, status: 1, quantity: 11, unit_price: 4000)
    InvoiceItem.create(item: @item3, invoice: @invoice2, status: 1)
    InvoiceItem.create(item: @item1, invoice: @invoice2)
    InvoiceItem.create(item: @item1, invoice: @invoice3)
    InvoiceItem.create(item: @item1, invoice: @invoice4)
    InvoiceItem.create(item: @item1, invoice: @invoice5)
    InvoiceItem.create(item: @item4, invoice: @invoice6)
    InvoiceItem.create(item: @item5, invoice: @invoice7)
    InvoiceItem.create(item: @item6, invoice: @invoice8)
    create(:transaction, invoice: @invoice1, result: 'success')
    create(:transaction, invoice: @invoice1, result: 'failed')
    create(:transaction, invoice: @invoice1, result: 'failed')
    create(:transaction, invoice: @invoice2, result: 'success')
    create(:transaction, invoice: @invoice2, result: 'success')
    create(:transaction, invoice: @invoice3, result: 'success')
    create(:transaction, invoice: @invoice3, result: 'success')
    create(:transaction, invoice: @invoice4, result: 'success')
    create(:transaction, invoice: @invoice4, result: 'success')
    create(:transaction, invoice: @invoice4, result: 'success')
    create(:transaction, invoice: @invoice5, result: 'success')
    create(:transaction, invoice: @invoice5, result: 'success')
    create(:transaction, invoice: @invoice6, result: 'success')
    create(:transaction, invoice: @invoice6, result: 'success')
    create(:transaction, invoice: @invoice6, result: 'success')
    create(:transaction, invoice: @invoice6, result: 'success')
    visit "/merchants/#{@merch1.id}/invoices/#{@invoice1.id}"
  end

  it 'shows information for specific id' do
    expect(page).to have_content(@invoice1.id)
    expect(page).to have_content(@invoice1.status)
    expect(page).to have_content(@invoice1.created_at_formatted)
    expect(page).to have_content("#{@cust1.first_name} #{@cust1.last_name}")
  end

  it 'Shows all items on the invoice' do
    expect(page).to have_content(@item1.name)
    expect(page).to have_content(@item2.name)
    expect(page).to have_content(@invoice1.item_quantity(@item1.id))
    expect(page).to have_content(@invoice1.item_quantity(@item2.id))
    expect(page).to have_content('$1,000.00')
    expect(page).to have_content('$4,000.00')
    expect(page).to have_content(@invoice1.item_status(@item1.id))
    expect(page).to have_content(@invoice1.item_status(@item2.id))

    expect(page).to_not have_content(@item3.name)
    expect(page).to_not have_content(@item4.name)
    expect(page).to_not have_content(@item5.name)
    expect(page).to_not have_content(@item6.name)
  end

  it 'shows total revenue' do
    expect(page).to have_content('$59,000')
  end

  it 'has a select box for invoice status' do
    within("#table-#{@item1.id}") do
      select 'shipped', from: 'status'
      click_button('Update Item Status')
    end

    expect(current_path).to eq("/merchants/#{@merch1.id}/invoices/#{@invoice1.id}")

    within("#table-#{@item1.id}") do
      expect(page).to have_content('shipped')
    end

    within("#table-#{@item2.id}") do
      select 'pending', from: 'status'
    end

    expect(current_path).to eq("/merchants/#{@merch1.id}/invoices/#{@invoice1.id}")

    within("#table-#{@item2.id}") do
      expect(page).to have_content('pending')
    end
  end
end