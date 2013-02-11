class RoomController < ApplicationController
    def index
      @id = params[:id]
      
      current_user.location_id = @id
      current_user.save 
      
      @room = current_user.location.name
#      @user = Location.find(1).users.find(1).username

    end
    
    def join
      
    end
    
    def save
      current_user.game = Game.new(:timeout => 3)
      current_user.save
      @user = current_user
    end
end
