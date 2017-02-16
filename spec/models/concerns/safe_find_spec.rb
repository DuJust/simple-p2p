require 'rails_helper'

class Foo_1
  def self.lock; end
  def self.find(_); end
end
class Foo_2
  def self.find(_); end
end
class Foo
  include Concerns::SafeFind

  safe_find :method_with_lock, Foo_1, :@id_1, with_lock: true
  safe_find :method_without_lock, Foo_2, :@id_2

  def initialize
    @id_1 = 1
    @id_2 = 2
  end
end

RSpec.describe Concerns::SafeFind do
  describe '.safe_find' do
    let(:foo) { Foo.new }
    let(:foo_with_lock) { double(:foo, with_lock: true) }
    let(:foo_without_lock) { double(:foo, with_lock: false) }

    before do
      allow(Foo_1).to receive_message_chain(:lock, :find).and_return(foo_with_lock)
      allow(Foo_2).to receive(:find).and_return(foo_without_lock)
    end

    it 'should define method with lock' do
      expect(foo.method_with_lock).to eq(foo_with_lock)
    end

    it 'should define method without lock' do
      expect(foo.method_without_lock).to eq(foo_without_lock)
    end
  end
end
