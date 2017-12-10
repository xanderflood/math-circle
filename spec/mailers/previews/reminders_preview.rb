# Preview all emails at http://localhost:3000/rails/mailers/reminders
class RemindersPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/reminders/after_profile
  def after_profile
    RemindersMailer.after_profile
  end

end
