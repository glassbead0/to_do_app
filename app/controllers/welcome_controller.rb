class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to list_path(current_user.lists.find_by(name: 'Default'))
    end
  end
end
