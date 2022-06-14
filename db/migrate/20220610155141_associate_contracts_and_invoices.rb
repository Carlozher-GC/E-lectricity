class AssociateContractsAndInvoices < ActiveRecord::Migration[6.1]
  def change
    change_table :invoices do |t|
      t.remove_belongs_to :user
      t.belongs_to :contract, index: true, foreign_key: true
    end
  end
end
