require 'rails_helper'

RSpec.describe ProgressoVenda, type: :model do
  subject(:progresso_venda) { build(:progresso_venda) }

  describe "validações" do
      it { should belong_to(:usuario) }
        end

  describe "soft delete" do
    let(:progresso_venda) { create(:progresso_venda) }

    it "marca o registro como descartado" do
      expect { progresso_venda.discard }.to change { progresso_venda.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { progresso_venda.discard }.not_to change(ProgressoVenda, :count)
    end

    it "exclui o registro do escopo padrão" do
      progresso_venda.discard
      expect(ProgressoVenda.kept).not_to include(progresso_venda)
    end

    it "inclui o registro no escopo discarded" do
      progresso_venda.discard
      expect(ProgressoVenda.discarded).to include(progresso_venda)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(ProgressoVenda.kept).to eq(ProgressoVenda.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(ProgressoVenda.discarded).to eq(ProgressoVenda.where.not(discarded_at: nil))
    end
  end
end