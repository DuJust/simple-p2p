require 'rails_helper'

RSpec.describe Repay do
  let(:debit) { create(:account, balance: 0) }
  let(:credit) { create(:account, balance: 100) }
  let(:amount) { '50' }
  let(:transaction_params) { { amount: amount, debit_id: debit.id, credit_id: credit.id } }
  let(:repay) { Repay.new(transaction_params) }

  describe '#execute' do
    before do
      Loan.new(debit_id: debit.id, credit_id: credit.id, amount: 80).execute
    end

    subject { repay.execute }

    context 'when valid' do
      it { is_expected.to eq(true) }

      it { expect { subject }.to change { Transaction.count }.from(1).to(2) }

      it 'should create a repay transaction' do
        subject
        expect(Transaction.last.event).to eq('repay')
      end

      it 'should create a transaction with specific amount' do
        subject
        expect(Transaction.last.amount).to eq(BigDecimal.new(amount))
      end

      describe 'debit' do
        it 'should create a transaction with debit' do
          subject
          expect(Transaction.last.debit_id).to eq(debit.id)
        end

        it 'should increase balance' do
          expect { subject }.to change { Account.find(debit.id).balance }.from(80).to(30)
        end

        it 'should increase borrow' do
          expect { subject }.to change { Account.find(debit.id).borrow }.from(80).to(30)
        end
      end

      describe 'credit' do
        it 'should create a transaction with credit' do
          subject
          expect(Transaction.last.credit_id).to eq(credit.id)
        end

        it 'should decrease balance' do
          expect { subject }.to change { Account.find(credit.id).balance }.from(20).to(70)
        end

        it 'should increase lend' do
          expect { subject }.to change { Account.find(credit.id).lend }.from(80).to(30)
        end
      end
    end

    context 'when invalid' do
      before do
        allow(repay).to receive(:valid?).and_return(false)
      end

      it { is_expected.to eq(false) }
    end

    context 'when transaction error' do
      before do
        allow_any_instance_of(Transaction).to receive(:save!).and_raise(Exception)
      end

      it { is_expected.to eq(false) }
    end
  end

  describe '#amount_str' do
    it { expect(repay).to validate_numericality_of(:amount_str) }
  end

  describe '#debit_account' do
    let(:debit) { double(:account, id: -1) }

    it 'should validate presence' do
      repay.valid?
      expect(repay.errors[:debit]).to eq(['Debit account must exist'])
    end
  end

  describe '#credit_account' do
    let(:credit) { double(:account, id: -1) }

    it 'should validate presence' do
      repay.valid?
      expect(repay.errors[:credit]).to eq(['Credit account must exist'])
    end
  end

  describe '#debit_balance' do
    let(:amount) { (debit.balance + 1).to_s }

    it 'should get balance not enough error' do
      repay.valid?
      expect(repay.errors[:debit]).to eq(['Balance on debit account is not enough.'])
    end
  end

  describe '#debt_between_accounts' do
    before do
      Loan.new(debit_id: debit.id, credit_id: credit.id, amount: 80).execute
      allow_any_instance_of(Debt).to receive(:amount).and_return(BigDecimal.new(amount) - 1)
    end

    context 'when debt is valid' do
      it 'should get debt not enough error' do
        repay.valid?
        expect(repay.errors[:debt]).to eq(['The borrow amount of Debit account is less than repay amount.'])
      end
    end

    context 'when debt is invalid' do
      let(:errors) { double(:errors, full_messages: ['debt error']) }

      before do
        allow_any_instance_of(Debt).to receive(:execute).and_return(false)
        allow_any_instance_of(Debt).to receive(:errors).and_return(errors)
      end

      it 'should get debt not enough error' do
        repay.valid?
        expect(repay.errors[:debt]).to eq(['debt error'])
      end
    end
  end
end

