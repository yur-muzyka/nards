class GameController < ApplicationController
  before_filter :from_game_redirect

  def index
    @last_action = current_user.game.actions.find(:last)
    @player_colour = current_user.player_colour
    # @dice = @player_colour
    
    if current_user.game.actions.count == 0
      current_user.game.actions << Action.new(:move => "test!")
      current_user.save
    end

    if current_user.game.actions.find(:last).turn_user_id != current_user.id
      # stub. User wait for an opponent move
    else
      # stub. Action. Move ..
    end
      @dice1 = @last_action.get_condition
      @dice2 = @last_action.from_to_points("w")
      @dice3 = @last_action.flash_from("w")
      
      @ajax_options = ['messages', 'online']
      render :layout => 'main', :template => 'game/logged'
  end

  private
  def from_game_redirect
          if !current_user || !current_user.game || 
        current_user.game.status != "in_progress"
      redirect_to :root
    end
  end
end