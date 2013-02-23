class AjaxController < ApplicationController
  def load
    User.update_all ["last_visit=?", Time.now], ["id=?", current_user]
    @chat_message = Chat.find(:all, :conditions => ['id > ?', params[:last]])
    @online_users= User.find(:all, :conditions => ['last_visit > ?', Time.now - 15.seconds], :order => 'username')
      
 # game --   
    if current_user.game
      @time_left = current_user.game.time_left
      @status = current_user.game.status
      @turn = current_user.game.turn_user_id
      @user_id = current_user.id
      @winner = current_user.game.winner(current_user.id, current_user.player_colour)
      @dice = current_user.game.dice
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
  # @created_games = Game.joins(:users).group("users.id").having("count(users.id) = 1")  
  # @created_games = Game.joins(:users).where("(select count(users.game_id) from users users2 where users2.game_id = games.id) = 1")

# This (^) select query works good on the local MySQL db, but it doesn't so on heroku`s PostgreSQL. 
# But this one (-->) works good. 
    @created_games = []
    @all_games = Game.find(:all)
    @all_games.each do |game|
      if game.users.length == 1
        @created_games << game
      end
    end 
    
    render :layout => false, :template => 'ajax/load'
  end
end