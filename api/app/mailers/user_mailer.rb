class UserMailer < ActionMailer::Base
  default from: "no-reply@audiowire.co"

  def   welcome_email(user)
    @user = user
    @url = "https://audiowire.co"
    mail(to: @user.email, subject: "Welcome to AudioWire!")
  end

  def   ask_join(user, email)
    @user = user
    @url = "https://audiowire.co"
    mail(to: email, subject: "Join AudioWire right now!")
  end
end
