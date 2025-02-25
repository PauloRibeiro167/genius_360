require 'rails_helper'

RSpec.describe Acompanhamento, type: :model do
  subject(:acompanhamento) { build(:acompanhamento) }

  describe "validações" do
      it { should belong_to(:lead) }
        end

  describe "soft delete" do
    let(:acompanhamento) { create(:acompanhamento) }

    it "marca o registro como descartado" do
      expect { acompanhamento.discard }.to change { acompanhamento.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { acompanhamento.discard }.not_to change(Acompanhamento, :count)
    end

    it "exclui o registro do escopo padrão" do
      acompanhamento.discard
      expect(Acompanhamento.kept).not_to include(acompanhamento)
    end

    it "inclui o registro no escopo discarded" do
      acompanhamento.discard
      expect(Acompanhamento.discarded).to include(acompanhamento)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Acompanhamento.kept).to eq(Acompanhamento.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Acompanhamento.discarded).to eq(Acompanhamento.where.not(discarded_at: nil))
    end
  end
end