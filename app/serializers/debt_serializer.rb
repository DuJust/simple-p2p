class DebtSerializer < ActiveModel::Serializer
  include Concerns::MoneyFormat

  attributes :amount

  money_format :amount
end
