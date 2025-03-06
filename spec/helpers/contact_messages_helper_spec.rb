require 'rails_helper'

RSpec.describe ContactMessagesHelper, type: :helper do
  let(:contact_message) { create(:contact_message) }
  
  describe "#contact_message_status_badge" do
    context "quando o registro está ativo" do
      it "retorna um badge verde com texto 'Ativo'" do
        expect(helper.contact_message_status_badge(contact_message)).to have_css(".badge.bg-success", text: "Ativo")
      end
    end

    context "quando o registro está inativo" do
      before { contact_message.discard }

      it "retorna um badge vermelho com texto 'Inativo'" do
        expect(helper.contact_message_status_badge(contact_message)).to have_css(".badge.bg-danger", text: "Inativo")
      end
    end
  end

  describe "#contact_message_actions" do
    it "inclui link para visualizar" do
      expect(helper.contact_message_actions(contact_message)).to have_css("a[href='#{contact_message_path(contact_message)}'] i.fa-eye")
    end

    it "inclui link para editar" do
      expect(helper.contact_message_actions(contact_message)).to have_css("a[href='#{edit_contact_message_path(contact_message)}'] i.fa-edit")
    end

    context "quando o registro está ativo" do
      it "inclui link para desativar" do
        expect(helper.contact_message_actions(contact_message)).to have_css("a[href='#{discard_contact_message_path(contact_message)}'] i.fa-trash-can")
      end
    end

    context "quando o registro está inativo" do
      before { contact_message.discard }

      it "inclui link para reativar" do
        expect(helper.contact_message_actions(contact_message)).to have_css("a[href='#{undiscard_contact_message_path(contact_message)}'] i.fa-trash-restore")
      end
    end
  end
end