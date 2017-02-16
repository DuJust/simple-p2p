require 'rails_helper'

class Foo
  include ActiveModel::Validations
  include Concerns::ErrorCollector

  attr_accessor :bar_1, :bar_2
end

RSpec.describe Concerns::ErrorCollector do
  describe '.collect_error' do
    let(:foo) { Foo.new }
    let(:bar_1) { double(:bar, valid?: false, errors: bar_1_errors) }
    let(:bar_2) { double(:bar, valid?: true, errors: bar_2_errors) }
    let(:bar_1_errors) { double(:errors, full_messages: ["bar 1 error message"]) }
    let(:bar_2_errors) { double(:errors, full_messages: ["bar 2 error message"]) }

    before do
      foo.bar_1 = bar_1
      foo.bar_2 = bar_2
    end

    it 'should collect all errors' do
      foo.collect_error(:bar_1)
      expect(foo.errors[:bar_1]).to eq(["bar 1 error message"])
    end

    it 'should skip valid objects' do
      foo.collect_error(:bar_2)
      expect(foo.errors[:bar_2]).to eq([])
    end
  end
end
