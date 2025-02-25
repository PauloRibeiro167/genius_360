FactoryBot.define do
  factory :banco do
    numero_identificador { "MyString" }
    nome { "MyString" }
    descricao { "MyText" }
    regras_gerais { "MyText" }
    descartado_em { "2025-02-25 12:47:18" }
  end
end
