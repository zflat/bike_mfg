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

end
