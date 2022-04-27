class FixInvoicesTable < ActiveRecord::Migration[6.1]
  def change
    rename_column :invoices, :invoice_release_data, :invoice_release_date
    change_column :invoices, :invoice_release_date, :datetime
    change_column :invoices, :access_toll_rate, :decimal
    change_column :invoices, :marketer_cost_rate, :decimal
    change_column :invoices, :access_toll_energy_price, :decimal
    change_column :invoices, :energy_cost_price, :decimal
    change_column :invoices, :energy_price, :decimal
    change_column :invoices, :electricity_tax_rate, :decimal
    change_column :invoices, :contracted_power_price, :decimal
    change_column :invoices, :subtotal_1, :decimal
    change_column :invoices, :equipment_rental_price, :decimal
    change_column :invoices, :total_price, :decimal
    change_column :invoices, :access_toll_price, :decimal
    change_column :invoices, :marketer_cost_price, :decimal
    change_column :invoices, :access_toll_energy_rate, :decimal
    change_column :invoices, :energy_cost_rate, :decimal
    change_column :invoices, :energy_rate, :decimal
    change_column :invoices, :equipment_price_per_day, :decimal
    change_column :invoices, :subtotal_tax_equipment, :decimal
    change_column :invoices, :reduced_tax_price, :decimal
    change_column :invoices, :total_plus_tax, :decimal
    change_column :invoices, :consumed_energy_price, :decimal
    change_column :invoices, :electricity_tax, :decimal
    change_column :invoices, :subtotal_2, :decimal
  end
end
