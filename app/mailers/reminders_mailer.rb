class RemindersMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reminders_mailer.after_profile.subject
  #
  def after_profile
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
