class AddBuildingSurfaceToContract < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :building_surface, :string
  end
end
