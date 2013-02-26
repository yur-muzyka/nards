class ChatController < ApplicationController
  def save
    @user_id = current_user.id
    @chat = Chat.new(params[:chat].merge(:user_id => current_user.id, :location_id => current_user.location.id))
    @chat.save
    render :layout => false
  end
end