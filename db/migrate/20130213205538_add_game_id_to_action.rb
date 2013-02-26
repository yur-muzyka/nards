class AddGameIdToAction < ActiveRecord::Migration
  def change
    add_column :actions, :game_id, :integer

  end
end
