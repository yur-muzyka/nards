class RemoveActiveFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :active
      end

  def down
    add_column :users, :active, :datetime
  end
end
