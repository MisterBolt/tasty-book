# frozen_string_literal: true

require "rails_helper"

RSpec.describe Recipe, type: :model do
  it "is not valid without a title" do
    is_expected.to validate_presence_of(:title)
  end
end
