require 'active_record'
require 'squeel'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

require 'bike_mfg/db/migrate/bike_brand_transformations'
require 'bike_mfg/db/migrate/bike_model_transformations'


ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do

  BikeMfg::Db::Migrate::BikeBrandTransformations.up self
  BikeMfg::Db::Migrate::BikeModelTransformations.up self

end #   ActiveRecord::Schema.define

