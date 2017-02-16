require 'rails_helper'

class Foo
  include Concerns::MoneyFormat

  money_format :value

  def initialize
    @scope = OpenStruct.new
  end

  def value=(v)
    @scope.value = v
  end

  def object
    @scope
  end
end

RSpec.describe Concerns::MoneyFormat do
  describe '.money_format' do
    let(:foo) { Foo.new }

    it 'should format specific attributes' do
      foo.value = 1
      expect(foo.value).to eq('1.00')
    end
  end
end
