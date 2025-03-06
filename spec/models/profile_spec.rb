require 'rails_helper'

RSpec.describe Profile, type: :model do
  subject(:profile) { build(:profile) }

  describe "validações" do
        end

  describe "soft delete" do
    let(:profile) { create(:profile) }

    it "marca o registro como descartado" do
      expect { profile.discard }.to change { profile.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { profile.discard }.not_to change(Profile, :count)
    end

    it "exclui o registro do escopo padrão" do
      profile.discard
      expect(Profile.kept).not_to include(profile)
    end

    it "inclui o registro no escopo discarded" do
      profile.discard
      expect(Profile.discarded).to include(profile)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Profile.kept).to eq(Profile.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Profile.discarded).to eq(Profile.where.not(discarded_at: nil))
    end
  end
end