require 'bike_mfg/db/migrate/bike_brand_transformations'
class CreateBikeBrands < ActiveRecord::Migration
  include BikeMfg::Db::Migrate::BikeBrandTransformations
  def change
    table_up_transformation
  end
end
