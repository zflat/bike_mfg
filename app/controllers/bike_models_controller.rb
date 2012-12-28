class BikeModelsController < ApplicationController
  unloadable
  include BikeMfg::Controllers::BikeModelsControllerMethods
end
