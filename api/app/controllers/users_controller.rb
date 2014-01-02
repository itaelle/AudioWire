require 'uri'
require 'httparty'

class UsersController < ApplicationController
  before_filter :after_token_authentication
  respond_to :json

  def after_token_authentication
    if params[:token].present?
      @user = User.find_by_authentication_token(params[:token])
      if (@user == nil)
        render :status=>403, json: {:success=>false, :error=>'Token is invalid'}
      end
    else
      render :status=>403, json: {:success=>false, :error=>'token field is missing'}
    end
  end

  def update
    @user = User.find_by_authentication_token(params[:token])
    if params[:user][:username] != @user.username
      render :status=>400, :json=>{:success=>false, :error=>"Updating username is forbidden"}
      return
    end
    if @user.update_attributes(params[:user]) == true
      secret = "E7SBm6qv"
      createChatUserURL = "http://audiowire.co:9090/plugins/userService/userservice?type=update&secret=#{ secret }&username=#{@user.username}&password=#{@user.password}&name=#{@user.first_name} #{@user.last_name}&email=#{@user.email}"
      encoded_uri = URI::encode createChatUserURL
      HTTParty.get(encoded_uri)
      render :status=>201, :json=>{:success=>true, :message=>"User has been updated"}
    else
      render :status=>400, :json=>{:success=>false, :error=>"An error occured"}
    end
  end

  def index
    lst = User.order("username ASC").all
    render :status=>200, :json=>{:success=>true, :list=>lst}
  end

  def show
     user = User.find_by_id(params[:id])
    if !user.nil?
      render :status=>200, :json=>{:success=>true, :user=>user}
    else
      render :status=>404, :json=>{:success=>false, :error=>"User does not exist"}
    end
  end

  def show_me
    user = User.find_by_authentication_token(params[:token])
    render :status=>200, :json=>{:success=>true, :user=>user}
  end

  def     soft_delete
    update_attributes(:delete_at, Time.current)
  end


end
