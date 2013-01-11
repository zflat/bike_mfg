require 'ostruct'

module BikeMfg
  module Query

    # @param String phraseA 
    # @param String phraseB 
    #
    # Get every term in B that is not in A
    def self.phrase_difference(phraseA, phraseB)
      (phraseB.split(' ').select{|t| (phraseA =~ Regexp.new(t,Regexp::IGNORECASE)).nil?}).join(' ')
    end # phrase_difference


    # @params Array list of objects to match against
    # @params String phrase of terms
    # @params (Matcher,#match?) matcher for checking match?
    #
    # Get all objects in list that #match? returns true 
    # for all terms in phrase
    #
    def self.match_AND(list, phrase, matcher)
      terms = phrase.split(' ')
      list.select do |item|
        m = terms.select { |t| matcher.match?(item, t)}
        terms.count == m.count
      end
    end

    # @params Array list of objects to match against
    # @params String phrase of terms
    # @params (Matcher,#match?) matcher for checking match?
    #
    # Get all objects in list that #match? returns true 
    # for any terms in phrase
    #
    def self.match_OR(list, phrase, matcher)
      terms = phrase.split(' ')
      list.select do |item|
        m = terms.select { |t| matcher.match?(item, t)}
        m.count > 0
      end      
    end
    
    # Apply a specified function to an object
    # and test for a match
    class Matcher
      def initialize(function_name)
        @fn_name = function_name
      end
      
      def match?(obj, term)
        obj.send(@fn_name) =~ Regexp.new(term, Regexp::IGNORECASE)
      end
    end
    
  end # module Query
  
  class ModelCollectionQuery
    def initialize(search_phrase, scope = {})
      @phrase = search_phrase.strip unless search_phrase.blank?
      @scope_models = scope[:models] || BikeModel
      @scope_brands = scope[:brands] || BikeBrand
    end
    
    def search_phrase
      @phrase
    end

    def self.brand_h(brand, direct=true)
      name = brand.name if brand.respond_to?(:name)
      name ||= brand[:name] if brand.respond_to?('[]')
      {:name => name, :models => [], :direct => direct}
    end

    def brand_h(brand, direct=true)
      self.class.brand_h(brand, direct)
    end

    
    def find_each(&block)
      phrase = search_phrase
      
      if phrase.blank?
        return nil
      end

      name_matcher = Query::Matcher.new('name')
      
      # Keep track of results in a nested Hash
      # of the form {brand.id=>{:name=>brand.name,:models=>Array,:direct=>boolean}}
      results = {}  
      
      # Add to the results object by finding
      # brands that directly match search terms
      # and appending models of those brands
      # that also match the search.
      phrase.split(' ').each do |term|
        # Find brands that match at least one of the terms 
        brands_found = @scope_brands.where{name =~ "%#{term}%"}
        
        brands_found.each do |brand|
          # add the brand to the results if it is missing
          results[brand.id] ||= brand_h(brand)
          
          # Edit the phrase removing everything that matches the brand
          sub_phrase = Query::phrase_difference(brand.name,phrase)
          
          # Get models that have name that match AND of terhms
          # or all models if there is nothing to match against
          sub_models = (sub_phrase.blank?) ? 
          brand.models :
            Query::match_AND(brand.models, sub_phrase, name_matcher)
          
          # Append models, avoiding duplication
          results[brand.id][:models] |= sub_models
          results[brand.id][:name] += '__'+sub_phrase
          
        end # do |brand|
        end # each |term|
      
      # Get models that directly match at least one of the terms
      models_found = []
      phrase.split(' ').each do |term|
        # Append to running list, avoiding duplicates
        models_found |= @scope_models.where{name =~ "%#{term}%"}        
      end # each |term|
      
      # Merge the models found with ones that are already in the results
      models_found.each do |model|
        brand = model.brand

        # The associate brand was not found
        # It needs to be added to the results
        # and flagged as an indirect match
        results[brand.id] ||= brand_h(brand, false)

          #results[b_id][:models] << model
        
        # Union the model to any that may
        # already be associated with the brand.
        # Avoid duplicates.
        results[brand.id][:models] |= [model]
        
      end # each |model|

      return results.map{ |key, val| OpenStruct.new val }
    end #find_each
    
    def find_each0(&block)
      phrase = search_phrase
      
      return nil if phrase.blank?
      
      brands = {}
      models_found = @scope_models.where{name =~ "%#{phrase}%"}
      models_found.each do |model|
        b = model.bike_brand
        brands[b.id] ||= brand_h(b, true)
        brands[b.id][:models] << model
      end
      
      brands_found = @scope_brands.where{name =~ "%#{phrase}%"}
      
      brands_found.each do |b|
        if brands[b.id].nil?
          brands[b.id] = brand_h(b)
          b.models.each do |m|
            brands[b.id][:models] << m
          end
        end
      end
        
      brands.map{ |key, val| OpenStruct.new val }
      
    end # find_each
    
  end #  ModelCollectionQuery
  
  class NameQuery
    def initialize(search_phrase, scope)
      @phrase = search_phrase.strip if search_phrase
      @scope = scope
    end

    def search_phrase
      @phrase
    end

    def find_each(&block)
      phrase = search_phrase
      return nil if phrase.blank?
      
      results = []
      
      phrase.split(' ').each do |term|
        r = @scope.where{name =~ "%#{term}%"}
        results.concat r if r
      end # do |term|

      return results
    end # find_each
  end # class NameQuery
end
  
