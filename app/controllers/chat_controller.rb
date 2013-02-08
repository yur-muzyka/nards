class ChatController < SecurityController
  def chat_save
    @user_id = current_user.id
    @chat = Chat.new(params[:chat].merge(:user_id => current_user.id))
    @chat.save
    redirect_to(:back)
  end

  def chat_load
    @chat3 = Chat.find(:all, :conditions => ['id > ?', params[:last]])

    if @chat3.length == 0
      render :nothing => true
    else
      @last_id = @chat3.last[:id]
      render :template => 'chat/chat_load'
    end
  end
end