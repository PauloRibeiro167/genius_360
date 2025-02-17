require 'rails_helper'

RSpec.describe PermissionsHelper, type: :helper do
  let(:permission) { create(:permission) }
  
  describe "#permission_status_badge" do
    context "quando o registro está ativo" do
      it "retorna um badge verde com texto 'Ativo'" do
        expect(helper.permission_status_badge(permission)).to have_css(".badge.bg-success", text: "Ativo")
      end
    end

    context "quando o registro está inativo" do
      before { permission.discard }

      it "retorna um badge vermelho com texto 'Inativo'" do
        expect(helper.permission_status_badge(permission)).to have_css(".badge.bg-danger", text: "Inativo")
      end
    end
  end

  describe "#permission_actions" do
    it "inclui link para visualizar" do
      expect(helper.permission_actions(permission)).to have_css("a[href='#{permission_path(permission)}'] i.fa-eye")
    end

    it "inclui link para editar" do
      expect(helper.permission_actions(permission)).to have_css("a[href='#{edit_permission_path(permission)}'] i.fa-edit")
    end

    context "quando o registro está ativo" do
      it "inclui link para desativar" do
        expect(helper.permission_actions(permission)).to have_css("a[href='#{discard_permission_path(permission)}'] i.fa-trash-can")
      end
    end

    context "quando o registro está inativo" do
      before { permission.discard }

      it "inclui link para reativar" do
        expect(helper.permission_actions(permission)).to have_css("a[href='#{undiscard_permission_path(permission)}'] i.fa-trash-restore")
      end
    end
  end
end