class User::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource

    if resource.save
      sign_in(resource_name, resource)
      return render :json => {:success => true, :domain_name => current_user.domain_name}
    else
      clean_up_passwords(resource)
      return render:json => {:success => false, :msg => t("error.registration_error")}
    end
  end

  
end
