class AccountSerializer < ActiveModel::Serializer
  include ActionView::Helpers::NumberHelper

  attributes :id, :balance, :lend, :borrow

  [:balance, :lend, :borrow].each do |method|
    define_method method do
      number_with_precision(object.send(method), precision: 2)
    end
  end
end
