require 'rails_helper'

RSpec.describe Beneficio, type: :model do
  subject(:beneficio) { build(:beneficio) }

  describe "validações" do
        end

  describe "soft delete" do
    let(:beneficio) { create(:beneficio) }

    it "marca o registro como descartado" do
      expect { beneficio.discard }.to change { beneficio.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { beneficio.discard }.not_to change(Beneficio, :count)
    end

    it "exclui o registro do escopo padrão" do
      beneficio.discard
      expect(Beneficio.kept).not_to include(beneficio)
    end

    it "inclui o registro no escopo discarded" do
      beneficio.discard
      expect(Beneficio.discarded).to include(beneficio)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Beneficio.kept).to eq(Beneficio.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Beneficio.discarded).to eq(Beneficio.where.not(discarded_at: nil))
    end
  end
end