class AddDiceToAction < ActiveRecord::Migration
  def change
    add_column :actions, :turn_user_id, :integer

    add_column :actions, :dice1, :integer

    add_column :actions, :dice2, :integer

  end
end
