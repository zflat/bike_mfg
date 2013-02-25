module BikeMfg
  module Models
    module BikeModelMethods
      def self.included(base)
        base.send :belongs_to, :bike_brand
        base.send :attr_accessible, :name, :bike_brand_id
        base.send :validates_uniqueness_of, :name, :scope => :bike_brand_id
        base.send :validates, :name, :presence => true, :if => "brand.nil?"
        # prevent name from being nil, but allow it to be an empty string
        base.send(
                  :validates, :name, 
                  :presence => {:message => "can't be missing", :if => 'name.nil?'}
                  )
      end # self.included

      # instance methods
      def to_s
        self.name
      end
      
      def brand
        self.bike_brand
      end

    end # module BikeModelMethods
  end
end
