require 'ostruct'

module BikeMfg
  class ModelCollectionQuery
    def initialize(search_phrase, scope = BikeModel)
      @term = search_phrase
      @scope = scope
    end
    
    def search_term
      @term
    end
    
    def find_each(search_phrase = nil, &block)
      term = search_phrase || search_term
      
      if term.present?
        brands = {}
        models_found = @scope.where{name =~ "%#{term}%"}
        models_found.each do |model|
          b = model.bike_brand
          brands[b.id] ||= blank_h(b)
          brands[b.id][:models] << model
        end

        brands_found = BikeBrand.where{name =~ "%#{term}%"}
        brands_found.each do |b|
          brands[b.id] ||= blank_h(b)
        end
        
        brands.map{ |key, val| OpenStruct.new val }
      else
        nil
      end # if term.present?
    end
        
    private

    def blank_h(obj)
      {:name => obj.name, :models => []}
    end
    
  end #  ModelCollectionQuery
end
  
