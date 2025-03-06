require 'rails_helper'

RSpec.describe Usuario, type: :model do
  subject(:usuario) { build(:usuario) }

  describe "validações" do
                                  it { should belong_to(:perfil) }
        it { should belong_to(:hierarquia) }
    end

  describe "soft delete" do
    let(:usuario) { create(:usuario) }

    it "marca o registro como descartado" do
      expect { usuario.discard }.to change { usuario.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { usuario.discard }.not_to change(Usuario, :count)
    end

    it "exclui o registro do escopo padrão" do
      usuario.discard
      expect(Usuario.kept).not_to include(usuario)
    end

    it "inclui o registro no escopo discarded" do
      usuario.discard
      expect(Usuario.discarded).to include(usuario)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Usuario.kept).to eq(Usuario.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Usuario.discarded).to eq(Usuario.where.not(discarded_at: nil))
    end
  end
end