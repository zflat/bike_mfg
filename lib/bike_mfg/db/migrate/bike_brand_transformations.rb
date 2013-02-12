module BikeMfg
  module Db
    module Migrate
      module BikeBrandTransformations
        def BikeBrandTransformations.up(base)
          base.create_table :bike_brands do |t|
            t.string "name", :null => false
            #t.timestamps
          end
          
          base.add_index :bike_brands, :name
        end
        
        def table_up_transformation
          BikeBrandTransformations.up self
        end
        
      end
    end
  end
end


