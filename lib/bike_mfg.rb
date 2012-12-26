require "bike_mfg/version"

module BikeMfg
  require 'bike_mfg/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
end
