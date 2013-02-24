class RoomController < RedirectController
    def index
      @ajax_options = ['messages', 'online', 'reload', 'created_games']

      
      @id = params[:id]
      
      current_user.location_id = @id
      current_user.save 
      
      @room = current_user.location.name
      
      render :layout => "main"
    end
    
    def join
      @game_id = params[:new_game][:game_id]
      current_user.game_id = @game_id
      current_user.game.status = "in_progress"
      current_user.game.last_move = Time.now
      current_user.game.save
      current_user.save
      current_user.game.first_move_generate
    end
    
    def reject
      current_user.game = nil
      current_user.save
      redirect_to :back
    end
    
    def save
      current_user.game = Game.new(:timeout => params[:timeout], 
          :condition =>  '15b-00b-00b-00b-00b-00b-00w-00w-00w-00w-00w-00w-' +
                         '15w-00b-00b-00b-00b-00b-00b-00b-00b-00b-00b-00b-' + 
                         '00b-00b',
          :dice => (rand(6) + 1) *10 + rand(6) + 1,
          :move_count => 0,
          :last_move => Time.now,
          :location_id => current_user.location_id
          )
      current_user.save
      @user = current_user
      redirect_to :back
    end
end
