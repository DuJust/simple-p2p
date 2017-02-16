class Transaction < ApplicationRecord
  enum event: [:loan, :repay]

  belongs_to :debit, class_name: 'Account', foreign_key: 'debit_id'
  belongs_to :credit, class_name: 'Account', foreign_key: 'credit_id'

  validates :debit, presence: true
  validates :credit, presence: true
  validates :event, presence: true

  validates :amount,
            presence:     true,
            numericality: true,
            inclusion:    { in: 0..999999999999.99 }
end
