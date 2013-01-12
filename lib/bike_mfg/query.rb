require 'ostruct'

module BikeMfg
  
  module Query
    
    module PhraseTerms
      
      attr_reader :phrase
      attr_reader :terms
      
      private
      
      def set_phrase_terms(phrase)
        @phrase = phrase.strip unless phrase.blank?
        if @terms.nil? && @phrase
          @terms ||= 
            "%#{@phrase.gsub('%', '/%')}%".
            gsub(' ', '% %').split(' ')
        end
      end
    end # module

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
    
    #  Models from brands in the given brand relation
    def self.related_models(brand_rel, scope=BikeModel)
      scope.joins{bike_brand}.
        where{
        bike_brand.id.in(brand_rel.select{id})
      }.group{id}.includes{bike_brand}
    end
    
  end # module Query
  
  
  class ModelsMatch
    include Query::PhraseTerms

    def initialize(search_phrase, scope = {})
      @scope_models = scope[:models] || ::BikeModel
      @scope_brands = scope[:brands] || ::BikeBrand
      set_phrase_terms(search_phrase)
    end

    def models
      if @models.nil?
        t = terms
        @models = @scope_models.
          where{name.like_any t}.
          includes{bike_brand}
      end
      @models
    end
  end # class
  
  # Brands that directly match search terms
  # and models that match directly.
  # 
  class DirectBrandAndModelQuery
    
    include Query::PhraseTerms

    def initialize(search_phrase, scope = {})
      @scope_models = scope[:models] || ::BikeModel
      @scope_brands = scope[:brands] || ::BikeBrand
      set_phrase_terms(search_phrase)
    end
    
    def models
      if @models.nil?
        t = terms
        @models = @scope_models.joins{bike_brand}.
          where{
          (name.like_any t) & 
          (bike_brand.name.like_any t)
        }.includes{bike_brand}
      end
      @models
    end
    
    def indirect_models
      @indirect_models ||= Query::related_models(indirect_brands())
      @indirect_models
    end
    
    # Brands without any matching models
    def indirect_brands
      if @indirect_brands.nil?
        t = terms
        # Use contrapositive for the select
        # First get the opposite of what is needed
        # then exclude those from the final results
        
        # brands with matching models
        positive = @scope_brands.joins{bike_models}.
          where{
          bike_models.name.like_any t
        }
        @indirect_brands = 
          @scope_brands.joins{bike_models}.where{
          (name.like_any t) &
          (id.not_in(positive.select{id}))
        }.group{id}.includes{bike_models}
      end
      @indirect_brands
    end
    
  end # class 
  
  class ModelCollectionQuery
    def initialize(search_phrase, scope = {})
      @phrase = search_phrase.strip unless search_phrase.blank?
      @scope_models = scope[:models] || BikeModel
      @scope_brands = scope[:brands] || BikeBrand
    end
    
    attr_reader :phrase

    def self.read_val(obj, sym)
      val = obj.send(sym) if obj.respond_to?(sym)
      val ||= obj[sym] if obj.respond_to?('[]')
    end
    
    def self.brand_h(brand, direct=true)
      name = read_val(brand,:name)
      id = read_val(brand,:id)

      {:name => name, :id=> id, :models => [], :direct => direct}
    end
    
    def brand_h(brand, direct=true)
      self.class.brand_h(brand, direct)
    end
    
    def find_each(&block)
      return nil if phrase.blank?
      
      # results hash
      r = {}
      
      q = DirectBrandAndModelQuery.new(phrase, :models => @scope_models, :brands => @scope_brands)
      
      # Models & their brand match phrase
      direct_find = q.models      
      direct_find.all.each do |model|
        b_id = model.brand.id
        
        # Add missing brand to the results
        # (flag brand as direct=true)
        r[b_id] ||= brand_h(model.brand)
        
        # Append model
        r[b_id][:models] << model
      end
      
      # Models associated with brands such that
      # the brands match the phrase, but no
      # model associated with the brand matched
      indirect_find = q.indirect_models
      indirect_find.all.each do |model|
        b_id = model.brand.id
        r[b_id] ||= brand_h(model.brand)
        r[b_id][:models] << model        
      end
      
      # Models that match the phrase, but
      # may not have a brand that also
      # matches the phrase
      #
      # Brands that need to be added from this
      # query are to be considered indirect
      q_any = ModelsMatch.new(phrase,:models => @scope_models, :brands => @scope_brands)
      q_any.models.all.each do |model|
        b_id = model.brand.id
        r[b_id] ||= brand_h(model.brand, false)
        r[b_id][:models] |= [model]
      end
      
      return r.map{ |key, val| OpenStruct.new val }
    end #find_each
  end #  ModelCollectionQuery

  class NameQuery
    include Query::PhraseTerms

    def initialize(search_phrase, scope, inclusion)
      @scope = scope
      @inclision = inclusion
      set_phrase_terms(search_phrase)
    end

    def find_each(&block)
      return nil if phrase.blank?
      t = terms
      return @scope.joins{@inclusion}.
        where{name.like_any t}.
        includes{@inclusion}
    end # find_each

  end # class NameQuery
end
  
