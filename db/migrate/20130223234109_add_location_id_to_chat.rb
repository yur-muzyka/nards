class AddLocationIdToChat < ActiveRecord::Migration
  def change
    add_column :chats, :location_id, :integer

  end
end
