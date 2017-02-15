class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :debit, null: false
      t.belongs_to :credit, null: false
      t.decimal :amount, precision: 14, scale: 2, default: 0.0, null: false
      t.integer :event, default: 0, null: false

      t.timestamps
    end
  end
end
