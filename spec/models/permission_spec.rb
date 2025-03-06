require 'rails_helper'

RSpec.describe Permission, type: :model do
  subject(:permission) { build(:permission) }

  describe "validações" do
    end

  describe "soft delete" do
    let(:permission) { create(:permission) }

    it "marca o registro como descartado" do
      expect { permission.discard }.to change { permission.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { permission.discard }.not_to change(Permission, :count)
    end

    it "exclui o registro do escopo padrão" do
      permission.discard
      expect(Permission.kept).not_to include(permission)
    end

    it "inclui o registro no escopo discarded" do
      permission.discard
      expect(Permission.discarded).to include(permission)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Permission.kept).to eq(Permission.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Permission.discarded).to eq(Permission.where.not(discarded_at: nil))
    end
  end
end