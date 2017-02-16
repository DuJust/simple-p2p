class Api::V1::AccountsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :api_not_found

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

  def api_not_found
    head(:not_found)
  end

  def account_params
    params.require(:account).permit(:balance)
  end
end
