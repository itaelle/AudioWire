require 'uri'
require 'httparty'

class FriendshipsController < ApplicationController
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

  def index
    user = User.find_by_authentication_token(params[:token])
    list = []
    user.friendships.each do |friendship|
      res = {}
      res[:id] = friendship[:id]
      res[:friend_id] = friendship[:friend_id]
      res[:user_id] = friendship[:user_id]
      res[:created_at] = friendship[:created_at]
      res[:updated_at] = friendship[:updated_at]
      u = User.find(friendship[:friend_id])
      res[:first_name] = u[:first_name]
      res[:last_name] = u[:last_name]
      res[:username] = u[:username]
      res[:email] = u[:email]
      list.append(res)
    end
    render :status => 200, :json=>{:success=>true, :friends => list, :nb_friends => list.size}
  end

  def create
    user = User.find_by_authentication_token(params[:token])
    if params[:friend_email].nil?
      render :status => 400, :json=>{:success=>false, :error=>"friend_email field is missing"}
      return
    end
    friend = User.find_by_email(params[:friend_email])
    if !friend
      UserMailer.ask_join(user, params[:friend_email]).deliver
      render :status => 404, :json=>{:success=>false, :error=>"Friend does not exists"}
      return
    end
    if friend == user
      # UserMailer.ask_join(user, params[:friend_email]).deliver
      render :status => 404, :json=>{:success=>false, :error=>"You can't be friend with yourself"}
      return
    end
    @friendship = get_friendship(user.id, friend.id)
    if @friendship.nil?

      @friendship = user.friendships.build(:friend_id=>friend.id)
      if @friendship.save
        secret = "E7SBm6qv"
        createChatUserURL = "http://audiowire.co:9090/plugins/userService/userservice?type=add_roster&secret=#{ secret }&username=#{ user.username }&item_jid=#{ friend.username }@audiowire.co&name=#{ friend.username}&subscription=3"
        encoded_uri = URI::encode createChatUserURL
        HTTParty.get(encoded_uri)
        render :status => 201, :json=>{:success=>true, :friend=>@friendship}
      else
        render :status=>:unprocessable_entity, :json=>{:success=>false, :errors=>@friendship.errors}
      end
    else
      render :status=> 200, :json=>{:success=>true, :friend=>@friendship}
    end
  end

  def destroy
    user = User.find_by_authentication_token(params[:token])
    friends = params[:friends_email]
    nb_deleted = 0
    if params[:friends_email].nil? || params[:friends_email].empty?
      render :status => 400, :json=>{:success=>false, :error=>"friends_email field is missing"}
      return
    end
    friends.each do |friend_email|
      friend = User.find_by_email(friend_email)
      if !friend.nil?
        @friendship = get_friendship(user.id, friend.id)
        if !@friendship.nil?
          @friendship.destroy
          nb_deleted = nb_deleted + 1
          secret = "E7SBm6qv"
          createChatUserURL = "http://audiowire.co:9090/plugins/userService/userservice?type=delete_roster&secret=#{ secret }&username=#{ user.username }&item_jid=#{ friend.username }@audiowire.co"
          encoded_uri = URI::encode createChatUserURL
          HTTParty.get(encoded_uri)
        end
      end
    end
    if nb_deleted == 0
      render :status => 404, :json => {:success=>false, :message => "0 friend were deleted from your friendlist", :nb_friends=>user.friends.count, :nb_deleted=>nb_deleted}
    elsif nb_deleted == 1
      render :status => 200, :json => {:success=>true, :message => "1 friend has been deleted from your friendlist", :nb_friends=>user.friends.count, :nb_deleted=>nb_deleted}
    else
      render :status => 200, :json => {:success=>true, :message => "#{nb_deleted} friends have been deleted from your friendlist", :nb_friends=>user.friends.count, :nb_deleted=>nb_deleted}
    end
  end

  protected
  def get_friendship(user_id, friend_id)
    Friendship.where("user_id = ? AND friend_id = ?", user_id, friend_id)[0]
  end
end
