class ChatController < SecurityController
  def chat_save
    @user_id = current_user.id
    @chat = Chat.new(params[:chat].merge(:user_id => current_user.id))
    @chat.save
    redirect_to(:back)
  end

  def chat_load
    User.update_all ["active=?", Time.now], ["id=?", current_user]
    @chat_message = Chat.find(:all, :conditions => ['id > ?', params[:last]])
    @online_users= User.find(:all, :conditions => ['active > ?', Time.now - 15.seconds])

    render :template => 'chat/chat_load'
  end
end