class TracksController < ApplicationController
  respond_to :json

  def   list
    user = User.find_by_authentication_token(params[:token])
    if user.nil?
      logger.info("Token not found.")
      render :status=>403, :json=>{:success:false, :message=>"Invalid token"}
    end
    lst = user.tracks.all()
    render :status=>200, :json=>{:success:true, :list=>lst}
  end

  def   delete
    user = User.find_by_authentication_token(params[:token])
    if user.nil?
      logger.info("Token not found.")
      render :status=>403, :json=>{:success:false, :error=>"Invalid token"}
    end
    lst = params[:tracks_id]
    counter = 0
    lst.each do |id|
      track = user.tracks.find_by_id(id)
      if !track.nil?
        if track.song.destroy == true
          track.delete
          counter = counter + 1
        end
      end
    end
    message = "Elements have been deleted."
    if counter > 1
      message = "Element has been deleted"
    end
    render :status=>200, :json=>{:success:true, :message=>message}
  end

  def download
    track = Track.find_by_id(params[:id])
    if !track.nil?
      render :status=>404, :json=>{:success:false, :error=>"The track cannot be found"}
    end
  end

  def upload
    user = User.find_by_authentication_token(params[:token])
    if user.nil?
      logger.info("Token not found.")
      render :status=>403, :json=>{:success:false, :message=>"Invalid token"}
    end
    hash = {}
    hash[:title] = params[:song].original_filename
    hash[:song] = params[:song]
    track = user.tracks.create(hash)
    if track.nil?
      track.save
    end
    render :status => 201, :json => {:success:true, :message => "Song has been uploaded"}
  end
end
