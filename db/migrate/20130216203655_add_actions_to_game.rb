class AddActionsToGame < ActiveRecord::Migration
  def change
    add_column :games, :move, :string

    add_column :games, :condition, :string

    add_column :games, :dice, :integer

  end
end
