class Game < ActiveRecord::Base
  has_many :users, :foreign_key => "game_id"
  has_many :actions, :foreign_key => "game_id"
end
