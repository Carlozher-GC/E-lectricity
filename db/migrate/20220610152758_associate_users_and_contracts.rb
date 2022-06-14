class AssociateUsersAndContracts < ActiveRecord::Migration[6.1]
  def change
    change_table :contracts do |t|
      t.index :name, unique: true
      t.belongs_to :user, index: true, foreign_key: true
    end

    change_table :invoices do |t|
      t.remove_belongs_to :user
      t.belongs_to :user, index: true, foreign_key: true
    end
  end
end
