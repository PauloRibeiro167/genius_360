require 'rails_helper'

RSpec.describe Token, type: :model do
  subject(:token) { build(:token) }

  describe "validações" do
      it { should belong_to(:user) }
        end

  describe "soft delete" do
    let(:token) { create(:token) }

    it "marca o registro como descartado" do
      expect { token.discard }.to change { token.discarded? }.from(false).to(true)
    end

    it "mantém o registro no banco de dados" do
      expect { token.discard }.not_to change(Token, :count)
    end

    it "exclui o registro do escopo padrão" do
      token.discard
      expect(Token.kept).not_to include(token)
    end

    it "inclui o registro no escopo discarded" do
      token.discard
      expect(Token.discarded).to include(token)
    end
  end

  describe "scopes" do
    it "tem um escopo kept para registros ativos" do
      expect(Token.kept).to eq(Token.where(discarded_at: nil))
    end

    it "tem um escopo discarded para registros inativos" do
      expect(Token.discarded).to eq(Token.where.not(discarded_at: nil))
    end
  end
end