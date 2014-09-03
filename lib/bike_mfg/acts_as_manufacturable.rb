module BikeMfg
  module ActsAsManufacturable
    def self.included(base)
      base.send :belongs_to, :bike_model
      # base.send :attr_accessible, :bike_model_id
    end # self.included
    
    def brand
      bike_model.brand if bike_model
    end
    def model
      bike_model
    end

  end
end
