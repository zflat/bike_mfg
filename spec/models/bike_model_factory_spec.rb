require 'spec_helper'
require 'bike_model_factory'

describe BikeModelFactory do
  it "should take a hash of arguments with specified scope" do
    args = {
      :model_id => '1',
      :brand_scope=>BikeBrand,
      :model_scope=>BikeModel
    }
    factory = BikeModelFactory.new(args)
    expect(factory).to_not be_nil
  end

  
  


end # describe BikeModelFactory
