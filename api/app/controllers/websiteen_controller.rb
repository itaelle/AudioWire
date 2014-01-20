class WebsiteenController < ApplicationController
    def home
      @language = "en"
      @current_page = ""
  	end

  	def about
      @language = "en"
      @current_page = "about"
  	end

  	def contact
      @language = "en"
      @current_page = "contact"
  	end

  	def team
      @language = "en"
      @current_page = "team"
  	end

  	def login
      @language = "en"
      @current_page = "account"
  	end

  	def terms
      @language = "en"
      @current_page = "terms"
  	end

    def reset_password
      @language = "en"
      @current_page = "reset-password"
      @user = User.find_by_id(params[:id])
      @token = params[:token]
    end

    def support
      @language = "en"
      @current_page = "support"
    end
end
