require "rails_helper"

RSpec.describe RemindersMailer, type: :mailer do
  describe "after_profile" do
    let(:mail) { RemindersMailer.after_profile }

    it "renders the headers" do
      expect(mail.subject).to eq("After profile")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
