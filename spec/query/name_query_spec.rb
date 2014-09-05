require 'spec_helper'
require 'bike_mfg'

module BikeMfg
  
  describe NameQuery do

    context "given an unknown bike brand name" do
      let(:phrase){'modelname'}
      let(:inclusion){:bike_brand}
      let :constraints do
        {:bike_brand => {:name => 'testname'}}
      end
      let(:scope){BikeModel}
      subject :q do
        BikeMfg::NameQuery.new(phrase, scope, inclusion, :constraints => constraints)
      end

      it "returns empty search results" do
        r = scope.joins{my{inclusion}}.
          where{(name == my{phrase}) & (my{constraints})}.includes(inclusion).references(inclusion).first
        expect(r).to be_nil

        expect(q.find).to be_nil
      end

      it "has constraints" do
        expect(q.constraints).to_not be_nil
        expect(q.constraints).to eq constraints
      end
      
      it "has inclusion" do
        expect(q.inclusion).to_not be_nil
        expect(q.inclusion).to eq inclusion
      end
      
      it "has scope" do
        expect(q.scope).to_not be_nil
        expect(q.scope).to eq scope
      end
    end #     context "given an unknown bike brand name"
    
    context "given the name of a model without a brand" do
      let(:known_model) do
        BikeModel.where{bike_brand_id == nil}.first
      end
      let(:name){known_model.name}
      subject(:q) do
        NameQuery.new(name, BikeModel,:bike_brand)
      end
      
      it "finds the model" do
        expect(
               BikeModel.joins{my{Squeel::Nodes::Join.new(:bike_brand, Arel::OuterJoin)}}.where{
                 (name==my{name})
                 }.includes(:bike_brand).references(:bike_brand).first
               ).to_not be_nil
        expect(BikeModel.where(:name => name).first).to_not be_nil
      end
      it "finds the model" do
        expect(q.find).to_not be_nil
      end
    end #     context "given the name of a model without a brand"

    context "given the name of a model with a brand" do
      let(:known_model) do
        BikeModel.where{bike_brand_id != nil}.first
      end
      let(:name){known_model.name}
      subject(:q) do
        NameQuery.new(name, BikeModel,:bike_brand)
      end
      
      it "finds the model" do
        m = q.find
        expect(m).to_not be_nil
        expect(m).to eq known_model
      end
    end # context "given the name of a model with a brand"

    describe "searching brands" do
      
      before :all do
        @scope = BikeBrand
      end

      it "should find a known brand" do
        brand = BikeBrand.all.first
        expect(brand).to_not be_nil
        term = brand.name
        r = NameQuery.new(term, @scope, :bike_models).find_each
        expect(r).to_not be_nil
        expect(r.include?(brand)).to be_truthy
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
        expect(r.include?(model)).to be_truthy
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

      it "should be nil given an unknown bike brand name" do
        phrase = 'modelname'
        inclusion = :bike_brand
        constraints = {:bike_brand => {:name => 'testname'}}

        r = @scope.joins{inclusion}.where{(name == my{phrase}) & (my{constraints})}.includes(inclusion).references(inclusion).first
        expect(r).to be_nil

        q = BikeMfg::NameQuery.new(phrase, @scope, inclusion, :constraints => constraints).find
        expect(q).to be_nil
      end

      it "complets a nil query" do
        phrase = nil
        scope = BikeModel
        inclusion = :bike_brand
        constraints = {:bike_brand_id => nil}
      
      end
    end # describe searching models

  end # describe NameQuery

end # module BikeMfg
