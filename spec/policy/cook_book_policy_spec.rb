require "rails_helper"
require "pundit/rspec"

RSpec.describe CookBookPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "scope" do
    before do
      create(:follow, follower_id: user.id, followed_user_id: other_user.id)
      create(:cook_book, title: "TitleA", favourite: false, visibility: :public)
      create(:cook_book, title: "TitleB", favourite: false, visibility: :followers)
      create(:cook_book, title: "TitleC", favourite: false, visibility: :private)
      create(:cook_book, title: "TitleD", favourite: false, visibility: :followers, user: other_user)
      create(:cook_book, title: "TitleE", favourite: false, visibility: :private, user: other_user)
      create(:cook_book, title: "TitleF", favourite: false, visibility: :public, user: user)
      create(:cook_book, title: "TitleG", favourite: false, visibility: :followers, user: user)
      create(:cook_book, title: "TitleH", favourite: false, visibility: :private, user: user)
    end

    context "with user" do
      subject { Pundit.policy_scope!(user, CookBook).map { |cook_book| cook_book.title } }
      let(:titles) { ["Favourites", "TitleA", "TitleD", "TitleF", "TitleG", "TitleH"] }

      it { expect(subject).to match_array(titles) }
    end

    context "with guest" do
      subject { Pundit.policy_scope!(nil, CookBook).map { |cook_book| cook_book.title } }
      let(:titles) { ["TitleA", "TitleF"] }

      it { expect(subject).to match_array(titles) }
    end
  end

  permissions :destroy? do
    subject { CookBookPolicy }
    let(:user) { create(:user) }

    context "with user owning the cook book" do
      it { expect(subject).to permit(user, create(:cook_book, user: user)) }
    end

    context "with user and his 'favourite' cook book" do
      it { expect(subject).not_to permit(user, create(:cook_book, user: user, favourite: true)) }
    end

    context "with user not owning the cook book" do
      it { expect(subject).not_to permit(user, create(:cook_book)) }
    end

    context "with guest" do
      it { expect(subject).not_to permit(nil, create(:cook_book)) }
    end
  end
end
