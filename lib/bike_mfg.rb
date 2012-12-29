require 'bike_mfg/version'
require 'bike_mfg/query'
require 'bike_mfg/acts_as_manufacturable'
require 'squeel'
require 'rabl'

module BikeMfg
  require 'bike_mfg/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
end
