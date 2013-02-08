require 'bike_model'
require 'bike_brand'

Dir[File.expand_path('../../blueprints/*.rb', __FILE__)].each do |f|
  require f
end

class Models

  def self.make

    10.times do
      bike_brand = BikeBrand.make!
      bike_model = BikeModel.make! # models without a brand assigned
    end

    brand_without_models = BikeBrand.new(:name => "brand with no models#{BikeBrand.count}")
    brand_without_models.save

    brand_for_blank_model = BikeBrand.new(:name => "brand with blank model #{BikeBrand.count}")
    brand_for_blank_model.save

    model_without_name = BikeModel.new(:name => '', 
                                       :bike_brand_id => brand_for_blank_model.id)
    model_without_name.save

  end # self.make

end
