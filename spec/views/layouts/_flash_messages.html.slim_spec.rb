require "rails_helper"

RSpec.describe "layouts/_flash_messages", type: :view do
  context "when flash message type is notice" do
    before do
      flash.notice = "Success"
      render
    end

    it "displays green notice" do
      expect(rendered).to match(/flash-success/)
    end
  end

  context "when flash message type is alert" do
    before do
      flash.alert = "Error"
      render
    end

    it "displays red alert" do
      expect(rendered).to match(/flash-error/)
    end
  end
end
