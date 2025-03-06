require "rails_helper"

RSpec.describe ActionPermissionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/action_permissions").to route_to("action_permissions#index")
    end

    it "routes to #new" do
      expect(get: "/action_permissions/new").to route_to("action_permissions#new")
    end

    it "routes to #show" do
      expect(get: "/action_permissions/1").to route_to("action_permissions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/action_permissions/1/edit").to route_to("action_permissions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/action_permissions").to route_to("action_permissions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/action_permissions/1").to route_to("action_permissions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/action_permissions/1").to route_to("action_permissions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/action_permissions/1").to route_to("action_permissions#destroy", id: "1")
    end
  end
end
