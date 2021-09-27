require 'rails_helper'

describe 'admin invoices show page' do

  before(:each) do
    @merch1 = create(:merchant)
    @merch2 = create(:merchant)
    @merch1.discounts.create!(threshold: 10, percentage: 10)
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
    @ii1 = InvoiceItem.create(item: @item1, invoice: @invoice1, status: 1, quantity: 15, unit_price: 1000)
    @ii2 = InvoiceItem.create(item: @item2, invoice: @invoice1, status: 1, quantity: 11, unit_price: 4000)
    @ii3 = InvoiceItem.create(item: @item3, invoice: @invoice1, status: 1, quantity: 2, unit_price: 4000)
    InvoiceItem.create(item: @item1, invoice: @invoice2, quantity: 2, unit_price: 4000)
    InvoiceItem.create(item: @item1, invoice: @invoice3, quantity: 2, unit_price: 4000)
    InvoiceItem.create(item: @item1, invoice: @invoice4, quantity: 2, unit_price: 4000)
    InvoiceItem.create(item: @item1, invoice: @invoice5, quantity: 2, unit_price: 4000)
    InvoiceItem.create(item: @item4, invoice: @invoice6, quantity: 2, unit_price: 4000)
    InvoiceItem.create(item: @item5, invoice: @invoice7, quantity: 2, unit_price: 4000)
    InvoiceItem.create(item: @item6, invoice: @invoice8, quantity: 2, unit_price: 4000)
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

    visit admin_invoice_path(@invoice1)
  end

  it 'displays information related to invoice' do

    expect(page).to have_content(@invoice1.id)
    expect(page).to have_content(@invoice1.status)
    expect(page).to have_content(@invoice1.created_at.strftime("%A, %B %d, %Y"))
    expect(page).to have_content(@cust1.first_name)
    expect(page).to have_content(@cust1.last_name)
  end

  it 'displays all items on invoice' do
    within("#table-#{@ii1.id}") do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@ii1.quantity)
      expect(page).to have_content(@ii1.status)
      expect(page).to have_content("$10.00")
    end

    within("#table-#{@ii2.id}") do
      expect(page).to have_content(@item2.name)
      expect(page).to have_content(@ii2.quantity)
      expect(page).to have_content(@ii2.status)
      expect(page).to have_content("$40.00")
    end

    within("#table-#{@ii3.id}") do
      expect(page).to have_content(@item3.name)
      expect(page).to have_content(@ii3.quantity)
      expect(page).to have_content(@ii3.status)
      expect(page).to have_content("$40.00")
    end
  end

  it 'shows total revenue' do
    expect(page).to have_content("$670.00")
  end

  it 'has a select option for invoice status' do
    within("#invoice-#{@invoice1.id}-status") do
      select 'completed', from: :invoice_status
      click_button('Update Invoice Status')
    end

    @invoice1.reload

    expect(current_path).to eq(admin_invoice_path(@invoice1))

    within("#invoice-#{@invoice1.id}-status") do
      expect(find(:css, 'select#invoice_status').value ).to eq('completed')
    end

    within("#invoice-#{@invoice1.id}-status") do
      select 'cancelled', from: :invoice_status
      click_button('Update Invoice Status')
    end

    within("#invoice-#{@invoice1.id}-status") do
      expect(find(:css, 'select#invoice_status').value ).to eq('cancelled')
    end
  end

  it 'shows the total discounted revenue for the invoice' do
      expect(page).to have_content("Revenue After Discounts:")
      expect(page).to have_content("$611.00")
  end
end
