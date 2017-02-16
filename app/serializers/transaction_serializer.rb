class TransactionSerializer < ActiveModel::Serializer
  include Concerns::MoneyFormat

  attributes :id, :debit_id, :credit_id, :amount, :event

  money_format :amount
end
