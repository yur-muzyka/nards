class GameController < ApplicationController
  before_filter :from_game_redirect

  def index
   
    if current_user

      current_user.location_id = 4
      current_user.save
      @room1 = Location.find(1)
      @room2 = Location.find(2)
      @room3 = Location.find(3)

      @ajax_options = ['messages', 'online']
      render :layout => 'main', :template => 'game/logged'
    end
  end

  private
  def from_game_redirect
          if !current_user || !current_user.game || 
        current_user.game.status != "in_progress"
      redirect_to :root
    end
  end
end