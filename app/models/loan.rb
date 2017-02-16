class Loan
  include ActiveModel::Validations
  include Concerns::SafeFind
  include Concerns::ErrorCollector

  attr_accessor :amount_str, :debit, :credit

  def initialize(options = {})
    @debit_id   = options[:debit_id]
    @credit_id  = options[:credit_id]
    @amount_str = options[:amount]
  end

  safe_find :debit, Account, :@debit_id, with_lock: true
  safe_find :credit, Account, :@credit_id, with_lock: true

  validates_numericality_of :amount_str
  validates_presence_of :debit
  validates_presence_of :credit
  validate :credit_balance, if: :credit

  def execute
    if valid?
      create_loan_transaction
      true
    else
      false
    end
  rescue Exception
    collect_error(:debit, :credit, :transaction)

    false
  end

  def transaction
    @transaction ||= Transaction.new(
      debit:  debit,
      credit: credit,
      amount: @amount,
      event:  Transaction.events[:loan]
    )
  end

  private

  def create_loan_transaction
    ActiveRecord::Base.transaction do
      debit.balance += amount
      debit.borrow  += amount
      debit.save!

      credit.balance -= amount
      credit.lend    += amount
      credit.save!

      transaction.save!
    end
  end

  def credit_balance
    errors[:credit] << "Balance on credit account is not enough." unless credit.balance >= amount
  end

  def amount
    @amount ||= BigDecimal.new(@amount_str)
  end
end
