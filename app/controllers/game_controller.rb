class GameController < ApplicationController

  def index
	@user = current_user
    @chat3 = Chat.find(:all)
    @stub = "stub for game controller"
	
	
  end

end