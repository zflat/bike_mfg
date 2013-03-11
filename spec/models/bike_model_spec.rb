require 'spec_helper'

describe BikeModel do

  describe "collection" do
    it "should have models" do
      expect(BikeModel.count>0).to be_true
    end
  end

  context "with a brand" do
    context "when the name is present and unique" do
      let(:brand){BikeBrand.all.first}
      let(:new_name){BikeModel.all.last.name + 'new'}
      subject(:model){BikeModel.new(:name => new_name , :bike_brand_id => brand.id)}

      it "is valid" do
        expect(model).to be_valid
      end

      it "references the brand" do
        expect(model.brand).to eq brand
      end
    end

    context "when the name is present and unique to the brand" do
      
      let(:models_with_brand){BikeModel.where{bike_brand_id != nil}}
      let(:model0){models_with_brand.first}
      let(:new_name){model0.name}

      let(:models_with_same_name){BikeModel.where{name == my{new_name}}}
      let(:brand){BikeBrand.where{id.not_in(my{models_with_same_name}.select{bike_brand_id})}.first}
      
      describe "model new to the brand" do
        it "has a name unique to the brand" do
          expect(model0.brand).to_not eq(brand)      
        end
      end

      subject(:model){BikeModel.new(:name => new_name , :bike_brand_id => brand.id)}
      it "is valid " do
        expect(model).to be_valid
      end
    end

    it "should not be valid when the name is present and not unique to the brand" do
      models_with_brand = BikeModel.where{bike_brand_id != nil}

      model = models_with_brand.first
      new_name = model.name
      brand = model.brand

      m = BikeModel.new(:name => new_name , :bike_brand_id => brand.id)
      expect(m).to_not be_valid
    end

    it "should be valid when the name is blank" do
      brand = BikeBrand.all.first
      m = BikeModel.new(:name => '', :bike_brand_id => brand.id)
      expect(m).to be_valid
    end

    it "should not be valid if the name is nil" do
      brand = BikeBrand.all.first
      m = BikeModel.new(:name => nil, :bike_brand_id => brand.id)
      expect(m).to_not be_valid      
    end
    
  end

  describe "new model with no brand" do

    it "should not be valid when name is blank" do
      # model without a brand or name
      BikeModel.new(:name => '').save
      m = BikeModel.new(:name => '')
      expect(m).to_not be_valid
    end

    it "should not be valid when name is nil" do
      # model without a brand or name
      BikeModel.new(:name => nil).save
      m = BikeModel.new(:name => '')
      expect(m).to_not be_valid
    end

    it "should be valid if there is a unique name" do
      m = BikeModel.new(:name => 'model name' + BikeModel.all.first.name)
      expect(m).to be_valid
    end

    it "should not be valid if there is a not unique name for models without brands" do
      
      m = BikeModel.new(:name => BikeModel.all.first.name)
      expect(m).to be_valid
    end
  end

end
