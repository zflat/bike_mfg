require 'spec_helper'

describe BikeModel do

  describe "collection" do
    it "should have models" do
      expect(BikeModel.count>0).to be_true
    end
  end

  describe "new model with blank name" do
    it "should be valid" do
      m = BikeModel.new(:name => '')
      expect(m).to be_valid
    end
  end

  describe "new model with no brand" do
    it "should be valid" do
      m = BikeModel.new(:name => 'model name')
      expect(m).to be_valid
    end
  end

end
