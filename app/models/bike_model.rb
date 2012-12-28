class BikeModel < ActiveRecord::Base
  unloadable
  include BikeMfg::Models::BikeModelMethods
end
