FactoryBot.define do
  sequence :name do |s|
    "RandomString#{s}"
  end

  factory :ingredient do
    name
  end
end
