require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'instance methods' do
    before(:each) do
      @merch1 = create(:merchant)
      @merch1.discounts.create!(threshold: 15, percentage: 10)
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
      @invoice1 = create(:invoice, customer: @cust1)
      @invoice2 = create(:invoice, customer: @cust2)
      @invoice3 = create(:invoice, customer: @cust3)
      @invoice4 = create(:invoice, customer: @cust4)
      @invoice5 = create(:invoice, customer: @cust5)
      @invoice6 = create(:invoice, customer: @cust6)
      @invoice7 = create(:invoice, customer: @cust7)
      @invoice8 = create(:invoice, customer: @cust7)
      InvoiceItem.create(item: @item1, invoice: @invoice1, status: 1, quantity: 15, unit_price: 1000)
      InvoiceItem.create(item: @item2, invoice: @invoice1, status: 1, quantity: 5, unit_price: 100)
      InvoiceItem.create(item: @item3, invoice: @invoice1, status: 1, quantity: 5, unit_price: 100)
      InvoiceItem.create(item: @item1, invoice: @invoice1, quantity: 5, unit_price: 100)
      InvoiceItem.create(item: @item1, invoice: @invoice3, quantity: 5, unit_price: 100)
      InvoiceItem.create(item: @item1, invoice: @invoice4, quantity: 5, unit_price: 100)
      InvoiceItem.create(item: @item1, invoice: @invoice5, quantity: 5, unit_price: 100)
      InvoiceItem.create(item: @item1, invoice: @invoice6, quantity: 5, unit_price: 100)
      InvoiceItem.create(item: @item2, invoice: @invoice7, quantity: 5, unit_price: 100)
      InvoiceItem.create(item: @item2, invoice: @invoice8, quantity: 5, unit_price: 100)
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
    end

    it '#created_at_formatted' do
      expect(@invoice1.created_at_formatted).to eq(@invoice1.created_at.strftime("%A, %B %d, %Y"))
    end

    it '#created_at_short_format' do
      expect(@invoice1.created_at_short_format).to eq(@invoice1.created_at.strftime("%x"))
    end

    it '#customer_by_id' do
      expect(@invoice1.customer_by_id).to eq(@cust1)
    end

    it '#item_unit_price' do
      expect(@invoice1.item_unit_price(@item1.id)).to eq(1000)
    end

    it '#item_status' do
      expect(@invoice1.item_status(@item1.id)).to eq('packaged')
    end

    it '#total_revenue' do
      expect(@invoice1.total_revenue).to eq(16500)
    end

    it '#discounted_revenue' do
      expect(@invoice1.discounted_revenue).to eq(15000)
    end
  end
end
