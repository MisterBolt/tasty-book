FactoryBot.define do
  factory :user do
    username { "John Doe" }
    email { "john.doe@example.com" }
    password { "password" }
  end
end
