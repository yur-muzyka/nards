class RemoveNextUserIdFromAction < ActiveRecord::Migration
  def up
    remove_column :actions, :next_user_id
      end

  def down
    add_column :actions, :next_user_id, :integer
  end
end
