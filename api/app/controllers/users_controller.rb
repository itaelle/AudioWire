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

  def   update_avatar
    @user = User.find_by_authentication_token(params[:token])
    if params[:avatar].nil?
      render :status=>404, json: {:success=>false, :error=>'Picture is missing'}
    end
    @user.avatar = params[:avatar]
    @user.avatar.save
    @user.save
    render :status=>200, json: {:success=>true, :error=>'Avatar has been uploaded'}
  end

  def update
    @user = User.find_by_authentication_token(params[:token])
    if @user.update_attributes(params[:user])
      render :status=>201, :json=>{:success=>true, :message=>"User has been updated"}
    else
      render :status=>400, :json=>{:success=>false, :error=>"An error occured"}
    end
  end

  def index
    lst = User.all
    render :status=>200, :json=>{:success=>true, :list=>lst}
  end

  def show
    #render :status=>200, :json=>{:success=>true, :data=>params[:user]}
     user = User.find_by_id(params[:id])
    if !user.nil?
      render :status=>200, :json=>{:success=>true, :user=>user}
    else
      render :status=>404, :json=>{:success=>false, :error=>"User does not exist"}
    end
  end

end
