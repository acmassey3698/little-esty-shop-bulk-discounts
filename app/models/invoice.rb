class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  enum status: {
    'in progress': 0,
    cancelled: 1,
    completed: 2,
  }

  def created_at_formatted
    created_at.strftime("%A, %B %d, %Y")
  end

  def created_at_short_format
    created_at.strftime("%x")
  end

  def customer_by_id
    Customer.find(customer_id)
  end

  def item_unit_price(item_id)
    invoice_items.where(item_id: item_id).first.unit_price
  end

  def item_status(item_id)
    invoice_items.where(item_id: item_id).first.status
  end

  def total_revenue
    invoice_items.where(invoice_id: id).sum('quantity * unit_price')
  end

  def merchants_revenue(merchant)
    merchants_invoice_items(merchant).sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def merchants_invoice_items(merchant)
    invoice_items.joins(item: :merchant)
                 .where('items.merchant_id = ?', merchant.id)
  end

  def merchants_discounted_revenue(merchant)
    merchants_iis = merchants_invoice_items(merchant)
    merchants_iis.sum { |ii| ii.discounted_ii_revenue }
  end

  def discounted_revenue
    invoice_items.sum { |ii| ii.discounted_ii_revenue }
  end

  def invoice_discounts
    discounts = []
    invoice_items.each do |ii|
      if !ii.discounts_applied.nil?
        discounts << ii.discounts_applied
      end
    end
    discounts.uniq
  end
end
