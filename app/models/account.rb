class Account < ApplicationRecord
  has_many :transactions_as_debit, foreign_key: 'debit_id', class_name: 'Transaction'
  has_many :transactions_as_credit, foreign_key: 'credit_id', class_name: 'Transaction'
  has_many :debits, through: :transactions_as_debit
  has_many :credits, through: :transactions_as_credit

  validates :balance,
            presence:     true,
            numericality: true,
            inclusion:    { in: 0..999999999999.99 }

  validates :borrow,
            presence:     true,
            numericality: true,
            inclusion:    { in: 0..999999999999.99 }

  validates :lend,
            presence:     true,
            numericality: true,
            inclusion:    { in: 0..999999999999.99 }
end
