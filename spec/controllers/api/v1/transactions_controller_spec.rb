require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  describe '#loan' do
    let(:params) { { transaction: attributes_for(:transaction) } }
    let(:valid) { true }

    before do
      allow_any_instance_of(Loan).to receive(:execute).and_return(valid)
      allow_any_instance_of(Loan).to receive(:transaction)
      allow_any_instance_of(Loan).to receive(:errors)
      post :loan, params: params
    end

    it do
      is_expected.to permit(:debit_id, :credit_id, :amount)
                       .for(:loan, verb: :post, params: { params: params })
                       .on(:transaction)
    end

    context 'create successfully' do
      it { is_expected.to respond_with(:created) }
    end

    context 'create failed' do
      let(:valid) { false }

      it { is_expected.to respond_with(:unprocessable_entity) }
    end
  end

  describe '#repay' do
    let(:params) { { transaction: attributes_for(:transaction) } }
    let(:valid) { true }

    before do
      allow_any_instance_of(Repay).to receive(:execute).and_return(valid)
      allow_any_instance_of(Repay).to receive(:transaction)
      allow_any_instance_of(Repay).to receive(:errors)
      post :repay, params: params
    end

    it do
      is_expected.to permit(:debit_id, :credit_id, :amount)
                       .for(:repay, verb: :post, params: { params: params })
                       .on(:transaction)
    end

    context 'create successfully' do
      it { is_expected.to respond_with(:created) }
    end

    context 'create failed' do
      let(:valid) { false }

      it { is_expected.to respond_with(:unprocessable_entity) }
    end
  end
end
