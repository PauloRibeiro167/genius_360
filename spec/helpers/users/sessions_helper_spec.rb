require 'rails_helper'

RSpec.describe Users::SessionsHelper, type: :helper do
  let(:users_session) { create(:users_session) }
  
  describe "#users_session_status_badge" do
    context "quando o registro está ativo" do
      it "retorna um badge verde com texto 'Ativo'" do
        expect(helper.users_session_status_badge(users_session)).to have_css(".badge.bg-success", text: "Ativo")
      end
    end

    context "quando o registro está inativo" do
      before { users_session.discard }

      it "retorna um badge vermelho com texto 'Inativo'" do
        expect(helper.users_session_status_badge(users_session)).to have_css(".badge.bg-danger", text: "Inativo")
      end
    end
  end

  describe "#users_session_actions" do
    it "inclui link para visualizar" do
      expect(helper.users_session_actions(users_session)).to have_css("a[href='#{users_session_path(users_session)}'] i.fa-eye")
    end

    it "inclui link para editar" do
      expect(helper.users_session_actions(users_session)).to have_css("a[href='#{edit_users_session_path(users_session)}'] i.fa-edit")
    end

    context "quando o registro está ativo" do
      it "inclui link para desativar" do
        expect(helper.users_session_actions(users_session)).to have_css("a[href='#{discard_users_session_path(users_session)}'] i.fa-trash-can")
      end
    end

    context "quando o registro está inativo" do
      before { users_session.discard }

      it "inclui link para reativar" do
        expect(helper.users_session_actions(users_session)).to have_css("a[href='#{undiscard_users_session_path(users_session)}'] i.fa-trash-restore")
      end
    end
  end
end