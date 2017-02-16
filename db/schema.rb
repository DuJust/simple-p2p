# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170216075437) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal  "balance",    precision: 14, scale: 2, default: "0.0", null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.decimal  "borrow",     precision: 14, scale: 2, default: "0.0", null: false
    t.decimal  "lend",       precision: 14, scale: 2, default: "0.0", null: false
  end

  create_table "transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "debit_id",                                            null: false
    t.integer  "credit_id",                                           null: false
    t.decimal  "amount",     precision: 14, scale: 2, default: "0.0", null: false
    t.integer  "event",                               default: 0,     null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.index ["credit_id"], name: "index_transactions_on_credit_id", using: :btree
    t.index ["debit_id"], name: "index_transactions_on_debit_id", using: :btree
  end

end
