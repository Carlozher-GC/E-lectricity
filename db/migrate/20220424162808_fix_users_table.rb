class FixUsersTable < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :city, :string
    add_column :users, :region, :string
    add_column :users, :birthday, :datetime
  end
end
