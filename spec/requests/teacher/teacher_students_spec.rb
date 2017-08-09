require 'rails_helper'

RSpec.describe "Teacher::Students", type: :request do
  describe "GET /teacher_students" do
    it "works! (now write some real specs)" do
      get teacher_students_index_path
      expect(response).to have_http_status(200)
    end
  end
end
