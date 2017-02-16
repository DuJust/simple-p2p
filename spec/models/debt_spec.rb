require 'rails_helper'

RSpec.describe Debt do
  let(:account_a) { create(:account, balance: 100) }
  let(:account_b) { create(:account, balance: 100) }
  let(:debt) { Debt.new(account_a: account_a.id, account_b: account_b.id) }

  describe '#execute' do
    subject { debt.execute }

    context 'when valid' do
      it { is_expected.to eq(true) }
    end

    context 'when invalid' do
      before do
        allow(debt).to receive(:valid?).and_return(false)
      end

      it { is_expected.to eq(false) }
    end
  end

  describe '#amount' do
    context 'when account a borrow money from account b' do
      before do
        create(:transaction, debit: account_a, credit: account_b, amount: 20)
      end

      it { expect(debt.amount).to eq(-20) }
    end

    context 'when account a lend money to account b' do
      before do
        create(:transaction, debit: account_b, credit: account_a, amount: 20)
      end

      it { expect(debt.amount).to eq(20) }
    end
  end

  describe '#account_a' do
    let(:account_a) { double(:account, id: -1) }

    it 'should validate presence' do
      debt.valid?
      expect(debt.errors[:account_a]).to eq(['Account a must exist.'])
    end
  end

  describe '#account_b' do
    let(:account_b) { double(:account, id: -1) }

    it 'should validate presence' do
      debt.valid?
      expect(debt.errors[:account_b]).to eq(['Account b must exist.'])
    end
  end

  describe '.model_name' do
    it { expect(Debt.model_name).to eq('Debt')}
  end
end

