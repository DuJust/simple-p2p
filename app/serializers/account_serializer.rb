class AccountSerializer < ActiveModel::Serializer
  include Concerns::MoneyFormat

  attributes :id, :balance, :lend, :borrow

  money_format :balance, :lend, :borrow
end
