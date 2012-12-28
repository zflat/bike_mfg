module BikeMfg
  module Models
    module BikeModelMethods
      def self.included(base)
        base.send :belongs_to, :bike_brand
        base.send :attr_accessible, :name
      end # self.included

      # instance methods
      def to_s
        self.name
      end

      def brand
        self.bike_brand
      end
    end
  end
end
