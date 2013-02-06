module BikeMfg
  module Controllers
    module BikeMfgQueriesControllerMethods
      
      def self.included(base)
        base.send :respond_to, :json
        base.send :helper_method, :term
      end
      
      # Actions
      def search_brands
        @results = BikeMfg::NameQuery.new(term, BikeBrand, :bike_models).find_each.to_a
        render :flat_results and return
      end

      def search
        @results = BikeMfg::ModelCollectionQuery.new(term).find_each.to_a        
        render :nested_results and return
      end

      def search_models
        @results = BikeMfg::NameQuery.new(term, BikeModel, :bike_brand, 
                                          :constraints => brand_constraint).find_each.to_a
        render :flat_results and return
      end


      private

      def term
        params[:q]
      end
      
      def brand_constraint
        {:bike_brand_id=> params[:brand]} unless params[:brand].blank?
      end
    end
  end
end
