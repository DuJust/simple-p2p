require 'rails_helper'

RSpec.describe TransactionSerializer do
  let(:transaction) { build(:transaction, amount: 100) }
  let(:serializer) { TransactionSerializer.new(transaction) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  subject { JSON.parse(serialization.to_json) }

  it 'should format amount' do
    expect(subject['amount']).to eql('100.00')
  end
end
