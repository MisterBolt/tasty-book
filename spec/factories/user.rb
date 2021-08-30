FactoryBot.define do
  factory :user do |user|
    username { Faker::Name.unique.first_name }
    sequence(:email) { |n| "sample#{n}@email.com" }
    password { "password" }
    confirmed_at { Faker::Time.backward }

    after(:create) do |user, evaluator|
      create_list(:cook_book, 1, user: user, title: "Favourites", visibility: :private, favourite: true)
      user.reload
    end
  end
end
