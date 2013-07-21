module BikeMfg
  module Models
    module BikeBrandMethods
      def self.included(base)
        base.send :has_many, :bike_models
        base.send :validates_presence_of, :name
        base.send :validates_uniqueness_of, :name
        base.send :alias_attribute, :models, :bike_models
      end # self.included

      # instance methods
      def to_s
        self.name
      end
    end
  end
end
