class AddLocationIdToGame < ActiveRecord::Migration
  def change
    add_column :games, :location_id, :integer

  end
end
