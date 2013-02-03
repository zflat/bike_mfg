require 'bike_model'
require 'bike_brand'

Dir[File.expand_path('../../blueprints/*.rb', __FILE__)].each do |f|
  require f
end

class Models

  def self.make

    10.times do
      bike_model = BikeModel.make!
    end

  end # self.make

end
