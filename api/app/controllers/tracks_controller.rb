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

  def delete
    user = User.find_by_authentication_token(params[:token])
    lst = params[:tracks_id]
    counter = 0
    lst.each do |id|
      track = user.tracks.find_by_id(id)
       if !track.nil?
          track.delete
          counter = counter + 1
      end
    end
    message = "Elements have been deleted."
    if counter > 1
      message = "Element has been deleted"
    end
    render :status=>200, :json=>{:success=>true, :message=>message}
  end

  def download
    track = Track.find_by_id(params[:id])
    if !track.nil?
      render :status=>404, :json=>{:success=>false, :error=>"The track cannot be found"}
    end
  end

  def   update
    track = Track.find_by_id(params[:track_id])
    if track.nil?
      render :status=>404, :json=>{:success=>false, :error=>"The track cannot be found"}
      return
    end
    if track.update_attributes(params[:track])
      render :status=>200, :json=>{:success=>true, :message=>"Track information have been updated."}
    end
  end

  def upload
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
end
