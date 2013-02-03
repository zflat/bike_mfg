require 'bike_mfg'
require 'bike_mfg/version'
require 'bike_mfg/query'
require 'bike_mfg/acts_as_manufacturable'

module BikeMfg
  if defined?(Rails) && Rails::VERSION::MAJOR == 3
    require 'bike_mfg/engine'
    require 'squeel'
    require 'active_support'
    require 'rabl'
  end
end
