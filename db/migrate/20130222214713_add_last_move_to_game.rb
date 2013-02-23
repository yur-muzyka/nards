class AddLastMoveToGame < ActiveRecord::Migration
  def change
    add_column :games, :last_move, :datetime

  end
end
