class Api::V1::TransactionsController < ApplicationController
  def loan
    @loan = Loan.new(transaction_params)

    if @loan.execute
      render json: @loan, status: :created
    else
      render json: @loan.errors, status: :unprocessable_entity
    end
  end

  def transaction_params
    params.require(:transaction).permit(:debit_id, :credit_id, :amount)
  end
end