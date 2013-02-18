class GameController < ApplicationController
  before_filter :from_game_redirect

  def index

      @one = current_user.game.moves_left
      # @two = current_user.game.board_end_check({13 => [1, "b", "f"]}, "w")
    
      @ajax_options = ['messages', 'online', 'game']
      render :layout => 'main'
  end

  def move
    current_user.game.add_move(params[:id])
    
    #change turn
    if current_user.game.dice_left.count == 0 && current_user.game.get_moves.count > 0 
      current_user.game.turn_user_id = current_user.game.opponent_id(current_user.id)
      current_user.game.set_condition(current_user.game.flash_from(current_user.player_colour))
      current_user.game.dice = (rand(6) + 1) *10 + rand(6) + 1
      current_user.game.move = ''
      current_user.game.move_count = current_user.game.move_count + 1 
      current_user.game.save

    end
    
    render :layout => false
  end
  
  private
  def from_game_redirect
          if !current_user || !current_user.game || 
        current_user.game.status != "in_progress"
      redirect_to :root
    end
  end
end