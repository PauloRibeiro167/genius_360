require 'rails_helper'

RSpec.describe Acesso, type: :model do
  subject(:acesso) { build(:acesso) }

  describe "validações" do
      it { should belong_to(:usuario) }
            end

  describe "soft delete" do
    let(:acesso) { create(:acesso) }

    it "marca o registro como descartado" do
      expect { acesso.discard }.to change { acesso.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { acesso.discard }.not_to change(Acesso, :count)
    end

    it "exclui o registro do escopo padrão" do
      acesso.discard
      expect(Acesso.kept).not_to include(acesso)
    end

    it "inclui o registro no escopo discarded" do
      acesso.discard
      expect(Acesso.discarded).to include(acesso)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Acesso.kept).to eq(Acesso.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Acesso.discarded).to eq(Acesso.where.not(discarded_at: nil))
    end
  end
end