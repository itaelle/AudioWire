class TracksController < ApplicationController
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
  

  def list
    user = User.find_by_authentication_token(params[:token])
    lst = user.tracks.all()
    render :status=>200, :json=>{:success=>true, :list=>lst}
  end

  def bulk_delete
    user = User.find_by_authentication_token(params[:token])
    lst = params[:tracks_id]
    if params[:tracks_id].nil?
      render :status => 400, :json=>{:success=>false, :error=>"tracks_id field is missing or invalid"}
      return
    end
    playlists = Playlist.find_all_by_user_id(user.id)
    counter = 0
    lst.each do |id|
      track = user.tracks.find_by_id(id)
       if !track.nil?
          delete_track_from_playlists(user, track)
          track.delete
          counter = counter + 1
      end
    end
    message = "Track has been deleted."
    if counter > 1
      message = "Tracks have been deleted"
    end
    render :status=>200, :json=>{:success=>true, :message=>message}
  end

  def delete
    user = User.find_by_authentication_token(params[:token])
    track = user.tracks.find_by_id(params[:id])
    if !track.nil?
      delete_track_from_playlists(user, track)
      track.delete
    else
      render :status=>404, :json=>{:success=>false, :message=>"Track does not exist"}
      return
    end
    render :status=>200, :json=>{:success=>true, :message=>"Track has been deleted."}
  end

  def update
    track = Track.find_by_id(params[:id])
    user = User.find_by_authentication_token(params[:token])
    if track.nil?
      render :status=>404, :json=>{:success=>false, :error=>"The track cannot be found"}
      return
    end
    if track.user_id == user.id
      if track.update_attributes(params[:track])
        render :status=>200, :json=>{:success=>true, :message=>"Track information have been updated."}
      end
    else
      render :status=>403, :json=>{:success=>false, :error=>"You do not own this track"}
    end
  end

  def create
    user = User.find_by_authentication_token(params[:token])
    lst = params[:tracks]
    flag_error = false
    lst.each do |t|
      track = user.tracks.new(t)
      if !track.save
        flag_error = true
        render :status => 403, :json => {:success=>false, :error => track.errors}
      end
    end
    if flag_error == false
      render :status => 200, :json => {:success=>true, :message => "Tracks have been created"}
    end
  end

  def show
     track = Track.find_by_id(params[:id])
     user = User.find_by_authentication_token(params[:token])
    if !track.nil?
      if track.user_id == user.id
        render :status=>200, :json=>{:success=>true, :track=>track}
      else
        render :status=>403, :json=>{:success=>false, :error=>"You do not own this track"}
      end
    else
      render :status=>404, :json=>{:success=>false, :error=>"Track does not exist"}
    end
  end


  protected

  def delete_track_from_playlists(user, track)
    playlists = Playlist.find_all_by_user_id(user.id)
    if !playlists.nil?
      playlists.each do |playlist|
        relation_id = playlist.relation_playlists.find_by_track_id(track.id)
        if !relation_id.nil?
          playlist.relation_playlists.find_by_id(relation_id).delete
        end
      end
    end
  end

end
