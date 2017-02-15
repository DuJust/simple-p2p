class AccountSerializer < ActiveModel::Serializer
  include ActionView::Helpers::NumberHelper

  attributes :id, :balance

  def balance
    number_with_precision(object.balance, precision: 2)
  end
end
