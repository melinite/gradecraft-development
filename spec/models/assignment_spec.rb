require 'spec_helper'

describe Assignment do
  before(:each) do
    @assignment = create(:assignment)
  end

  context "doesn't have a rubric" do
    it "should know it doesn't have a rubric" do
      @assignment.has_rubric?.should be_false
    end
  end

  context "has a rubric" do
    it "should know it has a rubric" do
      @assignment.has_rubric?.should be_true
    end
  end
end
