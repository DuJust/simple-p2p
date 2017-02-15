require 'rails_helper'

RSpec.describe AccountSerializer do
  let(:account) { build(:account, balance: 100) }
  let(:serializer) { AccountSerializer.new(account) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  subject { JSON.parse(serialization.to_json) }

  it 'should format balance' do
    expect(subject['balance']).to eql('100.00')
  end
end

