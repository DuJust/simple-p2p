require 'rails_helper'

RSpec.describe DebtSerializer do
  let(:debt) { Debt.new }
  let(:serializer) { DebtSerializer.new(debt) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  subject { JSON.parse(serialization.to_json) }

  before do
    allow(debt).to receive(:amount).and_return(100)
  end

  it 'should format amount' do
    expect(subject['amount']).to eql('100.00')
  end
end
