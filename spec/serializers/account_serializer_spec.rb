require 'rails_helper'

RSpec.describe AccountSerializer do
  let(:account) { build(:account, balance: 100, borrow: 99.99, lend: 101.00) }
  let(:serializer) { AccountSerializer.new(account) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  subject { JSON.parse(serialization.to_json) }

  it 'should format balance' do
    expect(subject['balance']).to eql('100.00')
  end

  it 'should format borrow' do
    expect(subject['borrow']).to eql('99.99')
  end

  it 'should format lend' do
    expect(subject['lend']).to eql('101.00')
  end
end
