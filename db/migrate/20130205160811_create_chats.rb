class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.references :user
      t.string :text
      t.references :location

      t.timestamps
    end
    add_index :chats, :user_id
    add_index :chats, :location_id
  end
end
