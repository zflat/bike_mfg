require 'active_record'
require 'squeel'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

require 'bike_mfg/db/migrate/bike_brand_transformations'
require 'bike_mfg/db/migrate/bike_model_transformations'

ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false

  ActiveRecord::Schema.define do

    BikeMfg::Db::Migrate::BikeBrandTransformations.create_table_bike_brands self
    BikeMfg::Db::Migrate::BikeModelTransformations.create_table_bike_models self

  end #   ActiveRecord::Schema.define
end
