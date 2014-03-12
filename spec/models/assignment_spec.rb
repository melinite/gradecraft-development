require 'spec_helper'

describe Assignment do
  before(:each) do
    @assignment = create(:assignment)
  end

  context "doesn't have a rubric" do
    it "should know it doesn't have a rubric" do
      expect(@assignment.has_rubric?).to eq false
    end
  end

  context "has a rubric" do
    it "should know it has a rubric" do
      allow(@assignment).to receive(:rubric).and_return true
      expect(@assignment.has_rubric?).to eq true
    end
  end
end
