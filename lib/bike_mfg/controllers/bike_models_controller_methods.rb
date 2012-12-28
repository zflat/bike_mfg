module BikeMfg
  module Controllers
    module BikeModelsControllerMethods
      
      def self.included(base)
        # base.send :respond_to, :json
      end

      # Actions
      def index
        term = params[:term]
        @models = BikeModel.where{name =~ "%#{term}%"} if term.present?

        @brands = BikeMfg::ModelCollectionQuery.new(term).find_each

        respond_to do |format|
          format.json
          format.html
        end
      end
      
    end
  end
end
