require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :controller do
  describe '#create' do
    let(:params) { { account: attributes_for(:account) } }

    before do
      post :create, params: params
    end

    it do
      is_expected.to permit(:balance)
                       .for(:create, params: { params: params })
                       .on(:account)
    end

    context 'create successfully' do
      it { is_expected.to respond_with(:created) }
    end

    context 'create failed' do
      before do
        allow_any_instance_of(Account).to receive(:save).and_return(false)
        post :create, params: params
      end

      it { is_expected.to respond_with(:unprocessable_entity) }
    end
  end

  describe '#show' do
    let(:account) { create(:account) }
    before do
      get :show, params: { id: account.id }
    end

    context 'when account exist' do
      it { is_expected.to respond_with(:ok) }
    end

    context 'when account not exist' do
      let(:account) { double(:account, id: -1) }

      it { is_expected.to respond_with(:not_found) }
    end
  end

  describe '#debt' do
    let(:account_a) { double(:account, id: 1) }
    let(:account_b) { double(:account, id: 2) }

    before do
      allow_any_instance_of(Debt).to receive(:execute).and_return(valid)
      allow_any_instance_of(Debt).to receive(:amount).and_return(100)
      get :debt, params: { account_a: account_a.id, account_b: account_b.id }
    end

    context 'when debt is valid' do
      let(:valid) { true }

      it { is_expected.to respond_with(:ok) }
    end

    context 'when debt is invalid' do
      let(:valid) { false }

      it { is_expected.to respond_with(:unprocessable_entity) }
    end
  end
end
