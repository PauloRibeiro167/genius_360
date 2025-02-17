require 'rails_helper'

RSpec.describe ActionPermission, type: :model do
  subject(:action_permission) { build(:action_permission) }

  describe "validações" do
    end

  describe "soft delete" do
    let(:action_permission) { create(:action_permission) }

    it "marca o registro como descartado" do
      expect { action_permission.discard }.to change { action_permission.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { action_permission.discard }.not_to change(ActionPermission, :count)
    end

    it "exclui o registro do escopo padrão" do
      action_permission.discard
      expect(ActionPermission.kept).not_to include(action_permission)
    end

    it "inclui o registro no escopo discarded" do
      action_permission.discard
      expect(ActionPermission.discarded).to include(action_permission)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(ActionPermission.kept).to eq(ActionPermission.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(ActionPermission.discarded).to eq(ActionPermission.where.not(discarded_at: nil))
    end
  end
end