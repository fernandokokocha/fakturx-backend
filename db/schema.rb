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

ActiveRecord::Schema.define(version: 20171105141942) do

  create_table "invoices", force: :cascade do |t|
    t.string "number"
    t.date "date"
    t.string "month"
    t.date "date_of_payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invoice_document"
    t.string "state"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "measure", default: "szt."
    t.integer "quantity", default: 1
    t.decimal "net_value", precision: 10, scale: 2
    t.integer "tax_value", default: 23
    t.integer "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "gross_amount", precision: 10, scale: 2
    t.index ["invoice_id"], name: "index_items_on_invoice_id"
  end

end
