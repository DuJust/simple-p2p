class Repay
  include ActiveModel::Validations
  include Concerns::SafeFind

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
  validate :debit_balance, if: :debit
  validate :debt_between_accounts, if: :debit_and_credit_exist

  def execute
    if valid?
      create_repay_transaction
      true
    else
      false
    end
  rescue Exception => e
    false
  end

  def transaction
    @transaction ||= Transaction.new(
      debit:  debit,
      credit: credit,
      amount: @amount,
      event:  Transaction.events[:repay]
    )
  end

  private

  def create_repay_transaction
    ActiveRecord::Base.transaction do
      debit.balance -= amount
      debit.borrow  -= amount
      debit.save!

      credit.balance += amount
      credit.lend    -= amount
      credit.save!

      transaction.save!
    end
  end

  def debt_between_accounts
    debt           = Debt.new
    debt.account_a = credit
    debt.account_b = debit
    if debt.execute
      errors[:debt] << "The borrow amount of Debit account is less than repay amount." if debt.amount < amount
    else
      debt.errors.full_messages.each { |msg| errors[:debt] << msg }
    end
  end

  def debit_balance
    errors[:debit] << "Balance on debit account is not enough." unless debit.balance >= amount
  end

  def debit_and_credit_exist
    debit && credit
  end

  def amount
    @amount ||= BigDecimal.new(@amount_str)
  end
end
