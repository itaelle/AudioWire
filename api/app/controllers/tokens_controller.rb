# -*- coding: utf-8 -*-
class TokensController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  def create
      email = params[:email]
      password = params[:password]
    if email.nil? or password.nil?
       render :status=>400, :json=>{:success=>false, :error=>"The request must contain the user email and password"}
       return
    end
    @user=User.find_by_email(email.downcase)

    if @user.nil?
      logger.info("User #{email} failed signin, user cannot be found.")
      render :status=>403, :json=>{:success=>false, :error=>"Invalid email or passoword"}
      return
    end
    @user.ensure_authentication_token!

    if not @user.valid_password?(password)
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      render :status=>403, :json=>{:success=>false, :error=>"Invalid email or password"}
    else
      render :status=>201, :json=>{:success=>true, :token=>@user.authentication_token}
    end
  end

  def delete
    @user=User.find_by_authentication_token(request.GET[:token])
    if @user.nil?
      logger.info("Token not found.")
      render :status=>404, :json=>{:success=>false, :error=>"Invalid token"}
    else
      @user.reset_authentication_token!
      render :status=>200, :json=>{:success=>true, :message=>"Token deleted"}
    end
  end
end
