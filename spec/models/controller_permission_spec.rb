require 'rails_helper'

RSpec.describe ControllerPermission, type: :model do
  subject(:controller_permission) { build(:controller_permission) }

  describe "validações" do
    end

  describe "soft delete" do
    let(:controller_permission) { create(:controller_permission) }

    it "marca o registro como descartado" do
      expect { controller_permission.discard }.to change { controller_permission.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { controller_permission.discard }.not_to change(ControllerPermission, :count)
    end

    it "exclui o registro do escopo padrão" do
      controller_permission.discard
      expect(ControllerPermission.kept).not_to include(controller_permission)
    end

    it "inclui o registro no escopo discarded" do
      controller_permission.discard
      expect(ControllerPermission.discarded).to include(controller_permission)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(ControllerPermission.kept).to eq(ControllerPermission.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(ControllerPermission.discarded).to eq(ControllerPermission.where.not(discarded_at: nil))
    end
  end
end