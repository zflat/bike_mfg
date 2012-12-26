module BikeMfg
  module Models
    module BikeBrandMethods
      def self.included(base)
        attr_accessible :name
      end # self.included

      # instance methods
      def to_s
        self.name
      end
    end
  end
end
