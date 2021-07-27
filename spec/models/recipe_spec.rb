# frozen_string_literal: true

require "rails_helper"

RSpec.describe Recipe, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:how_to_prepare) }
    it { is_expected.to validate_presence_of(:time_needed) }
    it { is_expected.to validate_presence_of(:difficulty) }
  end

  describe "associations" do
    it { should have_many(:comments) }
    it { should have_and_belong_to_many(:ingredients) }
  end
end
