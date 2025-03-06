require 'rails_helper'

RSpec.describe ControllerPermissionsHelper, type: :helper do
  let(:controller_permission) { create(:controller_permission) }
  
  describe "#controller_permission_status_badge" do
    context "quando o registro está ativo" do
      it "retorna um badge verde com texto 'Ativo'" do
        expect(helper.controller_permission_status_badge(controller_permission)).to have_css(".badge.bg-success", text: "Ativo")
      end
    end

    context "quando o registro está inativo" do
      before { controller_permission.discard }

      it "retorna um badge vermelho com texto 'Inativo'" do
        expect(helper.controller_permission_status_badge(controller_permission)).to have_css(".badge.bg-danger", text: "Inativo")
      end
    end
  end

  describe "#controller_permission_actions" do
    it "inclui link para visualizar" do
      expect(helper.controller_permission_actions(controller_permission)).to have_css("a[href='#{controller_permission_path(controller_permission)}'] i.fa-eye")
    end

    it "inclui link para editar" do
      expect(helper.controller_permission_actions(controller_permission)).to have_css("a[href='#{edit_controller_permission_path(controller_permission)}'] i.fa-edit")
    end

    context "quando o registro está ativo" do
      it "inclui link para desativar" do
        expect(helper.controller_permission_actions(controller_permission)).to have_css("a[href='#{discard_controller_permission_path(controller_permission)}'] i.fa-trash-can")
      end
    end

    context "quando o registro está inativo" do
      before { controller_permission.discard }

      it "inclui link para reativar" do
        expect(helper.controller_permission_actions(controller_permission)).to have_css("a[href='#{undiscard_controller_permission_path(controller_permission)}'] i.fa-trash-restore")
      end
    end
  end
end