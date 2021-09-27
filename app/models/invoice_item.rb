class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :merchants, through: :item
  has_many :discounts, through: :merchants

  enum status: {
    pending: 0,
    packaged: 1,
    shipped: 2
  }
end
