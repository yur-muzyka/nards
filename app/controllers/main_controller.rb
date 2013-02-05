class MainController < ApplicationController

  def index
    @stub = current_user

    if current_user
      flash[:notice] = 'Story submission succeeded'
      render 'logged'
    end
  end
  
  def logged
    @stub = "dd!!!!"
  end

end



# class UsersController < ApplicationController
      # def index
        # if logged_in && is_admin
          # render 'admin_index'
        # else
          # render 
        # end
# 
      # end
    # end