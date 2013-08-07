class UsersController < ApplicationController
  before_filter :after_token_authentication
  respond_to :json

  def after_token_authentication
    if params[:auth_token].present?
      @user = User.find_by_authentication_token(params[:auth_token])
      if (@user == nil)
        render json: 'Wrong token'
      end
    else
      render json: 'You need a token'
    end
  end

  def   update
    debugger
    @user = User.find_by_authentication_token(params[:auth_token])
    if @user.nil?
      render :status=>404, :json=>{:message=>"Cannot find the user"}
    end
    if @user.update_attributes(params[:user])
      render :status=>201, :json=>{:message=>"User has been updated"}
    end
  end
end
