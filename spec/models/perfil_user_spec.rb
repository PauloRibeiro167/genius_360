require 'rails_helper'

RSpec.describe PerfilUser, type: :model do
  subject(:perfil_user) { build(:perfil_user) }

  describe "validações" do
      it { should belong_to(:user) }
        it { should belong_to(:perfil) }
    end

  describe "soft delete" do
    let(:perfil_user) { create(:perfil_user) }

    it "marca o registro como descartado" do
      expect { perfil_user.discard }.to change { perfil_user.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { perfil_user.discard }.not_to change(PerfilUser, :count)
    end

    it "exclui o registro do escopo padrão" do
      perfil_user.discard
      expect(PerfilUser.kept).not_to include(perfil_user)
    end

    it "inclui o registro no escopo discarded" do
      perfil_user.discard
      expect(PerfilUser.discarded).to include(perfil_user)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(PerfilUser.kept).to eq(PerfilUser.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(PerfilUser.discarded).to eq(PerfilUser.where.not(discarded_at: nil))
    end
  end
end