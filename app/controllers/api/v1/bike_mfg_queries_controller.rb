module Api
  module V1
    class BikeMfgQueriesController < ApplicationController
      unloadable
      include BikeMfg::Controllers::BikeMfgQueriesControllerMethods
    end
  end # v1
end #api
