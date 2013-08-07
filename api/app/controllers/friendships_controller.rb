class FriendshipsController < ApplicationController
  
  respond_to :json
  
  def   list
    user = User.find_by_authentication_token(params[:auth_token])
    if user.nil?
      logger.info("Token not found.")
      render :status=>404, :json=>{:message=>"Invalid token."}
    end
    hash = []
    user.friendships.each do |friendship|
      hash.append(friendship)
    end
    render :status => 201, :json=>{:list => hash}
  end

  def create
    user = User.find_by_authentication_token(params[:auth_token])
    @friendship = user.friendships.build(:friend_id => params[:friend_id])
    debugger
      if @friendship.save
        render :status => 201, :json=>{:friendship=>@friendship}
      else
        render json: @friendship.errors, status: :unprocessable_entity
      end
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy

    render :status => 201, :json=>{:message=>"Friendship no longer exists."}
  end
end
