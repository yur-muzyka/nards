class AddActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :active, :datetime

  end
end
