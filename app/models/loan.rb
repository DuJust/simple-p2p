class Loan
  def initialize(options = {})
    @transaction_params = options
  end

  def valid?
    transaction.save
  end

  def errors
    valid?
    transaction.errors
  end

  private

  def transaction
    @transaction ||= Transaction.new(transaction_params.merge(event: Transaction.events[:loan]))
  end

  def transaction_params
    @transaction_params
  end
end
