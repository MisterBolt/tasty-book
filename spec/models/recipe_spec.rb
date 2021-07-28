# frozen_string_literal: true

require "rails_helper"

RSpec.describe Recipe, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe "associations" do
    it { should have_many(:comments) }
    it { should belong_to(:users) }
  end
end
