class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :role
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :email
      t.string :zip_code
      t.string :street
      t.string :phone
      t.boolean :enabled
      t.text :preferences
      t.string :encrypted_password

      t.timestamps
    end
  end
end
