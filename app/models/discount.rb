class Discount < ApplicationRecord
  belongs_to :merchant
  validates :percentage, presence: true, numericality: true
  validates :threshold, presence: true, numericality: true
end
