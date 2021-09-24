class Discount < ApplicationRecord
  belongs_to :merchant
  validates :percentage, presence: true, numericality: { in: 0..100 }
  validates :threshold, presence: true, numericality: { minimum: 0 }
end
