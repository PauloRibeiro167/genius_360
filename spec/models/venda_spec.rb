require 'rails_helper'

RSpec.describe Venda, type: :model do
  subject(:venda) { build(:venda) }

  describe "validações" do
      it { should belong_to(:lead) }
          end

  describe "soft delete" do
    let(:venda) { create(:venda) }

    it "marca o registro como descartado" do
      expect { venda.discard }.to change { venda.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { venda.discard }.not_to change(Venda, :count)
    end

    it "exclui o registro do escopo padrão" do
      venda.discard
      expect(Venda.kept).not_to include(venda)
    end

    it "inclui o registro no escopo discarded" do
      venda.discard
      expect(Venda.discarded).to include(venda)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Venda.kept).to eq(Venda.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Venda.discarded).to eq(Venda.where.not(discarded_at: nil))
    end
  end
end