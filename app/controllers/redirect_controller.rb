class RedirectController < ApplicationController

  before_filter :in_game_redirect

  private
  def in_game_redirect
    if current_user && current_user.game && 
        (current_user.game.status == "in_progress" ||
        current_user.game.status == "game_over") &&
        url_for(:game) != url_for(:only_path => false)
      redirect_to :game
    end
  end

end