class AddLastVisitToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_visit, :datetime

  end
end
