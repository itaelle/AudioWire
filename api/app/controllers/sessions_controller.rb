class SessionsController < Devise::SessionsController
  #skip_before_filter :require_no_authentication, :only => [ :create ]

  def create
    debugger
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new", :store => !(request.format.xml? || request.format.json?))
    sign_in(resource_name, resource)
    render :json => {:success => true, :token => resource.authentication_token}
  end

  def destroy
    user = User.find_by_authentication_token(params[:auth_token])
    # check if user found
    user.reset_authentication_token!
    render :json => {:success => true}
  end

  # shouldn't be usefull
  def new
  end
end
