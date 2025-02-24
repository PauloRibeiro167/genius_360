require "rails_helper"

RSpec.describe PerfilUsersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/perfil_users").to route_to("perfil_users#index")
    end

    it "routes to #new" do
      expect(get: "/perfil_users/new").to route_to("perfil_users#new")
    end

    it "routes to #show" do
      expect(get: "/perfil_users/1").to route_to("perfil_users#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/perfil_users/1/edit").to route_to("perfil_users#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/perfil_users").to route_to("perfil_users#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/perfil_users/1").to route_to("perfil_users#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/perfil_users/1").to route_to("perfil_users#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/perfil_users/1").to route_to("perfil_users#destroy", id: "1")
    end
  end
end
