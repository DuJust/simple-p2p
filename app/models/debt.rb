class Debt
  include ActiveModel::Validations
  alias :read_attribute_for_serialization :send

  attr_accessor :account_a, :account_b

  def initialize(options = {})
    @account_a_id = options[:account_a]
    @account_b_id = options[:account_b]
  end

  validate :account_a_exist
  validate :account_b_exist

  def execute
    if valid?
      amount
      true
    else
      false
    end
  end

  def amount
    @amount ||= begin
      as_debits  = account_a.transactions_as_debit.where(credit: account_b)
      as_credits = account_a.transactions_as_credit.where(debit: account_b)

      sum_up(as_debits.select(&:repay?)) -
        sum_up(as_debits.select(&:loan?)) +
        sum_up(as_credits.select(&:loan?)) -
        sum_up(as_credits.select(&:repay?))
    end
  end

  def self.model_name
    @_model_name ||= ActiveModel::Name.new(self)
  end

  private

  def account_a
    @account_a ||= Account.find(@account_a_id)
  end

  def account_b
    @account_b ||= Account.find(@account_b_id)
  end

  def account_a_exist
    begin
      account_a
    rescue ActiveRecord::RecordNotFound
      errors.add(:account_a, 'Account a must exist.')
      false
    end
  end

  def account_b_exist
    begin
      account_b
    rescue ActiveRecord::RecordNotFound
      errors.add(:account_b, 'Account b must exist.')
      false
    end
  end

  def sum_up(collection)
    collection.map(&:amount).reduce(&:+) || 0
  end
end
