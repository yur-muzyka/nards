class MainController < ApplicationController
  def index
   
    
    if current_user

      current_user.location_id = 4
      current_user.save
      @room1 = Location.find(1)
      @room2 = Location.find(2)
      @room3 = Location.find(3)

      render 'logged'

    end
    
  end

end