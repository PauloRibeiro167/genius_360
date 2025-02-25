require 'rails_helper'

RSpec.describe Banco, type: :model do
  subject(:banco) { build(:banco) }

  describe "validações" do
            end

  describe "soft delete" do
    let(:banco) { create(:banco) }

    it "marca o registro como descartado" do
      expect { banco.discard }.to change { banco.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { banco.discard }.not_to change(Banco, :count)
    end

    it "exclui o registro do escopo padrão" do
      banco.discard
      expect(Banco.kept).not_to include(banco)
    end

    it "inclui o registro no escopo discarded" do
      banco.discard
      expect(Banco.discarded).to include(banco)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Banco.kept).to eq(Banco.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Banco.discarded).to eq(Banco.where.not(discarded_at: nil))
    end
  end
end