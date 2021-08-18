require "rails_helper"

RSpec.describe ProfileHelper, type: :helper do
  describe "#dashboard_widths" do
    context "when all arguments equal 0" do
      subject { dashboard_widths(0, 0, 0) }

      it { expect(subject[:recipes]).to eq(0) }
      it { expect(subject[:recipe_drafts]).to eq(0) }
      it { expect(subject[:score]).to eq(0) }
      it { expect(subject[:score_complement]).to eq(0) }
    end

    context "when some arguments equal 0" do
      subject { dashboard_widths(0, 2, 4.0) }

      it { expect(subject[:recipes]).to eq(0) }
      it { expect(subject[:recipe_drafts]).to eq(100) }
      it { expect(subject[:score]).to eq(80) }
      it { expect(subject[:score_complement]).to eq(20) }
    end

    context "when all arguments are greater than 0" do
      subject { dashboard_widths(18, 2, 3.0) }

      it { expect(subject[:recipes]).to eq(90) }
      it { expect(subject[:recipe_drafts]).to eq(10) }
      it { expect(subject[:score]).to eq(60) }
      it { expect(subject[:score_complement]).to eq(40) }
    end
  end

  describe "#dashboard_bar_text" do
    let(:text) { "text" }

    it { expect(dashboard_bar_text(0, text)).to eq("") }
    it { expect(dashboard_bar_text(15, text)).to eq("") }
    it { expect(dashboard_bar_text(16, text)).to eq(text) }
    it { expect(dashboard_bar_text(100, text)).to eq(text) }
  end
end
