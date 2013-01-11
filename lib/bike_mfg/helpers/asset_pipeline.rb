module BikeMfg
  module Helpers
    module AssetPipeline
      ##
      # Returns whether or not the asset pipeline is present and enabled.
      #
      # The detection scheme used here was ripped from jquery-rails.
      def asset_pipeline_enabled?
        defined?(Rails) && ::Rails.version >= "3.1" && ::Rails.application.config.assets.enabled
      end
    end
  end
end
