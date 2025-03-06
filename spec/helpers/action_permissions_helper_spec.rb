require 'rails_helper'

RSpec.describe ActionPermissionsHelper, type: :helper do
  let(:action_permission) { create(:action_permission) }
  
  describe "#action_permission_status_badge" do
    context "quando o registro está ativo" do
      it "retorna um badge verde com texto 'Ativo'" do
        expect(helper.action_permission_status_badge(action_permission)).to have_css(".badge.bg-success", text: "Ativo")
      end
    end

    context "quando o registro está inativo" do
      before { action_permission.discard }

      it "retorna um badge vermelho com texto 'Inativo'" do
        expect(helper.action_permission_status_badge(action_permission)).to have_css(".badge.bg-danger", text: "Inativo")
      end
    end
  end

  describe "#action_permission_actions" do
    it "inclui link para visualizar" do
      expect(helper.action_permission_actions(action_permission)).to have_css("a[href='#{action_permission_path(action_permission)}'] i.fa-eye")
    end

    it "inclui link para editar" do
      expect(helper.action_permission_actions(action_permission)).to have_css("a[href='#{edit_action_permission_path(action_permission)}'] i.fa-edit")
    end

    context "quando o registro está ativo" do
      it "inclui link para desativar" do
        expect(helper.action_permission_actions(action_permission)).to have_css("a[href='#{discard_action_permission_path(action_permission)}'] i.fa-trash-can")
      end
    end

    context "quando o registro está inativo" do
      before { action_permission.discard }

      it "inclui link para reativar" do
        expect(helper.action_permission_actions(action_permission)).to have_css("a[href='#{undiscard_action_permission_path(action_permission)}'] i.fa-trash-restore")
      end
    end
  end
end