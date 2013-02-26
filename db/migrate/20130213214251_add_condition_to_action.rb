class AddConditionToAction < ActiveRecord::Migration
  def change
    add_column :actions, :condition, :string

  end
end
