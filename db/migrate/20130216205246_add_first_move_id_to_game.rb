class AddFirstMoveIdToGame < ActiveRecord::Migration
  def change
    add_column :games, :first_move_id, :integer

  end
end
