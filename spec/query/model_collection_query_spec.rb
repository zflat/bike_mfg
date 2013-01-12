require 'spec_helper'
require 'bike_mfg'

class String
  def blank?
    strip.length == 0
  end
  def present?
    !blank?
  end
end

module BikeMfg
  describe ModelCollectionQuery do

    describe "a stubbed scope" do
      
      before(:each) do
        @scope = double('scope', :where=>[])
        @scope.stub(:joins=>[])
        @term = "test"
        @q = ModelCollectionQuery.new(@term, :models=>@scope, :brands=>@scope)
      end

      it "should return with no results" do
        expect(@q.find_each).to_not be_nil
      end
    
    end
    
    describe "blank_h" do
      before :each do
        @brand = {:name => 'test'}
        @blank = ModelCollectionQuery.brand_h(@brand)
      end
      
      it "should have the initialzed name" do
        expect(@blank[:name]).to eq @brand[:name]
      end

      it "should have direct defalt value" do
        expect(@blank[:direct]).to be_true
      end

      it "should have default models empty array" do
        expect(@blank[:models]).to eq([])
      end

      describe "initialized with direct=false" do
        before :each do
          @direct = false
          @blank = ModelCollectionQuery.brand_h(@brand, @direct)
        end
        it "should have correct value for indirect" do
          expect(@blank[:direct]).to eq @direct
        end
      end

    end

  end

end
