require 'rails_helper'

RSpec.describe Loan do
  let(:debit) { create(:account, balance: 0) }
  let(:credit) { create(:account, balance: 100) }
  let(:amount) { '50' }
  let(:transaction_params) { { amount: amount, debit_id: debit.id, credit_id: credit.id } }
  let(:loan) { Loan.new(transaction_params) }

  describe '#execute' do
    subject { loan.execute }

    context 'when valid' do
      it { is_expected.to eq(true) }

      it { expect { subject }.to change { Transaction.count }.from(0).to(1) }

      it 'should create a loan transaction' do
        subject
        expect(Transaction.last.event).to eq('loan')
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
          expect { subject }.to change { Account.find(debit.id).balance }.from(0).to(50)
        end

        it 'should increase borrow' do
          expect { subject }.to change { Account.find(debit.id).borrow }.from(0).to(50)
        end
      end

      describe 'credit' do
        it 'should create a transaction with credit' do
          subject
          expect(Transaction.last.credit_id).to eq(credit.id)
        end

        it 'should decrease balance' do
          expect { subject }.to change { Account.find(credit.id).balance }.from(100).to(50)
        end

        it 'should increase lend' do
          expect { subject }.to change { Account.find(credit.id).lend }.from(0).to(50)
        end
      end
    end

    context 'when invalid' do
      before do
        allow(loan).to receive(:valid?).and_return(false)
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
    it { expect(loan).to validate_numericality_of(:amount_str) }
  end

  describe '#debit_account' do
    let(:debit) { double(:account, id: -1) }

    it 'should validate presence' do
      loan.valid?
      expect(loan.errors[:debit]).to eq(["can't be blank"])
    end
  end

  describe '#credit_account' do
    let(:credit) { double(:account, id: -1) }

    it 'should validate presence' do
      loan.valid?
      expect(loan.errors[:credit]).to eq(["can't be blank"])
    end
  end

  describe '#credit_balance' do
    let(:amount) { (credit.balance + 1).to_s }

    it 'should get balance not enough error' do
      loan.valid?
      expect(loan.errors[:credit]).to eq(['Balance on credit account is not enough.'])
    end
  end

  describe '#same_account' do
    let(:credit) { debit }

    it 'should get same account error' do
      loan.valid?
      expect(loan.errors[:base]).to eq(['could not loan to the same account'])
    end
  end
end

