require 'ostruct'

module BikeMfg
  class ModelCollectionQuery
    def initialize(search_phrase, scope = BikeModel)
      @term = search_phrase.strip unless search_phrase.blank?
      @scope = scope
    end
    
    def search_term
      @term
    end
    
    def find_each(&block)
      term = search_term
      
      if term.present?
        brands = {}
        models_found = @scope.where{name =~ "%#{term}%"}
        models_found.each do |model|
          b = model.bike_brand
          brands[b.id] ||= blank_brand(b)
          brands[b.id][:models] << model
        end

        brands_found = BikeBrand.where{name =~ "%#{term}%"}
        
        brands_found.each do |b|
          if brands[b.id].nil?
            brands[b.id] = blank_brand(b)
            b.models.each do |m|
              brands[b.id][:models] << m
            end
          end
        end
        
        brands.map{ |key, val| OpenStruct.new val }
      else
        nil
      end # if term.present?
    end

    def self.blank_brand(brand, indirect=false)
      Hash.new do |h,k|
        case k.to_sym
          when :name then brand[:name]
          when :indirect then indirect
          when :models then []
        end
      end
      # {:name => obj.name, :models => []}
    end
    
  end #  ModelCollectionQuery

  class NameQuery
    def initialize(search_phrase, scope)
      @term = search_phrase.strip if search_phrase
      @scope = scope
    end

    def search_term
      @term
    end

    def find_each(&block)
      term = search_term

      if term.present?
        @scope.where{name =~ "%#{term}%"}
      else
        nil
      end
    end # find_each
  end # class NameQuery
end
  
