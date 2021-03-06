class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :location
  belongs_to :game
  
  def player_colour
    if id == game.first_move_id
      return "w"  # white
    else 
      "b"  # black
    end
  end
end
