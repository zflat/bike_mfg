require 'bike_mfg/db/migrate/bike_model_transformations'
class CreateBikeModels < ActiveRecord::Migration
  include BikeMfg::Db::Migrate::BikeModelTransformations
  def change
    create_table_transformation
  end
end
