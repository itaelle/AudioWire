require 'net/http'

class   RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  respond_to :json

  def new
    super
  end

  def create
      build_resource sign_up_params
     if resource.save
          if resource.active_for_authentication?
              sign_up(resource_name, resource)
              UserMailer.welcome_email(resource).deliver
              secret = "E7SBm6qv"
              createChatUserURL = "http://audiowire.co:9090/plugins/userService/userservice?type=add&secret=#{ secret }&username=#{ @user.username}&password=#{ @user.password}&name=#{@user.first_name + " " + @user.last_name}&email=#{@user.email}"
              # result = Net::HTTP.get(URI.parse(createChatUserURL))
              # puts result
              render :status=>201, :json=>{:success=>true, :token=>@user.authentication_token, :id=>@user.id}
          else
            expire_session_data_after_sign_in!
            errors = create_error_msg_login(resource)
            render :status=>403, :json=>{:success=>false, :error=>error}
            #respond_with resource, :location => after_inactive_sign_up_path_for(resource)
          end
     else
       clean_up_passwords resource
       error = create_error_msg_login(resource)
       render :status=>403, :json=>{:success=>false, :error=>error}
     end
   end

   def     edit
     super
   end

   def     update
     super
   end

   def     destroy
     super
    # resource.soft_delete
    # Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    # render :status=>201, :json=>{:success=>true, :message=>"WORKED!!"}
    # set_flash_message :notice, :destroyed if is_navigational_format?
    # respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
   end

   def     cancel
     super
   end

   protected

  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  def   create_error_msg_login(resource)
    if resource.errors[:username][0].nil? == false
      return "Username " + resource.errors[:username][0]
    end
    if resource.errors[:email][0].nil? == false
      return "Email " + resource.errors[:email][0]
    end
    if resource.errors[:password][0].nil? == false
      return "Password " + resource.errors[:password][0]
    end
    return ""
  end

#  def registration_params
#    debugger
#    params.require(:registration).permit(:email, :password);
#  end

end
