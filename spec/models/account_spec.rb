require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#balance' do
    it { is_expected.to validate_presence_of(:balance) }
    it { is_expected.to validate_numericality_of(:balance) }
    it { is_expected.to validate_inclusion_of(:balance).in_range(0..999999999999.99) }
  end

  describe '#borrow' do
    it { is_expected.to validate_presence_of(:borrow) }
    it { is_expected.to validate_numericality_of(:borrow) }
    it { is_expected.to validate_inclusion_of(:borrow).in_range(0..999999999999.99) }
  end

  describe '#lend' do
    it { is_expected.to validate_presence_of(:lend) }
    it { is_expected.to validate_numericality_of(:lend) }
    it { is_expected.to validate_inclusion_of(:lend).in_range(0..999999999999.99) }
  end
end
