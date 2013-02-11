class ChatController < ApplicationController
  def save
    ###
    if params[:chat][:text] == ":clear"
      Chat.delete_all
    end
    ##
    @user_id = current_user.id
    @chat = Chat.new(params[:chat].merge(:user_id => current_user.id))
    @chat.save
    render :layout => false
  end
end