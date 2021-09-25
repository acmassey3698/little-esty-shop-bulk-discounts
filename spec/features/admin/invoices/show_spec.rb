require 'rails_helper'

describe 'admin invoices show page' do
  before(:each) do
    @merch1 = create(:merchant)
    @cust1 = create(:customer)
    @item1 = create(:item, merchant: @merch1, unit_price: 3000)
    @item2 = create(:item, merchant: @merch1, unit_price: 6000)
    @item3 = create(:item, merchant: @merch1, unit_price: 4500)
    @invoice1 = create(:invoice, customer: @cust1, status: 0)
    @ii1 = InvoiceItem.create(item: @item1, invoice: @invoice1, unit_price: @item1.unit_price, quantity: 15, status: 0)
    @ii2 = InvoiceItem.create(item: @item2, invoice: @invoice1, unit_price: @item2.unit_price, quantity: 5, status: 1)
    @ii3 = InvoiceItem.create(item: @item3, invoice: @invoice1, unit_price: @item3.unit_price, quantity: 6, status: 2)

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
      expect(page).to have_content("$30.00")
    end

    within("#table-#{@ii2.id}") do
      expect(page).to have_content(@item2.name)
      expect(page).to have_content(@ii2.quantity)
      expect(page).to have_content(@ii2.status)
      expect(page).to have_content("$60.00")
    end

    within("#table-#{@ii3.id}") do
      expect(page).to have_content(@item3.name)
      expect(page).to have_content(@ii3.quantity)
      expect(page).to have_content(@ii3.status)
      expect(page).to have_content("$45.00")
    end
  end

  it 'shows total revenue' do
    expect(page).to have_content("$1,020.00")
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
      ##TESTING ONCE THE DISCOUNTED REVENUE METHOD IS BUILT. JUST BUILDING FRAMEWORK
  end
end
