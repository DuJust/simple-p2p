class Loan
  include ActiveModel::Validations

  attr_accessor :amount_str, :debit, :credit

  def initialize(options = {})
    @debit_id   = options[:debit_id]
    @credit_id  = options[:credit_id]
    @amount_str = options[:amount]
  end

  validates_numericality_of :amount_str
  validate :debit_exist
  validate :credit_balance, if: :credit_exist

  def execute
    if valid?
      create_loan_transaction
      true
    else
      false
    end
  rescue Exception => e
    false
  end

  private

  def create_loan_transaction
    ActiveRecord::Base.transaction do
      debit.balance += amount
      debit.save!

      credit.balance -= amount
      credit.save!

      transaction.save!
    end
  end

  def credit_balance
    errors[:credit] << "Balance on credit account is not enough." unless credit.balance >= amount
  end

  def debit_exist
    begin
      debit
    rescue ActiveRecord::RecordNotFound
      errors.add(:debit, 'Debit account must exist')
      false
    end
  end

  def credit_exist
    begin
      credit
    rescue ActiveRecord::RecordNotFound
      errors.add(:credit, 'Credit account must exist')
      false
    end
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
      event:  Transaction.events[:loan]
    )
  end
end
