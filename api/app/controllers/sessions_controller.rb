class SessionsController < Devise::SessionsController
  #skip_before_filter :require_no_authentication, :only => [ :create ]

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new", :store => !(request.format.xml? || request.format.json?))
    sign_in(resource_name, resource)
    render :status=>201, :json => {:success => true, :token => resource.authentication_token}
  end

  def destroy
    user = User.find_by_authentication_token(params[:token])
    # check if user found
    user.reset_authentication_token!
    render :status=>200, :json => {:success => true}
  end
end
