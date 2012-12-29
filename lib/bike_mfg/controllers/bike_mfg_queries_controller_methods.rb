module BikeMfg
  module Controllers
    module BikeMfgQueriesControllerMethods
      
      def self.included(base)
        base.send :respond_to, :json
      end
      

      # Actions
      def search_models
        @results = query_by_name BikeModel
        render :flat_results and return
      end

      def search_brands
        @results = query_by_name BikeBrand
        render :flat_results and return
      end

      def search
        @results = BikeMfg::ModelCollectionQuery.new(term).find_each        
        render :nested_results and return
      end

      private

      def term
        params[:term]
      end
      
      def query_by_name(scope)
        scope.where{name =~ "%#{term}%"} if term.present?        
      end
      
    end
  end
end
