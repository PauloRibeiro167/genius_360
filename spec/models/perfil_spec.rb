require 'rails_helper'

RSpec.describe Perfil, type: :model do
  subject(:perfil) { build(:perfil) }

  describe "validações" do
    end

  describe "soft delete" do
    let(:perfil) { create(:perfil) }

    it "marca o registro como descartado" do
      expect { perfil.discard }.to change { perfil.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { perfil.discard }.not_to change(Perfil, :count)
    end

    it "exclui o registro do escopo padrão" do
      perfil.discard
      expect(Perfil.kept).not_to include(perfil)
    end

    it "inclui o registro no escopo discarded" do
      perfil.discard
      expect(Perfil.discarded).to include(perfil)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Perfil.kept).to eq(Perfil.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Perfil.discarded).to eq(Perfil.where.not(discarded_at: nil))
    end
  end
end