require 'spec_helper'

describe BikeModel do

  describe "collection" do
    it "should have models" do
      expect(BikeModel.count>0).to be_true
    end
  end

end
