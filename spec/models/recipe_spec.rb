# frozen_string_literal: true

require "rails_helper"

RSpec.describe Recipe, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:preperation_description) }
    it { is_expected.to validate_presence_of(:time_needed) }
    it { is_expected.to validate_presence_of(:difficulty) }
    it { should define_enum_for(:difficulty).with_values([:EASY, :MEDIUM, :HARD]) }
  end

  describe "associations" do
    it { should have_many(:comments) }
    it { should have_and_belong_to_many(:ingredients) }
  end
end
