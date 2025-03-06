require 'rails_helper'

RSpec.describe ContactMessage, type: :model do
  subject(:contact_message) { build(:contact_message) }

  describe "validações" do
          end

  describe "soft delete" do
    let(:contact_message) { create(:contact_message) }

    it "marca o registro como descartado" do
      expect { contact_message.discard }.to change { contact_message.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { contact_message.discard }.not_to change(ContactMessage, :count)
    end

    it "exclui o registro do escopo padrão" do
      contact_message.discard
      expect(ContactMessage.kept).not_to include(contact_message)
    end

    it "inclui o registro no escopo discarded" do
      contact_message.discard
      expect(ContactMessage.discarded).to include(contact_message)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(ContactMessage.kept).to eq(ContactMessage.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(ContactMessage.discarded).to eq(ContactMessage.where.not(discarded_at: nil))
    end
  end
end