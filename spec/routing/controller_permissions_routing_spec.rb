require "rails_helper"

RSpec.describe ControllerPermissionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/controller_permissions").to route_to("controller_permissions#index")
    end

    it "routes to #new" do
      expect(get: "/controller_permissions/new").to route_to("controller_permissions#new")
    end

    it "routes to #show" do
      expect(get: "/controller_permissions/1").to route_to("controller_permissions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/controller_permissions/1/edit").to route_to("controller_permissions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/controller_permissions").to route_to("controller_permissions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/controller_permissions/1").to route_to("controller_permissions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/controller_permissions/1").to route_to("controller_permissions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/controller_permissions/1").to route_to("controller_permissions#destroy", id: "1")
    end
  end
end
