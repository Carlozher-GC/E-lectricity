class AssociateUsersAndInvoicesTable < ActiveRecord::Migration[6.1]
  def change
    change_table :invoices do |t|
      t.belongs_to :user, index: true, foreign_key: true
    end
  end
end
