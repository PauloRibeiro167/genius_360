require 'rails_helper'

RSpec.describe Message, type: :model do
  subject(:message) { build(:message) }

  describe "validações" do
        it { should belong_to(:user) }
        it { should belong_to(:recipient) }
      end

  describe "soft delete" do
    let(:message) { create(:message) }

    it "marca o registro como descartado" do
      expect { message.discard }.to change { message.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { message.discard }.not_to change(Message, :count)
    end

    it "exclui o registro do escopo padrão" do
      message.discard
      expect(Message.kept).not_to include(message)
    end

    it "inclui o registro no escopo discarded" do
      message.discard
      expect(Message.discarded).to include(message)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Message.kept).to eq(Message.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Message.discarded).to eq(Message.where.not(discarded_at: nil))
    end
  end
end