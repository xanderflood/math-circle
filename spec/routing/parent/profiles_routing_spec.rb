require "rails_helper"

RSpec.describe Parent::ProfilesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/parent/profiles").to route_to("parent/profiles#index")
    end

    it "routes to #new" do
      expect(:get => "/parent/profiles/new").to route_to("parent/profiles#new")
    end

    it "routes to #show" do
      expect(:get => "/parent/profiles/1").to route_to("parent/profiles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/parent/profiles/1/edit").to route_to("parent/profiles#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/parent/profiles").to route_to("parent/profiles#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/parent/profiles/1").to route_to("parent/profiles#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/parent/profiles/1").to route_to("parent/profiles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/parent/profiles/1").to route_to("parent/profiles#destroy", :id => "1")
    end

  end
end
