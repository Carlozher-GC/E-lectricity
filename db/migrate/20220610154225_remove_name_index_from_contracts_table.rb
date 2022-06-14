class RemoveNameIndexFromContractsTable < ActiveRecord::Migration[6.1]
  def change
    change_table :contracts do |t|
      t.remove_index :name
    end
  end
end
