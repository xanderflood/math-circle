class RemindersMailer < ApplicationMailer
  default from: 'no-reply-math-circle@math.cs.emory.edu'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reminders_mailer.after_profile.subject
  #
  def after_profile(parent)
    @parent = parent

    mail to: parent.email, subject: "Register for classes"
  end
end
