class PlaylistsController < ApplicationController
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
    playlists = Playlist.find_all_by_user_id(user.id)
    if playlists.nil?
      render :status=>200, json: {:success=>true, :list=>[]}
    else
      lst = []
      playlists.each do |playlist|
        tmp = {}
        tmp[:id] = playlist[:id]
        tmp[:title] = playlist[:title]
        tmp[:created_at] = playlist[:created_at]
        tmp[:updated_at] = playlist[:updated_at]
        tmp[:user_id] = playlist[:user_id]
        tmp[:nb_tracks] = playlist.relation_playlists.count
        lst.append(tmp)
      end
      render :status=>200, json: {:success=>true, :list=>lst}
    end
  end

  def   create
    user = User.find_by_authentication_token(params[:token])
    playlist = user.playlists.new(params[:playlist])
    if playlist.save
      render :status => 201, :json => {:success=>true, :message => "Playlist has been created", :id => playlist.id}
    else
      render :status => 400, :json => {:success=>false, :error => 'title ' + playlist.errors['title'][0]}
    end
  end


  def bulk_delete
    user = User.find_by_authentication_token(params[:token])
    playlists = user.playlists.find_all_by_id(params[:playlist_ids])
    puts params
    puts playlists
    if playlists.empty?
      if params[:playlist_ids].count > 1
        render :status => 404, :json => {:success=>false, :error => "Playlists do not exist"}
      else
        render :status => 404, :json => {:success=>false, :error => "Playlist does not exist"}
      end
    else
      Playlist.delete(playlists)
      if playlists.count > 1
        render :status => 200, :json => {:success=>true, :message => "Playlists have been deleted"}
      else
        render :status => 200, :json => {:success=>true, :message => "Playlist has been deleted"}
      end
    end
  end

  def delete
    user = User.find_by_authentication_token(params[:token])
    playlist = user.playlists.find_by_id(params[:id])
    if playlist.nil?
      render :status => 404, :json => {:success=>false, :error => "Playlist does not exist"}
    else
      Playlist.delete(playlist)
      render :status => 200, :json => {:success=>true, :message => "Playlist has been deleted"}
    end
  end

  def update
    user = User.find_by_authentication_token(params[:token])
    playlist = user.playlists.find_by_id(params[:id])
    if playlist.nil?
      render :status => 404, :json => {:success=>false, :error => "Playlist does not exist"}
    else
      if playlist.update_attributes(params[:playlist])
        render :status => 200, :json => {:success=>true, :message => "Attributes have been updated"}
      else
        render :status => 400, :json => {:success=>false, :error => 'title ' + playlist.errors['title'][0]}
      end
    end
  end

  def get_tracks
    user = User.find_by_authentication_token(params[:token])
    playlist = user.playlists.find_by_id(params[:id])
    if playlist.nil?
      render :status => 404, :json => {:success=>false, :error => "Playlist does not exist"}
    else
      tracks = []
      tmp = playlist.relation_playlists.all
      tmp.each do |relation|
        tracks.append(Track.find(relation.track_id))
      end
      render :status => 200, :json => {:success=>true, :id=>playlist.id, :tracks=>tracks}
    end
  end


  def add_tracks
    user = User.find_by_authentication_token(params[:token])
    playlist = user.playlists.find_by_id(params[:id])
    if playlist.nil?
      render :status => 404, :json => {:success=>false, :error => "Playlist does not exist"}
    else
      ret = add_tracks_by_ids(playlist, params[:tracks_id])
      if ret == -1  # an error occured
        return
      else
        ret2 = add_tracks_by_content(user, playlist, params[:tracks])
        if ret2  == -1  # an error occured
          return
        elsif ret + ret2 >= 1  # at least one sonf was added
          render :status => 201, :json => {:success=>true, :message => "Tracks have been added to the playlist"}
        else  # no tracks in params
          render :status => 400, :json => {:success=>true, :message => "No track found in params"}
        end
      end
    end
  end

  def bulk_delete_tracks
    user = User.find_by_authentication_token(params[:token])
    playlist = user.playlists.find_by_id(params[:id])
    lst = params[:tracks_id]
    if playlist.nil?
      render :status => 404, :json => {:success=>false, :error => "Playlist does not exist"}
    else
      nb_deleted = 0
      lst.each do |track_id|
        relation_id = playlist.relation_playlists.find_by_track_id(track_id)
        if !relation_id.nil?
          relation = playlist.relation_playlists.find_by_id(relation_id)
          relation.delete
          nb_deleted = nb_deleted + 1
        end
      end
      if nb_deleted == 0
        render :status => 404, :json => {:success=>false, :message => "0 track has been deleted from the playlist", :nb_tracks=>playlist.relation_playlists.count, :nb_deleted=>nb_deleted}
      elsif nb_deleted == 1
        render :status => 200, :json => {:success=>true, :message => "1 track has been deleted from the playlist", :nb_tracks=>playlist.relation_playlists.count, :nb_deleted=>nb_deleted}
      else
        render :status => 200, :json => {:success=>true, :message => "#{nb_deleted} tracks have been deleted from the playlist", :nb_tracks=>playlist.relation_playlists.count, :nb_deleted=>nb_deleted}
      end
    end
  end

  def delete_track
    user = User.find_by_authentication_token(params[:token])
    playlist = user.playlists.find_by_id(params[:id])
    lst = params[:track_id]
    if playlist.nil?
      render :status => 404, :json => {:success=>false, :error => "Playlist does not exist"}
    else
      relation_id = playlist.relation_playlists.find_by_track_id(track_id)
      if relation_id.nil?
        render :status => 404, :json => {:success=>false, :message => "track #{track_id} is not in the playlist", :nb_tracks=>playlist.relation_playlists.count}
      else
        relation = playlist.relation_playlists.find_by_id(relation_id)
        relation.delete
      end
    end
    render :status => 200, :json => {:success=>true, :message => "Track #{track_id} has been deleted from the playlist", :nb_tracks=>playlist.relation_playlists.count}
  end

  def   show
    user = User.find_by_authentication_token(params[:token])
    playlist = user.playlists.find_by_id(params[:id])
    if playlist.nil?
      render :status => 404, :json => {:success=>false, :error => "Playlist does not exist"}
    else
      playlist[:nb_tracks] = playlist.relation_playlists.count
      render :status => 200, :json => {:success=>true, :playlist => playlist}
    end
  end

   protected

  def   create_error_msg(resource)
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

  def add_tracks_by_ids(playlist, ids)
    if ids.nil?
      return 0
    end
    ids.each do |track_id|
      if Track.find_by_id(track_id).nil?
        render :status => 404, :json => {:success=>false, :error => "Couldn't find track #{track_id}"}
        return -1
      else
        playlist.relation_playlists.new({:track_id => track_id})
      end
    end
    playlist.save
    return 1
  end

  def add_tracks_by_content(user, playlist, tracks)
    if tracks.nil?
      return 0
    end
    flag_error = false
    tracks.each do |t|
      track = user.tracks.new(t)
      if !track.save
        flag_error = true
        render :status => 403, :json => {:success=>false, :error => track.errors}
      else
        playlist.relation_playlists.new({:track_id => track.id})
      end
    end
    playlist.save
    if flag_error == true
      return -1
    end
    return 1
  end

end
