require 'rails_helper'

RSpec.describe Loan do
  let(:debit) { create(:account) }
  let(:credit) { create(:account) }
  let(:transaction_params) { attributes_for(:transaction, debit_id: debit.id, credit_id: credit.id) }
  let(:loan) { Loan.new(transaction_params) }

  describe '#valid?' do
    subject { loan.valid? }

    it { expect { subject }.to change { Transaction.count }.from(0).to(1) }
    it 'should set new transaction event as loan' do
      subject
      expect(Transaction.last.event).to eq('loan')
    end

    it { is_expected.to eq(true) }
  end

  describe '#errors' do
    before do
      allow_any_instance_of(Transaction).to receive(:save).and_return(true)
      allow_any_instance_of(Transaction).to receive(:errors).and_return([])
    end

    subject { loan.errors }

    it { is_expected.to eq([]) }
  end
end

