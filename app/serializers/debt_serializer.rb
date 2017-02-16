class DebtSerializer < ActiveModel::Serializer
  include ActionView::Helpers::NumberHelper

  attributes :amount

  [:amount].each do |method|
    define_method method do
      number_with_precision(object.send(method), precision: 2)
    end
  end
end
