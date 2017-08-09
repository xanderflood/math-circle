require "rails_helper"

RSpec.describe Teacher::StudentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/teacher/students").to route_to("teacher/students#index")
    end

    it "routes to #new" do
      expect(:get => "/teacher/students/new").to route_to("teacher/students#new")
    end

    it "routes to #show" do
      expect(:get => "/teacher/students/1").to route_to("teacher/students#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/teacher/students/1/edit").to route_to("teacher/students#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/teacher/students").to route_to("teacher/students#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/teacher/students/1").to route_to("teacher/students#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/teacher/students/1").to route_to("teacher/students#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/teacher/students/1").to route_to("teacher/students#destroy", :id => "1")
    end

  end
end
