require 'spec_helper'

describe BikeBrand do

  describe "collection" do
    it "should have brands" do
      expect(BikeBrand.count>0).to be_true
    end

    it "should each have a name" do
      BikeBrand.all.each do |b|
        expect(b.name).to_not be_nil
      end
    end
  end

  describe "new brand with non-unique name" do
    it "should not be valid" do
      n = BikeBrand.all.first.name
      expect(n).to_not be_blank
      b = BikeBrand.new(:name => n)
      expect(b).to_not be_valid
    end
  end

  describe "new brand with blank name" do
    it "should not be valid" do
      b = BikeBrand.new(:name => '')
      expect(b).to_not be_valid
    end
  end

  describe "new brand with nil name" do
    it "should not be valid" do
      b = BikeBrand.new
      expect(b).to_not be_valid
    end
  end

end
