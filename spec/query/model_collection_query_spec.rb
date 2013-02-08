require 'spec_helper'
require 'bike_mfg'

module BikeMfg
  
  describe ModelCollectionQuery do

    describe "with scope BikeModel BikeBrand" do
      before(:each) do
        @scope_model = BikeModel
        @scope_brand = BikeBrand
      end

      describe "given an empty search" do
        it "should return with empty results" do
          term = ''
          q = ModelCollectionQuery.new(term, :models=>@scope_model, :brands=>@scope_brand)
          expect(q.find_each).to_not be_nil
        end
      end

      describe "on a search for known model with known brand" do
        before :all do
          @model = BikeModel.where{bike_brand_id != nil}.first
          @term = @model.name
          @q = ModelCollectionQuery.new(@term, :models=>@scope_model, :brands=>@scope_brand)
        end
        it "should match the model" do
          expect(@q.find_each).to_not be_nil
          expect(@q.find_each.include?(@model.brand.id, @model)).to be_true
        end
      end

      describe "on a search for known model but unknown brand" do
        before :all do
          @model = BikeModel.where{bike_brand_id == nil}.first
          @term = @model.name
          @q = ModelCollectionQuery.new(@term, :models=>@scope_model, :brands=>@scope_brand)
        end
        it "should match the model" do
          expect(@q.find_each).to_not be_nil
          expect(@q.find_each.include?(nil, @model)).to be_true
        end
        
        it "to_h should list an unknown brand" do
          unknown_present = false
          h = @q.find_each.to_h
          h.each do |key, brand|
            if brand[:id].nil?
              unknown_present = true
            end
          end
          expect(unknown_present).to be_true
        end

        it "to_a should list an unknown brand" do
          a = @q.find_each.to_a
          a.each do |b|
            expect(b).to_not be_nil
          end
        end

      end # describe "on a search for known model but unknown brand" 

      context "on a known brand that has no models" do
        before :all do
          @term = "zxyBrand"
          @brand_without_models = BikeBrand.new(:name => "#{@term} #{BikeBrand.count}")
          @brand_without_models.save

          @q = ModelCollectionQuery.new(@term, :models=>@scope_model, :brands=>@scope_brand)
        end

        it "should have results" do
          h = @q.find_each.to_h
          expect(h).to_not be_empty
        end

        it "should find the brand" do
          h = @q.find_each.to_h
          expect(h.keys.include? @brand_without_models.id).to be_true
        end

      end # context "on a known brand that has no models" do

    end # describe "with scope BikeModel BikeBrand"
    
    describe "blank_h" do
      before :each do
        @brand = {:name => 'test'}
        @blank = ModelCollectionQuery::ResultsCollection::ResultBrand::brand_h(@brand)
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
          @blank = ModelCollectionQuery::ResultsCollection::ResultBrand::brand_h(@brand, @direct)
        end
        it "should have correct value for indirect" do
          expect(@blank[:direct]).to eq @direct
        end
      end

    end

  end

end
