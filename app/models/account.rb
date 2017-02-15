class Account < ApplicationRecord
  validates :balance,
            presence:     true,
            numericality: true,
            inclusion:    { in: 0..999999999999.99 }
end
