require 'rails'
require 'bike_mfg'

module BikeMfg
  class Engine < Rails::Engine
    root = File.expand_path('../../', __FILE__)
    config.autoload_paths << root
  end
end
