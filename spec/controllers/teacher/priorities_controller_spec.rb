require 'rails_helper'

RSpec.describe Teacher::PrioritiesController, type: :controller do

  describe "GET #manage" do
    it "returns http success" do
      get :manage
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #reset" do
    xit "render manage if threshold is invalid"

    xit "redirect home and flash otherwise"

    xit "values are right afterwards"
  end

end
