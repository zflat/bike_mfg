require 'bike_mfg/models/bike_model_methods'

class BikeModel < ActiveRecord::Base
  include BikeMfg::Models::BikeModelMethods
end
