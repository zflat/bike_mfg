require 'bike_mfg/models/bike_brand_methods'

class BikeBrand < ActiveRecord::Base
  include BikeMfg::Models::BikeBrandMethods
end
