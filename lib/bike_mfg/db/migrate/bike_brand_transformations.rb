module BikeMfg
  module Db
    module Migrate
      module BikeBrandTransformations
        def BikeBrandTransformations.create_table_bike_brands(base)
          base.create_table :bike_brands do |t|
            t.string "name", :null => false
            #t.timestamps
          end
        end
        
        def create_table_transformation
          BikeBrandTransformations.create_table_bike_brands self
        end
        
      end
    end
  end
end


