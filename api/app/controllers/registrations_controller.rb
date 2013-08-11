class   RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  respond_to :json

  # def new
  #   super
  # end

  def create
      build_resource
      if resource.save
          if resource.active_for_authentication?
              sign_up(resource_name, resource)
              # respond_with resource, :token => resource.authentication_token#:location => after_sign_up_path_for(resource)
              render :status=>201, :json=>{:success=>true, :token=>@user.authentication_token}
          else
              expire_session_data_after_sign_in!
              render :status=>403, :json=>{:success=>false, :errors=>resource.errors}
              #respond_with resource, :location => after_inactive_sign_up_path_for(resource)
          end
      else
          clean_up_passwords resource
          render :status=>403, :json=>{:success=>false, :errors=>resource.errors}
          #respond_with resource
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
   end

   def     cancel
     super
   end

   protected

  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

end
