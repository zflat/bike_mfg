require 'bike_mfg/db/migrate/bike_model_transformations'
class CreateBikeModels < ActiveRecord::Migration
  include BikeMfg::Db::Migrate::BikeModelTransformations
  def change
    table_up_transformation
  end
end
