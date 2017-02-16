class Repay
  include ActiveModel::Validations

  attr_accessor :amount_str, :debit, :credit

  def initialize(options = {})
    @debit_id   = options[:debit_id]
    @credit_id  = options[:credit_id]
    @amount_str = options[:amount]
  end

  validates_numericality_of :amount_str
  validate :credit_exist
  validate :debit_balance, if: :debit_exist
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
    debit_exist && credit_exist
  end

  def debit_exist
    @debit_exist = begin
      debit
      true
    rescue ActiveRecord::RecordNotFound
      errors.add(:debit, 'Debit account must exist')
      false
    end unless instance_variable_defined?(:@debit_exist)
    @debit_exist
  end

  def credit_exist
    @credit_exist = begin
      credit
      true
    rescue ActiveRecord::RecordNotFound
      errors.add(:credit, 'Credit account must exist')
      false
    end unless instance_variable_defined?(:@credit_exist)
    @credit_exist
  end

  def debit
    @debit ||= Account.lock.find(@debit_id)
  end

  def credit
    @credit ||= Account.lock.find(@credit_id)
  end

  def amount
    @amount ||= BigDecimal.new(@amount_str)
  end

  def transaction
    @transaction ||= Transaction.new(
      debit:  debit,
      credit: credit,
      amount: @amount,
      event:  Transaction.events[:repay]
    )
  end
end
