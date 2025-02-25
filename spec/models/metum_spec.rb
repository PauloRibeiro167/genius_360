require 'rails_helper'

RSpec.describe Metum, type: :model do
  subject(:metum) { build(:metum) }

  describe "validações" do
      it { should belong_to(:usuario) }
              end

  describe "soft delete" do
    let(:metum) { create(:metum) }

    it "marca o registro como descartado" do
      expect { metum.discard }.to change { metum.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { metum.discard }.not_to change(Metum, :count)
    end

    it "exclui o registro do escopo padrão" do
      metum.discard
      expect(Metum.kept).not_to include(metum)
    end

    it "inclui o registro no escopo discarded" do
      metum.discard
      expect(Metum.discarded).to include(metum)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Metum.kept).to eq(Metum.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Metum.discarded).to eq(Metum.where.not(discarded_at: nil))
    end
  end
end