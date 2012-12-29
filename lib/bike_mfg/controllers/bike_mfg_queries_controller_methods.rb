module BikeMfg
  module Controllers
    module BikeMfgQueriesControllerMethods
      
      def self.included(base)
        base.send :respond_to, :json
      end
      
      # Actions
      def search_models
        @results = BikeMfg::NameQuery.new(term, BikeModel).find_each
        render :flat_results and return
      end

      def search_brands
        @results = BikeMfg::NameQuery.new(term, BikeBrand).find_each
        render :flat_results and return
      end

      def search
        @results = BikeMfg::ModelCollectionQuery.new(term).find_each        
        render :nested_results and return
      end

      private

      def term
        params[:q]
      end
      
    end
  end
end
