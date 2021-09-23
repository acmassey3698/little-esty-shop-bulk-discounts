require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:percentage) }
    it { should validate_numericality_of(:threshold) }
  end
end
