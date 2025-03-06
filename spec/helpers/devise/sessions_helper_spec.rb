require 'rails_helper'

RSpec.describe Devise::SessionsHelper, type: :helper do
  let(:devise_session) { create(:devise_session) }
  
  describe "#devise_session_status_badge" do
    context "quando o registro está ativo" do
      it "retorna um badge verde com texto 'Ativo'" do
        expect(helper.devise_session_status_badge(devise_session)).to have_css(".badge.bg-success", text: "Ativo")
      end
    end

    context "quando o registro está inativo" do
      before { devise_session.discard }

      it "retorna um badge vermelho com texto 'Inativo'" do
        expect(helper.devise_session_status_badge(devise_session)).to have_css(".badge.bg-danger", text: "Inativo")
      end
    end
  end

  describe "#devise_session_actions" do
    it "inclui link para visualizar" do
      expect(helper.devise_session_actions(devise_session)).to have_css("a[href='#{devise_session_path(devise_session)}'] i.fa-eye")
    end

    it "inclui link para editar" do
      expect(helper.devise_session_actions(devise_session)).to have_css("a[href='#{edit_devise_session_path(devise_session)}'] i.fa-edit")
    end

    context "quando o registro está ativo" do
      it "inclui link para desativar" do
        expect(helper.devise_session_actions(devise_session)).to have_css("a[href='#{discard_devise_session_path(devise_session)}'] i.fa-trash-can")
      end
    end

    context "quando o registro está inativo" do
      before { devise_session.discard }

      it "inclui link para reativar" do
        expect(helper.devise_session_actions(devise_session)).to have_css("a[href='#{undiscard_devise_session_path(devise_session)}'] i.fa-trash-restore")
      end
    end
  end
end