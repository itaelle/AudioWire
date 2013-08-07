class HomeController < ApplicationController
  def index
    render :status=>201, :json=>{:message=>"home"}
  end
end
