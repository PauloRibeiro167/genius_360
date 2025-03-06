FactoryBot.define do
  factory :message do
    content { "MyText" }
    user { nil }
    recipient { nil }
    read { false }
  end
end
