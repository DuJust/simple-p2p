require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#balance' do
    it { is_expected.to validate_presence_of(:balance) }
    it { is_expected.to validate_numericality_of(:balance) }
    it { is_expected.to validate_inclusion_of(:balance).in_range(0..999999999999.99) }
  end
end
