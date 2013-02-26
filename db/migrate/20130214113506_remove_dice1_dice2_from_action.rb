class RemoveDice1Dice2FromAction < ActiveRecord::Migration
  def up
    remove_column :actions, :dice1
        remove_column :actions, :dice2
      end

  def down
    add_column :actions, :dice2, :integer
    add_column :actions, :dice1, :integer
  end
end
