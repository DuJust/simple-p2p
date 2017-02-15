require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe '#debit' do
    it { is_expected.to validate_presence_of(:debit) }
  end

  describe '#credit' do
    it { is_expected.to validate_presence_of(:credit) }
  end

  describe '#event' do
    it { is_expected.to validate_presence_of(:event) }
  end

  describe '#amount' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount) }
    it { is_expected.to validate_inclusion_of(:amount).in_range(0..999999999999.99) }
  end
end
