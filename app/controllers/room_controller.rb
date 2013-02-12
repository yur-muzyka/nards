class RoomController < ApplicationController
    def index
      @id = params[:id]
      
      current_user.location_id = @id
      current_user.save 
      
      @room = current_user.location.name
#      @user = Location.find(1).users.find(1).username

    end
    
    def join
      @game_id = params[:new_game][:game_id]
      current_user.game_id = @game_id
      current_user.save
    end
    
    def reject
      current_user.game = nil
      current_user.save
    end
    
    def save
      current_user.game = Game.new(:timeout => params[:timeout])
      current_user.save
      @user = current_user
    end
end
