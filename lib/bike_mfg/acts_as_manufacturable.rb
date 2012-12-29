module BikeMfg
  module ActsAsManufacturable
    def self.included(base)
      base.send :belongs_to, :bike_model
      base.send :attr_accessible, :bike_model_id
    end # self.included

    # instance methods    
    def brand
      self.bike_model.brand
    end
    def model
      self.bike_model
    end
    
  end
end
