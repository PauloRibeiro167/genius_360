FactoryBot.define do
  factory :metum do
    usuario { nil }
    tipo_meta { "MyString" }
    valor_meta { "9.99" }
    data_inicio { "2025-02-25" }
    data_fim { "2025-02-25" }
    status { "MyString" }
  end
end
