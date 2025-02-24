require 'rails_helper'

RSpec.describe PerfilUsersHelper, type: :helper do
  let(:perfil_user) { create(:perfil_user) }
  
  describe "#perfil_user_status_badge" do
    context "quando o registro está ativo" do
      it "retorna um badge verde com texto 'Ativo'" do
        expect(helper.perfil_user_status_badge(perfil_user)).to have_css(".badge.bg-success", text: "Ativo")
      end
    end

    context "quando o registro está inativo" do
      before { perfil_user.discard }

      it "retorna um badge vermelho com texto 'Inativo'" do
        expect(helper.perfil_user_status_badge(perfil_user)).to have_css(".badge.bg-danger", text: "Inativo")
      end
    end
  end

  describe "#perfil_user_actions" do
    it "inclui link para visualizar" do
      expect(helper.perfil_user_actions(perfil_user)).to have_css("a[href='#{perfil_user_path(perfil_user)}'] i.fa-eye")
    end

    it "inclui link para editar" do
      expect(helper.perfil_user_actions(perfil_user)).to have_css("a[href='#{edit_perfil_user_path(perfil_user)}'] i.fa-edit")
    end

    context "quando o registro está ativo" do
      it "inclui link para desativar" do
        expect(helper.perfil_user_actions(perfil_user)).to have_css("a[href='#{discard_perfil_user_path(perfil_user)}'] i.fa-trash-can")
      end
    end

    context "quando o registro está inativo" do
      before { perfil_user.discard }

      it "inclui link para reativar" do
        expect(helper.perfil_user_actions(perfil_user)).to have_css("a[href='#{undiscard_perfil_user_path(perfil_user)}'] i.fa-trash-restore")
      end
    end
  end
end