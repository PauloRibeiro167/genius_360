require 'rails_helper'

RSpec.describe Parceiro, type: :model do
  subject(:parceiro) { build(:parceiro) }

  describe "validações" do
      it { should belong_to(:usuario) }
        end

  describe "soft delete" do
    let(:parceiro) { create(:parceiro) }

    it "marca o registro como descartado" do
      expect { parceiro.discard }.to change { parceiro.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { parceiro.discard }.not_to change(Parceiro, :count)
    end

    it "exclui o registro do escopo padrão" do
      parceiro.discard
      expect(Parceiro.kept).not_to include(parceiro)
    end

    it "inclui o registro no escopo discarded" do
      parceiro.discard
      expect(Parceiro.discarded).to include(parceiro)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Parceiro.kept).to eq(Parceiro.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Parceiro.discarded).to eq(Parceiro.where.not(discarded_at: nil))
    end
  end
end