class MainController < ApplicationController
  
  def index
    @stub = current_user
        @chat3 = Chat.find(:all)
  @ajax_libs = "asdf-----------------------"		
    if current_user
      flash[:notice] = 'Story submission succeeded'
      render 'logged'
    end
  end
  
end