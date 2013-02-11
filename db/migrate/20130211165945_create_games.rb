class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :timeout

      t.timestamps
    end
  end
end
