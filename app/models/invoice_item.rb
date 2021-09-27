class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  # has_many :merchants, through: :item
  # has_many :discounts, through: :merchants

  enum status: {
    pending: 0,
    packaged: 1,
    shipped: 2
  }

  def discounts_applied
    item.merchant
        .discounts
        .where("discounts.threshold <= ?", quantity)
        .order(:percentage)
        .last
  end

  def discounts?
    discounts_applied.present?
  end

  def revenue
    (unit_price * quantity)
  end

  def translated_percentage
    discounts_applied.percentage.fdiv(100)
  end

  def discounted_ii_revenue
    if discounts?
      revenue - (revenue * translated_percentage)
    else
      revenue
    end
  end
end
