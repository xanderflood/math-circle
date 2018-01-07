require "rails_helper"

RSpec.describe RemindersMailer, type: :mailer do
  describe "after_profile" do
    let(:mail) { RemindersMailer.after_profile(Parent.first) }

    it "renders the headers" do
      @parent = Parent.first
      expect(mail.subject).to eq("Register for classes")
      expect(mail.to).to eq([@parent.email])
      expect(mail.from).to eq(["no-reply-math-circle@math.cs.emory.edu"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
