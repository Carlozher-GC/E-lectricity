class ChangeCityToCountryInUsersTable < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :city, :country 
  end
end
