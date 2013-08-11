class HomeController < ApplicationController
  def index
    render :status=>200, :json=>{:success=>true, :message=>"API is working properly."}
  end
end
