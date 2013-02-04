class PagesController < ApplicationController

  skip_before_filter :authenticate_user!
  before_filter :is_login?

  def index
    render :layout => "home"
  end
  
  private
    
  def is_login?
    redirect_to items_path(current_user.domain_name) if signed_in?
  end

end
