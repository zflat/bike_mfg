require 'bike_mfg/models/bike_model_methods'

class BikeModel < ActiveRecord::Base
  unloadable
  include BikeMfg::Models::BikeModelMethods
end
