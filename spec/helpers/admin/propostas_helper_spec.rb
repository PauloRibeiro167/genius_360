require 'rails_helper'

RSpec.describe Admin::PropostasHelper, type: :helper do
  let(:admin_proposta) { create(:admin_proposta) }
  
  describe "#admin_proposta_status_badge" do
    context "quando o registro está ativo" do
      it "retorna um badge verde com texto 'Ativo'" do
        expect(helper.admin_proposta_status_badge(admin_proposta)).to have_css(".badge.bg-success", text: "Ativo")
      end
    end

    context "quando o registro está inativo" do
      before { admin_proposta.discard }

      it "retorna um badge vermelho com texto 'Inativo'" do
        expect(helper.admin_proposta_status_badge(admin_proposta)).to have_css(".badge.bg-danger", text: "Inativo")
      end
    end
  end

  describe "#admin_proposta_actions" do
    it "inclui link para visualizar" do
      expect(helper.admin_proposta_actions(admin_proposta)).to have_css("a[href='#{admin_proposta_path(admin_proposta)}'] i.fa-eye")
    end

    it "inclui link para editar" do
      expect(helper.admin_proposta_actions(admin_proposta)).to have_css("a[href='#{edit_admin_proposta_path(admin_proposta)}'] i.fa-edit")
    end

    context "quando o registro está ativo" do
      it "inclui link para desativar" do
        expect(helper.admin_proposta_actions(admin_proposta)).to have_css("a[href='#{discard_admin_proposta_path(admin_proposta)}'] i.fa-trash-can")
      end
    end

    context "quando o registro está inativo" do
      before { admin_proposta.discard }

      it "inclui link para reativar" do
        expect(helper.admin_proposta_actions(admin_proposta)).to have_css("a[href='#{undiscard_admin_proposta_path(admin_proposta)}'] i.fa-trash-restore")
      end
    end
  end
end