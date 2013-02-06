require 'spec_helper'
require 'bike_mfg'

module BikeMfg
  
  describe NameQuery do
    
    before :all do
      @scope = BikeBrand
    end

    describe "searching brands" do

      it "should find a known brand" do
        brand = BikeBrand.all.first
        expect(brand).to_not be_nil
        term = brand.name
        r = NameQuery.new(term, @scope, :bike_models).find_each
        expect(r).to_not be_nil
        expect(r.include?(brand)).to be_true
      end

      it "should have empty results for empty query" do
        r = NameQuery.new('', @scope, :bike_models).find_each
        expect(r).to_not be_nil
        expect(r).to be_empty
      end

      it "should have empty results for nil query" do
        r = NameQuery.new(nil, @scope, :bike_models).find_each
        expect(r).to_not be_nil
        expect(r).to be_empty
      end

      it "should have empty results for unknown query" do
        r = NameQuery.new('zZ'*9, @scope, :bike_models).find_each
        expect(r).to_not be_nil
        expect(r).to be_empty
      end
    end # searching brands

    describe "searching models" do
      before :all do
        @scope = BikeModel
      end

      it "should find a known model" do
        model = @scope.all.first
        expect(model).to_not be_nil
        term = model.name
        r = NameQuery.new(term, @scope, :bike_brand).find_each
        expect(r).to_not be_nil
        expect(r.include?(model)).to be_true
      end

      it "should find a known model given consistent constraints" do
        model = @scope.all.first
        brand = model.brand
        expect(model).to_not be_nil
        term = model.name
        r = NameQuery.new(term, @scope, :bike_brand, 
                          :constraints => {:bike_brand_id => brand.id}).find
        expect(r).to_not be_nil
        expect(r).to eq model
      end

      it "should be nil for a known model given inconsistent constraints" do
        model = @scope.all.first
        brand = model.brand
        expect(model).to_not be_nil
        term = model.name
        r = NameQuery.new(term, @scope, :bike_brand, 
                          :constraints => {:bike_brand_id => brand.id+1}).find
        expect(r).to be_nil
      end
    end # describe searching models

  end # describe NameQuery

end # module BikeMfg
