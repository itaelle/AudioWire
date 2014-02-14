class WebsitefrController < ApplicationController
    def home
      @language = "fr"
      @current_page = ""
      @hideall = "false"
    end

    def login
      @language = "fr"
      @current_page = "account"
      @hideall = "false"
    end

    def termsembedded
      @language = "fr"
      @current_page = "terms"
      @hideall = "false"
    end

    def reset_password
      @language = "fr"
      @current_page = "reset-password"
      @user = User.find_by_id(params[:id])
      @token = params[:token]
      @hideall = "false"
    end

    def support
      @language = "fr"
      @current_page = "support"
      @hideall = "false"
    end

    def download
      @language = "fr"
      @current_page = "download"
      @hideall = "false"
    end
end
