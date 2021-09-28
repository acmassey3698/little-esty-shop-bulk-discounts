require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
    # it { should have_many(:merchants).through(:item) }
    # it { should have_many(:discounts).through(:merchants) }
  end

  before :each do
    @merch1 = create(:merchant)
    @merch2 = create(:merchant)
    @disc1 = @merch1.discounts.create!(threshold: 15, percentage: 10)
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
  end

  describe 'instance methods' do
    it 'finds applicable discounts' do
      expect(@ii1.discounts_applied).to eq(@disc1)
      expect(@ii2.discounts_applied).to eq(nil)
    end

    it 'returns a boolean for discounts?' do
      expect(@ii1.discounts?).to eq(true)
      expect(@ii2.discounts?).to eq(false)
    end

    it 'calculates revenue without the discount' do
      expect(@ii1.revenue).to eq(15000)
      expect(@ii2.revenue).to eq(44000)
    end

    it 'translates the percentage to to a decimal' do
      expect(@ii1.translated_percentage).to eq(0.1)
    end

    it 'calculates the discounted revenue for the invoice item' do
      expect(@ii1.discounted_ii_revenue).to eq(13500.0)
      expect(@ii2.discounted_ii_revenue).to eq(44000)
    end

    describe 'edge case testing for #discounted_ii_revenue' do
      it 'only discounts the items that meet the threshold' do
        merch1 = create(:merchant)
        disc1 = merch1.discounts.create!(threshold: 15, percentage: 10)

        cust1 = create(:customer)
        invoice1 = create(:invoice, customer: cust1)

        item1 = create(:item, merchant: merch1)
        item2 = create(:item, merchant: merch1)

        ii1 = InvoiceItem.create(item: item1, invoice: invoice1, status: 1, quantity: 15, unit_price: 1000)
        ii2 = InvoiceItem.create(item: item2, invoice: invoice1, status: 1, quantity: 5, unit_price: 100)
        create(:transaction, invoice: @invoice1, result: 'success')

        expect(ii1.discounted_ii_revenue).to eq(13500)
        expect(ii2.discounted_ii_revenue).to eq(ii2.revenue)
      end

      it 'applies two different discounts when two IIs meet the thresholds' do
        merch1 = create(:merchant)
        disc1 = merch1.discounts.create!(threshold: 15, percentage: 10)
        disc2 = merch1.discounts.create!(threshold: 10, percentage: 5)

        cust1 = create(:customer)
        invoice1 = create(:invoice, customer: cust1)

        item1 = create(:item, merchant: merch1)
        item2 = create(:item, merchant: merch1)

        ii1 = InvoiceItem.create(item: item1, invoice: invoice1, status: 1, quantity: 15, unit_price: 1000)
        ii2 = InvoiceItem.create(item: item2, invoice: invoice1, status: 1, quantity: 10, unit_price: 100)
        create(:transaction, invoice: @invoice1, result: 'success')

        expect(ii1.discounted_ii_revenue).to eq(13500)
        expect(ii1.discounts_applied).to eq(disc1)

        expect(ii2.discounted_ii_revenue).to eq(950)
        expect(ii2.discounts_applied).to eq(disc2)
      end

      it 'only applies the discount with the highest percentage' do
        merch1 = create(:merchant)
        disc1 = merch1.discounts.create!(threshold: 15, percentage: 10)
        disc2 = merch1.discounts.create!(threshold: 10, percentage: 5)

        cust1 = create(:customer)
        invoice1 = create(:invoice, customer: cust1)

        item1 = create(:item, merchant: merch1)
        item2 = create(:item, merchant: merch1)

        ii1 = InvoiceItem.create(item: item1, invoice: invoice1, status: 1, quantity: 15, unit_price: 1000)
        ii2 = InvoiceItem.create(item: item2, invoice: invoice1, status: 1, quantity: 20, unit_price: 100)
        create(:transaction, invoice: @invoice1, result: 'success')

        expect(ii1.discounted_ii_revenue).to eq(13500)
        expect(ii1.discounts_applied).to eq(disc1)

        expect(ii2.discounted_ii_revenue).to eq(1800)
        expect(ii2.discounts_applied).to eq(disc1)
      end

      it 'uses a merchants discounts on only their items' do
        merch1 = create(:merchant)
        merch2 = create(:merchant)
        disc1 = merch1.discounts.create!(threshold: 15, percentage: 10)
        disc2 = merch1.discounts.create!(threshold: 10, percentage: 5)

        cust1 = create(:customer)
        invoice1 = create(:invoice, customer: cust1)

        item1 = create(:item, merchant: merch1)
        item2 = create(:item, merchant: merch1)
        item3 = create(:item, merchant: merch2)

        ii1 = InvoiceItem.create(item: item1, invoice: invoice1, status: 1, quantity: 15, unit_price: 1000)
        ii2 = InvoiceItem.create(item: item2, invoice: invoice1, status: 1, quantity: 12, unit_price: 100)
        ii3 = InvoiceItem.create(item: item3, invoice: invoice1, status: 1, quantity: 15, unit_price: 100)
        create(:transaction, invoice: @invoice1, result: 'success')

        expect(ii1.discounted_ii_revenue).to eq(13500)
        expect(ii1.discounts_applied).to eq(disc1)

        expect(ii2.discounted_ii_revenue).to eq(1140)
        expect(ii2.discounts_applied).to eq(disc2)

        expect(ii3.discounted_ii_revenue).to eq(ii3.revenue)
        expect(ii3.discounts_applied).to eq(nil)
      end
    end
  end
end
