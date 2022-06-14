class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.string :company_name
      t.string :building_address
      t.string :building_number
      t.string :building_postal_code
      t.string :building_city

      t.timestamps
    end
  end
end
