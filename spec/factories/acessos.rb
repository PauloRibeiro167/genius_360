FactoryBot.define do
  factory :acesso do
    usuario { nil }
    descricao { "MyString" }
    data_acesso { "2025-02-25 12:47:20" }
    ip { "MyString" }
    modelo_dispositivo { "MyString" }
  end
end
