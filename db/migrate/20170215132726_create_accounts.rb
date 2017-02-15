class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.decimal :balance, precision: 14, scale: 2, default: 0.0, null: false

      t.timestamps
    end
  end
end
