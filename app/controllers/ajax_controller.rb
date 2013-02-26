class AjaxController < ApplicationController
  def load
    User.update_all ["last_visit=?", Time.now], ["id=?", current_user]
    
    # chat --
    if params[:last] == "0" || params[:location] != current_user.location_id.to_s
      @last_id = Chat.find(:last).id
      @location_id = current_user.location_id
    else
      @last_id = params[:last]
      @location_id = params[:location]
    end
    if current_user.game && (current_user.game.status == "in_progress" || current_user.game.status == "game_over")
      @chat_message = Chat.find(:all, :conditions => ['id > ? AND location_id = ? AND (user_id  = ? OR user_id = ?)', @last_id, 
        current_user.location_id, current_user.game.users.first, current_user.game.users.last], :order => "id")  
    else
      @chat_message = Chat.find(:all, :conditions => ['id > ? AND location_id = ?', @last_id, current_user.location_id])
    end
    
    
    @online_users = User.find(:all, :conditions => ['last_visit > ? AND location_id = ?', Time.now - 15.seconds, 
        current_user.location_id], :order => 'username')
      
 # game --   
    if current_user.game
      @time_left = current_user.game.time_left
      @status = current_user.game.status
      @turn = current_user.game.turn_user_id
      @user_id = current_user.id
      @winner = current_user.game.winner(current_user.id, current_user.player_colour)
      @dice = current_user.game.dice
      @colour = current_user.player_colour
      if current_user.game.status == "game_over" || current_user.game.turn_user_id != current_user.id
        @condition = current_user.game.get_condition
      else
        if current_user.game.move_pending
          @condition = current_user.game.flash_to(current_user.player_colour)[0]
          @out_board_moves = current_user.game.flash_to(current_user.player_colour)[1]
        else
          @condition = current_user.game.flash_from(current_user.player_colour)
        end
        if current_user.game.no_moves(current_user.player_colour)
          current_user.game.change_turn(current_user.player_colour, current_user.id)
        end
        if current_user.game.time_left <= 0 || @condition[25][0] >= 15 || @condition[26][0] >= 15
          current_user.game.make_rating
          current_user.game.game_over
        end
      end
    end  
    
 # end game --
 
 
  # @created_games = Game.joins(:users).group(:game_id).having("COUNT(*) = 1")

# This (^) select query works good on the local MySQL db, but it doesn't so on heroku`s PostgreSQL. 
# But this one (-->) works good. 
    @created_games = []
    @all_games = Game.find(:all, :conditions => ['location_id = ?', current_user.location_id])
    @all_games.each do |game|
      if game.users.length == 1 && game.status != 'game_over'
        @created_games << game
      end
    end 
    
    
    render :layout => false, :template => 'ajax/load'
  end
end