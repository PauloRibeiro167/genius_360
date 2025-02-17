require 'rails_helper'

RSpec.describe CreatePerfilPermissionsHelper, type: :helper do
  let(:create_perfil_permission) { create(:create_perfil_permission) }
  
  describe "#create_perfil_permission_status_badge" do
    context "quando o registro está ativo" do
      it "retorna um badge verde com texto 'Ativo'" do
        expect(helper.create_perfil_permission_status_badge(create_perfil_permission)).to have_css(".badge.bg-success", text: "Ativo")
      end
    end

    context "quando o registro está inativo" do
      before { create_perfil_permission.discard }

      it "retorna um badge vermelho com texto 'Inativo'" do
        expect(helper.create_perfil_permission_status_badge(create_perfil_permission)).to have_css(".badge.bg-danger", text: "Inativo")
      end
    end
  end

  describe "#create_perfil_permission_actions" do
    it "inclui link para visualizar" do
      expect(helper.create_perfil_permission_actions(create_perfil_permission)).to have_css("a[href='#{create_perfil_permission_path(create_perfil_permission)}'] i.fa-eye")
    end

    it "inclui link para editar" do
      expect(helper.create_perfil_permission_actions(create_perfil_permission)).to have_css("a[href='#{edit_create_perfil_permission_path(create_perfil_permission)}'] i.fa-edit")
    end

    context "quando o registro está ativo" do
      it "inclui link para desativar" do
        expect(helper.create_perfil_permission_actions(create_perfil_permission)).to have_css("a[href='#{discard_create_perfil_permission_path(create_perfil_permission)}'] i.fa-trash-can")
      end
    end

    context "quando o registro está inativo" do
      before { create_perfil_permission.discard }

      it "inclui link para reativar" do
        expect(helper.create_perfil_permission_actions(create_perfil_permission)).to have_css("a[href='#{undiscard_create_perfil_permission_path(create_perfil_permission)}'] i.fa-trash-restore")
      end
    end
  end
end