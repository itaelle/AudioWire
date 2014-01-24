class WebsiteenController < ApplicationController
    def home
      @language = "en"
      @current_page = ""
      @hideall = "false"
  	end

  	def login
      @language = "en"
      @current_page = "account"
      @hideall = "false"
  	end

  	def terms
      @language = "en"
      @current_page = "terms"
      @hideall = "true"
  	end
    def termsembedded
      @language = "en"
      @current_page = "terms"
      @hideall = "false"
    end

    def reset_password
      @language = "en"
      @current_page = "reset-password"
      @user = User.find_by_id(params[:id])
      @token = params[:token]
      @hideall = "false"
    end

    def support
      @language = "en"
      @current_page = "support"
      @hideall = "false"
    end

    def download
      @language = "en"
      @current_page = "download"
      @hideall = "false"
    end
end
