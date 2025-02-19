require "rails_helper"

RSpec.describe ContactMessagesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/contact_messages").to route_to("contact_messages#index")
    end

    it "routes to #new" do
      expect(get: "/contact_messages/new").to route_to("contact_messages#new")
    end

    it "routes to #show" do
      expect(get: "/contact_messages/1").to route_to("contact_messages#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/contact_messages/1/edit").to route_to("contact_messages#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/contact_messages").to route_to("contact_messages#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/contact_messages/1").to route_to("contact_messages#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/contact_messages/1").to route_to("contact_messages#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/contact_messages/1").to route_to("contact_messages#destroy", id: "1")
    end
  end
end
