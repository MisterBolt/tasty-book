require "rails_helper"

RSpec.describe "recipes/_sort_form", type: :view do
  include Pagy::Backend

  context "when no kind nor order specified" do
    before { visit recipes_path }

    it { expect(page).to have_css("option[selected]", text: t("sort.by_title")) }
    it { expect(page).to have_css("option[selected]", text: t("sort.ascending")) }
  end

  context "when kind: title, order: ASC" do
    before { visit recipes_path(filters: {kind: "title", order: "ASC"}) }

    it { expect(page).to have_css("option[selected]", text: t("sort.by_title")) }
    it { expect(page).to have_css("option[selected]", text: t("sort.ascending")) }
    it { expect(page).not_to have_css("option[selected]", text: t("sort.descending")) }
  end

  context "when kind: score, order: DESC" do
    before { visit recipes_path(filters: {kind: "score", order: "DESC"}) }

    it { expect(page).to have_css("option[selected]", text: t("sort.by_score")) }
    it { expect(page).to have_css("option[selected]", text: t("sort.descending")) }
  end

  context "when kind: time_in_minutes_needed, order: DESC" do
    before { visit recipes_path(filters: {kind: "time_in_minutes_needed", order: "DESC"}) }

    it { expect(page).to have_css("option[selected]", text: t("sort.by_time")) }
    it { expect(page).to have_css("option[selected]", text: t("sort.descending")) }
  end

  context "when kind: difficulty" do
    before { visit recipes_path(filters: {kind: "difficulty"}) }

    it { expect(page).to have_css("option[selected]", text: t("sort.by_difficulty")) }
    it { expect(page).to have_css("option[selected]", text: t("sort.ascending")) }
  end
end
