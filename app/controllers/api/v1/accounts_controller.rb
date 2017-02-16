class Api::V1::AccountsController < ApplicationController
  def create
    @account = Account.new(account_params)

    if @account.save
      render json: @account, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def show
    @account = Account.find(params[:id])

    render json: @account
  end

  private

  def account_params
    params.require(:account).permit(:balance)
  end
end
