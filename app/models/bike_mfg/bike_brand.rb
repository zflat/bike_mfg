module BikeMfg
  class BikeBrand < ActiveRecord::Base
    unloadable
    include BikeMfg::Models::BikeBrandMethods
  end
end
