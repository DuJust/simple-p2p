class AddBorrowAndLendToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :borrow, :decimal, precision: 14, scale: 2, default: 0.0, null: false
    add_column :accounts, :lend, :decimal, precision: 14, scale: 2, default: 0.0, null: false
  end
end
