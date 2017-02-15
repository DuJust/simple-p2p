class Api::V1::TransactionsController < ApplicationController
  def loan
    @transaction = Transaction.new(transaction_params.merge(event: Transaction.events[:loan]))

    if @transaction.save
      render json: @transaction, status: :created
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  def transaction_params
    params.require(:transaction).permit(:debit_id, :credit_id, :amount)
  end
end
