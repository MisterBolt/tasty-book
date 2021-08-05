FactoryBot.define do
  factory :ingredient do
    sequence :name do |s|
      "RandomString#{s}"
    end
  end
end
