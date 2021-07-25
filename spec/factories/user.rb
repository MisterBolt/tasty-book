FactoryBot.define do
  factory :user do
    username { Faker::Name.unique.first_name }
    email { Faker::Internet.safe_email }
    password { 'password' } 
  end
end
