FactoryBot.define do
  factory :usuario do
    nome { "MyString" }
    email { "MyString" }
    encrypted_password { "MyString" }
    reset_password_token { "MyString" }
    reset_password_sent_at { "2025-02-25 12:47:19" }
    remember_created_at { "2025-02-25 12:47:19" }
    sign_in_count { 1 }
    current_sign_in_at { "2025-02-25 12:47:19" }
    last_sign_in_at { "2025-02-25 12:47:19" }
    current_sign_in_ip { "MyString" }
    last_sign_in_ip { "MyString" }
    cpf_encrypted { "MyString" }
    discarded_at { "2025-02-25 12:47:19" }
    tipo { "MyString" }
    perfil { nil }
    hierarquia { nil }
  end
end
