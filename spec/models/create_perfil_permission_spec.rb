require 'rails_helper'

RSpec.describe CreatePerfilPermission, type: :model do
  subject(:create_perfil_permission) { build(:create_perfil_permission) }

  describe "validações" do
      it { should belong_to(:perfil) }
        it { should belong_to(:permission) }
    end

  describe "soft delete" do
    let(:create_perfil_permission) { create(:create_perfil_permission) }

    it "marca o registro como descartado" do
      expect { create_perfil_permission.discard }.to change { create_perfil_permission.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { create_perfil_permission.discard }.not_to change(CreatePerfilPermission, :count)
    end

    it "exclui o registro do escopo padrão" do
      create_perfil_permission.discard
      expect(CreatePerfilPermission.kept).not_to include(create_perfil_permission)
    end

    it "inclui o registro no escopo discarded" do
      create_perfil_permission.discard
      expect(CreatePerfilPermission.discarded).to include(create_perfil_permission)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(CreatePerfilPermission.kept).to eq(CreatePerfilPermission.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(CreatePerfilPermission.discarded).to eq(CreatePerfilPermission.where.not(discarded_at: nil))
    end
  end
end