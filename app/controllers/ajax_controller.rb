class AjaxController < ApplicationController
  def load
    User.update_all ["last_visit=?", Time.now], ["id=?", current_user]
    @chat_message = Chat.find(:all, :conditions => ['id > ?', params[:last]])
    @online_users= User.find(:all, :conditions => ['last_visit > ?', Time.now - 15.seconds], :order => 'username')
    
    @created_games = Game.joins(:users).group(:game_id).having("COUNT(*) = 1")
#   @created_games = Game.joins(:users).group("users.id").having("count(users.id) = 1")  
    
    render :layout => false, :template => 'ajax/load'
  end
end