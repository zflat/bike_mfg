module BikeMfg
  module Db
    module Migrate
      module BikeModelTransformations

        def BikeModelTransformations.up(base)
          base.create_table :bike_models do |t|
            t.string "name", :null => false
            t.integer "bike_brand_id", :null => true
            #t.timestamps
          end

          base.add_index :bike_models, :bike_brand_id
          base.add_index :bike_models, :name
        end

        def table_up_transformation
          BikeModelTransformations.up self
        end
        
      end
    end
  end
end

