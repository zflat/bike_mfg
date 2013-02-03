module BikeMfg
  module Models
    module BikeModelMethods
      def self.included(base)
        base.send :belongs_to, :bike_brand
        base.send :attr_accessible, :name, :bike_brand_id
        base.send :validates_presence_of, :name
        base.send :validates_uniqueness_of, :name, :scope => :bike_brand_id
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
