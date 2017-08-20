require 'rails_helper'

RSpec.describe "Teacher::Ballots", type: :request do
  describe "GET /teacher_ballots" do
    it "works! (now write some real specs)" do
      get teacher_ballots_path
      expect(response).to have_http_status(200)
    end
  end
end
