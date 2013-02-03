module BikeMfg
  module Db
    module Migrate
      module BikeModelTransformations

        def BikeModelTransformations.create_table_bike_models(base)
          base.create_table :bike_models do |t|
            t.string "name", :null => false
            t.integer "bike_brand_id", :null => true
            #t.timestamps
          end
        end

        def create_table_transformation
          BikeModelTransformations.create_table_bike_models self
        end
        
      end
    end
  end
end

