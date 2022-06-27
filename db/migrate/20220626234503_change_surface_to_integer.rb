class ChangeSurfaceToInteger < ActiveRecord::Migration[6.1]
  def change
    change_column :contracts, :building_surface, :integer
  end
end
