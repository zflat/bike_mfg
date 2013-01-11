require 'spec_helper'

module BikeMfg
  describe ModelCollectionQuery do
    
    describe "blank_brand" do
      before :each do
        @brand = {:name => 'test'}
        @blank = ModelCollectionQuery.blank_brand.new(@brand)
      end
      
      it "should have the initialzed name" do
        expect(@blank.name).to eq @brand.name
      end

      it "should have defalt values" do
        expect(@blank.indirect).to be_false
      end

    end

  end

end
