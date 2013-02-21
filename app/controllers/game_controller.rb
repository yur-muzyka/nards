class GameController < ApplicationController
  before_filter :from_game_redirect

  def index
    # if current_user.game.get_moves.count > 0
          # @one = current_user.game.dice_left
          # @two = current_user.game.flash_from(current_user.player_colour)
          @three= current_user.game.flash_to(current_user.player_colour)
    # end
      
      # @two = current_user.game.dom_from_points(current_user.game.from_to_points(current_user.player_colour))
    
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
    
  
  private
  def from_game_redirect
          if !current_user || !current_user.game || 
        current_user.game.status != "in_progress"
      redirect_to :root
    end
  end
end