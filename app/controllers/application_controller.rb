class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || items_path(current_user.domain_name)
  end
  
  def after_sign_out_path_for(resource_or_scope)
    root_url
  end
  
end
