require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "validações" do
  end

  describe "soft delete" do
    let(:user) { create(:user) }

    it "marca o registro como descartado" do
      expect { user.discard }.to change { user.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { user.discard }.not_to change(User, :count)
    end

    it "exclui o registro do escopo padrão" do
      user.discard
      expect(User.kept).not_to include(user)
    end

    it "inclui o registro no escopo discarded" do
      user.discard
      expect(User.discarded).to include(user)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(User.kept).to eq(User.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(User.discarded).to eq(User.where.not(discarded_at: nil))
    end
  end
end