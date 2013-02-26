class AddDiceTogetherToAction < ActiveRecord::Migration
  def change
    add_column :actions, :dice, :integer

  end
end
