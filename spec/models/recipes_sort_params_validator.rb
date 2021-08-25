# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecipesSortParamsValidator, type: :model do
  describe "validations" do
    it { should validate_numericality_of(:page).only_integer }
    it { should validate_numericality_of(:items).only_integer }
    it { is_expected.to validate_inclusion_of(:kind).in_array(["title", "difficulty", "time_in_minutes_needed", "score"]) }
    it { is_expected.to validate_inclusion_of(:order).in_array(["ASC", "DESC"]) }
  end
end
