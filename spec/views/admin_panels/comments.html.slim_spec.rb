require "rails_helper"

RSpec.describe "admin_panels/comments", type: :view do
  let(:user) { create(:user, admin: false) }
  let(:admin) { create(:user, admin: true) }

  context "when user is not signed in" do
    before { visit profile_index_path }

    it { expect(current_path).to eql(new_user_session_path) }
  end

  context "when regular user is logged in" do
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit comments_admin_panel_path
    end

    it { expect(current_path).to eql(recipes_path) }
  end

  context "when admin is logged in and there are no comments" do
    before do
      assign(:comments, Comment.awaiting)
      sign_in admin
      render
    end

    it { expect(rendered).to have_tag("#no_comments_left", class: "block") }
    it { expect(rendered).to have_tag("div#awaiting_comment_number", text: 0) }
    it { expect(rendered).not_to have_tag("div.unique_comment") }
    it { expect(rendered).not_to have_tag("a.accept_comment") }
    it { expect(rendered).not_to have_tag("a.reject_comment") }
  end

  context "when admin is logged in and there are 6 awaiting comments" do
    before do
      create_list(:comment, 6, status: :awaiting)
      create_list(:comment, 4, status: :approved)
      create_list(:comment, 2, status: :rejected)
      assign(:comments, Comment.awaiting)
      sign_in admin
      render
    end

    it { expect(rendered).to have_tag("#no_comments_left", class: "hidden") }
    it { expect(rendered).to have_tag("div#awaiting_comment_number", text: 6) }
    it { expect(rendered).to have_tag("div.unique_comment", count: 6) }
    it { expect(rendered).to have_tag("a.accept_comment", count: 6) }
    it { expect(rendered).to have_tag("a.reject_comment", count: 6) }
  end
end
