class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :invoice_number
      t.string :invoice_reference
      t.string :invoice_release_data
      t.datetime :start_billing_date
      t.datetime :end_billing_date
      t.integer :total_billing_days
      t.integer :days_per_year
      t.integer :last_energy_consumption
      t.integer :current_energy_consumption
      t.integer :energy_consumption_delta
      t.integer :contracted_power_price
      t.integer :consumed_energy_price
      t.integer :subtotal_1
      t.integer :electricity_tax
      t.integer :equipment_rental_price
      t.integer :subtotal_2
      t.integer :total_price
      t.integer :access_toll_rate
      t.integer :access_toll_price
      t.integer :marketer_cost_rate
      t.integer :marketer_cost_price
      t.integer :contracted_power_rate
      t.integer :access_toll_energy_rate
      t.integer :access_toll_energy_price
      t.integer :energy_cost_rate
      t.integer :energy_cost_price
      t.integer :energy_rate
      t.integer :energy_price
      t.integer :equipment_price_per_day
      t.integer :electricity_tax_rate
      t.integer :subtotal_tax_equipment
      t.integer :normal_tax_rate
      t.integer :reduced_tax_rate
      t.integer :reduced_tax_price
      t.integer :total_plus_tax

      t.timestamps
    end
  end
end
