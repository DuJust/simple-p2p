require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :controller do
  describe '#create' do
    let(:params) do
      {
        account: {
          balance: '100'
        }
      }
    end

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
end
