require 'rails_helper'

RSpec.describe Teacher::PrioritiesController, type: :controller do

  describe "GET #manage" do
    it "returns http success" do
      get :manage
      expect(response).to have_http_status(:success)
    end
  end

  # describe "GET #reset" do
  #   it "returns http success" do
  #     post :reset
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
