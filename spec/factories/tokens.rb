FactoryBot.define do
  factory :token do
    user { nil }
    token { "MyString" }
    expires_at { "2025-02-25 12:47:21" }
  end
end
