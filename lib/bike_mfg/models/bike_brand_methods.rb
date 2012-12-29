module BikeMfg
  module Models
    module BikeBrandMethods
      def self.included(base)
        base.send :has_many, :bike_models
        base.send :attr_accessible, :name
        base.send :validates_precense_of, :name
      end # self.included

      # instance methods
      def to_s
        self.name
      end

      def models
        self.bike_models
      end
    end
  end
end
