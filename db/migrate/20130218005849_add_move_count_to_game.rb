class AddMoveCountToGame < ActiveRecord::Migration
  def change
    add_column :games, :move_count, :integer

  end
end
