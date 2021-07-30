# frozen_string_literal: true

require "rails_helper"

RSpec.describe Recipe, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe "associations" do
    it { should have_many(:comments) }
    it { should have_and_belong_to_many(:cook_books) }
  end
end
