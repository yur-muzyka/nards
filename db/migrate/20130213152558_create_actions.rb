class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :next_user_id
      t.string :situation
      t.string :move

      t.timestamps
    end
  end
end
