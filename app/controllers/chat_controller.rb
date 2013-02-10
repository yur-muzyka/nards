class ChatController < SecurityController
  def chat_save
    @user_id = current_user.id
    @chat = Chat.new(params[:chat].merge(:user_id => current_user.id))
    @chat.save
#    render :nothing => true
    # redirect_to(:back)
# render request.env["HTTP_REFERER"][:ation]
# text1 = Rails.application.routes.recognize_path(request.referer)[:controller]
  # text2 = Rails.application.routes.recognize_path(request.referer)[:action]
# render :controller => text1
# Rails.application.routes.recognize_path(request.referer)[:action]
    # render session[:http_referer][:action]
    # render Railsg.application.routes.recognize_path(request.referer)[:action]
  end

  def chat_load
    User.update_all ["last_visit=?", Time.now], ["id=?", current_user]
    @chat_message = Chat.find(:all, :conditions => ['id > ?', params[:last]])
    @online_users= User.find(:all, :conditions => ['last_visit > ?', Time.now - 15.seconds], :order => 'username')

    render :template => 'chat/chat_load'
  end
end