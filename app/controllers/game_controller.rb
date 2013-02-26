class GameController < ApplicationController
  before_filter :from_game_redirect

  def index
    current_user.location_id = 5
    current_user.save 
    @ajax_options = ['messages', 'online', 'game']
      render :layout => 'main'
  end

  def move
    current_user.game.add_move(params[:id])
    #change turn
    current_user.game.change_turn_check(current_user.player_colour, current_user.id)
    render :layout => false
  end
    
  def out_board
    move = current_user.game.move_ident(current_user.player_colour)
    current_user.game.add_move(move + 90)
    current_user.game.change_turn_check(current_user.player_colour, current_user.id)
    render :layout => false
  end
  
  def leave_game
    current_user.game = nil
    current_user.save
    redirect_to :back
  end
  
  private
  def from_game_redirect
    if !current_user || !current_user.game || current_user.game.status != "in_progress" &&
      current_user.game.status != "game_over"
      redirect_to :root
    end
  end
end