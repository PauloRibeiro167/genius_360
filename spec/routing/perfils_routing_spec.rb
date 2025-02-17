require "rails_helper"

RSpec.describe PerfilsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/perfils").to route_to("perfils#index")
    end

    it "routes to #new" do
      expect(get: "/perfils/new").to route_to("perfils#new")
    end

    it "routes to #show" do
      expect(get: "/perfils/1").to route_to("perfils#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/perfils/1/edit").to route_to("perfils#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/perfils").to route_to("perfils#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/perfils/1").to route_to("perfils#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/perfils/1").to route_to("perfils#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/perfils/1").to route_to("perfils#destroy", id: "1")
    end
  end
end
