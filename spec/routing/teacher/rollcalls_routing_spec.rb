require "rails_helper"

RSpec.describe Teacher::RollcallsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/teacher/rollcalls").to route_to("teacher/rollcalls#index")
    end

    it "routes to #new" do
      expect(:get => "/teacher/rollcalls/new").to route_to("teacher/rollcalls#new")
    end

    it "routes to #show" do
      expect(:get => "/teacher/rollcalls/1").to route_to("teacher/rollcalls#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/teacher/rollcalls/1/edit").to route_to("teacher/rollcalls#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/teacher/rollcalls").to route_to("teacher/rollcalls#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/teacher/rollcalls/1").to route_to("teacher/rollcalls#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/teacher/rollcalls/1").to route_to("teacher/rollcalls#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/teacher/rollcalls/1").to route_to("teacher/rollcalls#destroy", :id => "1")
    end

  end
end
