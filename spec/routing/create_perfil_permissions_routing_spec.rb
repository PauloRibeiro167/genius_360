require "rails_helper"

RSpec.describe CreatePerfilPermissionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/create_perfil_permissions").to route_to("create_perfil_permissions#index")
    end

    it "routes to #new" do
      expect(get: "/create_perfil_permissions/new").to route_to("create_perfil_permissions#new")
    end

    it "routes to #show" do
      expect(get: "/create_perfil_permissions/1").to route_to("create_perfil_permissions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/create_perfil_permissions/1/edit").to route_to("create_perfil_permissions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/create_perfil_permissions").to route_to("create_perfil_permissions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/create_perfil_permissions/1").to route_to("create_perfil_permissions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/create_perfil_permissions/1").to route_to("create_perfil_permissions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/create_perfil_permissions/1").to route_to("create_perfil_permissions#destroy", id: "1")
    end
  end
end
