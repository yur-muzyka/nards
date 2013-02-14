class RemoveSituationFromAction < ActiveRecord::Migration
  def up
    remove_column :actions, :situation
      end

  def down
    add_column :actions, :situation, :string
  end
end
