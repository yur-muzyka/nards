class AddTurnUserIdToGame < ActiveRecord::Migration
  def change
    add_column :games, :turn_user_id, :integer

  end
end
