class Account < ApplicationRecord
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
