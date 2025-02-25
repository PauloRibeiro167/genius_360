require 'rails_helper'

RSpec.describe Hierarquium, type: :model do
  subject(:hierarquium) { build(:hierarquium) }

  describe "validações" do
      end

  describe "soft delete" do
    let(:hierarquium) { create(:hierarquium) }

    it "marca o registro como descartado" do
      expect { hierarquium.discard }.to change { hierarquium.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { hierarquium.discard }.not_to change(Hierarquium, :count)
    end

    it "exclui o registro do escopo padrão" do
      hierarquium.discard
      expect(Hierarquium.kept).not_to include(hierarquium)
    end

    it "inclui o registro no escopo discarded" do
      hierarquium.discard
      expect(Hierarquium.discarded).to include(hierarquium)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Hierarquium.kept).to eq(Hierarquium.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Hierarquium.discarded).to eq(Hierarquium.where.not(discarded_at: nil))
    end
  end
end