FactoryBot.define do
  factory :follow do
    follower_id { create(:user).id }
    followed_user_id { create(:user).id }
  end
end
