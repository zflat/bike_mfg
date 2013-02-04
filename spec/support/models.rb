require 'bike_model'
require 'bike_brand'

Dir[File.expand_path('../../blueprints/*.rb', __FILE__)].each do |f|
  require f
end

class Models

  def self.make

    10.times do
      bike_brand = BikeBrand.make!
      bike_model = BikeModel.make!
    end

    brand = BikeBrand.new(:name => "brand with blank model#{BikeBrand.count}")
    brand.save
    model_without_name = BikeModel.new(:name => '', :bike_brand_id => brand.id)
    model_without_name.save
    
  end # self.make

end
