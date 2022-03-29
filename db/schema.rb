# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_12_224031) do

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_number"
    t.string "invoice_reference"
    t.string "invoice_release_data"
    t.datetime "start_billing_date"
    t.datetime "end_billing_date"
    t.integer "total_billing_days"
    t.integer "days_per_year"
    t.integer "last_energy_consumption"
    t.integer "current_energy_consumption"
    t.integer "energy_consumption_delta"
    t.integer "contracted_power_price"
    t.integer "consumed_energy_price"
    t.integer "subtotal_1"
    t.integer "electricity_tax"
    t.integer "equipment_rental_price"
    t.integer "subtotal_2"
    t.integer "total_price"
    t.integer "access_toll_rate"
    t.integer "access_toll_price"
    t.integer "marketer_cost_rate"
    t.integer "marketer_cost_price"
    t.integer "contracted_power_rate"
    t.integer "access_toll_energy_rate"
    t.integer "access_toll_energy_price"
    t.integer "energy_cost_rate"
    t.integer "energy_cost_price"
    t.integer "energy_rate"
    t.integer "energy_price"
    t.integer "equipment_price_per_day"
    t.integer "electricity_tax_rate"
    t.integer "subtotal_tax_equipment"
    t.integer "normal_tax_rate"
    t.integer "reduced_tax_rate"
    t.integer "reduced_tax_price"
    t.integer "total_plus_tax"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "role"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "email"
    t.string "zip_code"
    t.string "street"
    t.string "phone"
    t.boolean "enabled"
    t.text "preferences"
    t.string "encrypted_password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
