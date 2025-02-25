require 'rails_helper'

RSpec.describe Propostum, type: :model do
  subject(:propostum) { build(:propostum) }

  describe "validações" do
      end

  describe "soft delete" do
    let(:propostum) { create(:propostum) }

    it "marca o registro como descartado" do
      expect { propostum.discard }.to change { propostum.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { propostum.discard }.not_to change(Propostum, :count)
    end

    it "exclui o registro do escopo padrão" do
      propostum.discard
      expect(Propostum.kept).not_to include(propostum)
    end

    it "inclui o registro no escopo discarded" do
      propostum.discard
      expect(Propostum.discarded).to include(propostum)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Propostum.kept).to eq(Propostum.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Propostum.discarded).to eq(Propostum.where.not(discarded_at: nil))
    end
  end
end