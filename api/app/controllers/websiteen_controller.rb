class WebsiteenController < ApplicationController
def home
  	end

  	def about
  	end

  	def contact
  	end

  	def team
  	end

  	def login
  	end

  	def terms
  	end

    def reset_password
      @user = User.find_by_id(params[:id])
      @token = params[:token]
    end

    def support
    end
end
