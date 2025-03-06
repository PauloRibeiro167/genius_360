require 'rails_helper'

RSpec.describe PerfilsHelper, type: :helper do
  let(:perfil) { create(:perfil) }
  
  describe "#perfil_status_badge" do
    context "quando o registro está ativo" do
      it "retorna um badge verde com texto 'Ativo'" do
        expect(helper.perfil_status_badge(perfil)).to have_css(".badge.bg-success", text: "Ativo")
      end
    end

    context "quando o registro está inativo" do
      before { perfil.discard }

      it "retorna um badge vermelho com texto 'Inativo'" do
        expect(helper.perfil_status_badge(perfil)).to have_css(".badge.bg-danger", text: "Inativo")
      end
    end
  end

  describe "#perfil_actions" do
    it "inclui link para visualizar" do
      expect(helper.perfil_actions(perfil)).to have_css("a[href='#{perfil_path(perfil)}'] i.fa-eye")
    end

    it "inclui link para editar" do
      expect(helper.perfil_actions(perfil)).to have_css("a[href='#{edit_perfil_path(perfil)}'] i.fa-edit")
    end

    context "quando o registro está ativo" do
      it "inclui link para desativar" do
        expect(helper.perfil_actions(perfil)).to have_css("a[href='#{discard_perfil_path(perfil)}'] i.fa-trash-can")
      end
    end

    context "quando o registro está inativo" do
      before { perfil.discard }

      it "inclui link para reativar" do
        expect(helper.perfil_actions(perfil)).to have_css("a[href='#{undiscard_perfil_path(perfil)}'] i.fa-trash-restore")
      end
    end
  end
end