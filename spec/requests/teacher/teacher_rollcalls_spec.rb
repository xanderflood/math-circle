require 'rails_helper'

RSpec.describe "Teacher::Rollcalls", type: :request do
  describe "GET /teacher_rollcalls" do
    it "works! (now write some real specs)" do
      get teacher_rollcalls_index_path
      expect(response).to have_http_status(200)
    end
  end
end
