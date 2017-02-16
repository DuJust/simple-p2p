class Debt
  include ActiveModel::Validations
  include Concerns::SafeFind

  alias :read_attribute_for_serialization :send

  attr_accessor :account_a, :account_b

  def initialize(options = {})
    @account_a_id = options[:account_a]
    @account_b_id = options[:account_b]
  end

  safe_find :account_a, Account, :@account_a_id
  safe_find :account_b, Account, :@account_b_id

  validates_presence_of :account_a
  validates_presence_of :account_b

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

  def sum_up(collection)
    collection.map(&:amount).reduce(&:+) || 0
  end
end
