class UserMailer < ActionMailer::Base
  default from: "contact@audiowire.co"

  def   welcome_email(user)
    @user = user
    @url = "www.google.com"
    mail(to: @user.email, subject: "Welcome to AudioWire!")
  end

  def   ask_join(user, email)
    @user = user
    @url = "www.google.com"
    mail(to: email, subject: "Join AudioWire right now!!")
  end
end
