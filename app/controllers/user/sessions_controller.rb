class User::SessionsController < Devise::SessionsController
  
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in(resource_name, resource)
    render :json => {:success => true, :domain_name => current_user.domain_name}
    #redirect_to items_path(current_user.domain_name) #此处要定义两种响应类型
  end

  def failure
    render:json => {:success => false, :msg => t("error.login_error")}
  end
end
