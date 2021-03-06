require 'ostruct'

require 'bike_mfg/query'

module BikeMfg
  module Models
    module BikeModelFactoryMethods
      
      #instance methods
      def initialize(args = {})
        @model_scope = args[:model_scope] || BikeModel
        @brand_scope = args[:brand_scope] || BikeBrand
        parse_param_prefix(args[:param_prefix])
        @params = parse_params(args)
        set_flags(params_list)
        validate_params
        
        @model = build
      end

      attr_reader :model

      private

      def params_list
        [:model_id, :model_name, :brand_id, :brand_name]
      end

      # Build the model and brand based on input paramaters.
      #
      # Given the 4 paramaters, there are 16 possible cases
      # based on if the paramater is present or missing.
      # 
      # The table below shows the assignemt for each case.
      #
      # model_id | model_name | brand_id | brand_name || Assignment
      # ---------|------------|----------|------------||-----------
      #     0    |     0      |     0    |     0      || Nullify current assignemt
      #     0    |     0      |     0    |     1      || Unknown model for new/found brand
      #     0    |     0      |     1    |     0      || Unknown model for given brand
      #     0    |     0      |     1    |     1      || Exception: ambiguity
      #     0    |     1      |     0    |     0      || New/found model w/ unknown brand
      #     0    |     1      |     0    |     1      || New/found model w/ new/assigned brand
      #     0    |     1      |     1    |     0      || New/found model w/ given brand
      #     0    |     1      |     1    |     1      || Exception: ambiguity
      #     1    |     0      |     0    |     0      || Given model
      #     1    |     0      |     0    |     1      || Exception: ambiguity
      #     1    |     0      |     1    |     0      || Exception: ambiguity
      #     1    |     0      |     1    |     1      || Exception: ambiguity
      #     1    |     1      |     0    |     0      || Exception: ambiguity
      #     1    |     1      |     0    |     1      || Exception: ambiguity
      #     1    |     1      |     1    |     0      || Exception: ambiguity
      #     1    |     1      |     1    |     1      || Exception: ambiguity
      def build

        # Try to find the model given the user information
        model = get_model(@params)

        # Create the model if none was found
        if model.nil?
          
          # Find or build the brand
          brand = get_brand(@params)
          brand ||= build_brand(@params.brand_name) if @params.brand_name?

          # build the model
          model = build_model(@params.model_name, brand)
        end

        model
      end


      # A model is uniquely identified by one of:
      # * id
      # * exact match of model name and brand name
      # * exact match of model name and brand id
      # 
      # @param (Fixnum, #to_i, #id, (#brand_id, #name), (#brand_name, #name) arg model identifier
      # 
      def get_model(arg)
        id = arg.to_i if arg.respond_to?(:to_i)
        id ||= arg.id if arg.respond_to?(:id)
        id ||= arg.model_id if arg.model_id?

        # Find by model_id
        m = @model_scope.where(:id => id).first if id

        name = arg.name if arg.respond_to?(:name)
        name = arg.model_name if arg.model_name?
        name ||= '' if !arg.model_id?

        if m.nil? && name
          brand_id = arg.brand_id
          brand_name = arg.brand_name

          brand_inclusion = prefixed(:brand)
          
          # Constrain by brand info, with preference for brand_id
          
          brand_constraint =  {:id => brand_id}  unless brand_id.nil?
          brand_constraint ||= {:name => brand_name} unless brand_name.nil?
          constraint = {brand_inclusion => brand_constraint} if brand_constraint
          constraint ||= {prefixed(:brand_id) => nil}

          # Find by name and brand constraint
          m = NameQuery.new(name, @model_scope, brand_inclusion, :constraints => constraint).find

        end

        m
      end
      
      # A brand is found by id or by an exact match on name.
      #
      # @param Fixnum (#to_i, #brand_id, #name, #brand_name) id
      # 
      def get_brand(arg)
        # get brand by id
        id = arg if arg.respond_to?(:to_i)
        id ||= arg.brand_id if arg.brand_id?

        b = @brand_scope.where{ {:id => id} }.first if id

        if b.nil?
          # Try to get the brand by name
          name = arg.name if arg.respond_to?(:name)
          name = arg.brand_name if arg.brand_name?
          
          b = @brand_scope.where{ {:name => name} }.first if name
        end

        b
      end

      def build_model(name, brand)
        model = nil
        
        valid_args = (!name.blank? || !brand.nil?)
        
        if valid_args
          name ||= ''

          model = @model_scope.new
          model.name = name

          # assign the brand
          model.send(prefixed(:brand=), brand) if model          
        end

        model
      end

      def build_brand(name)
        brand = nil
        unless name.blank?
          brand = @brand_scope.new
          brand.name = name
        end
        brand
      end

      def parse_param_prefix(arg)
        @param_prefix = arg.to_s
        @param_prefix += '_' if @param_prefix
        @param_prefix ||= ''
      end

      def prefixed(val)
        (@param_prefix.to_s+val.to_s).to_sym
      end
      
      def parse_params(h)
        params_h = {}
        prefix_pattern = Regexp.new('\A'+@param_prefix)
        h.each  do |k,v| 
          # get the parameter key without the prefix
          key = k.to_s.gsub(prefix_pattern, '').to_sym
          if params_list.include?(key)
            params_h[key] = v
          end
        end
        OpenStruct.new params_h
      end

      
      def set_flags(list)
        list.each do |p|
          val = @params.send("#{p}")
          if val.respond_to?(:present?)
            @params.send("#{p}?=", val.present?)
          else
            present = !val.nil? && val.to_s.strip != ''
            @params.send("#{p}?=", present)
          end
        end
      end

      def validate_params()
        return nil if @params.nil?
        
        if @params.model_id? &&
            (@params.model_name? ||
             @params.brand_id? ||
             @params.brand_name?)
          raise Exception.new("Ambiguous parameters")
        end

        if @params.brand_id? && @params.brand_name?
          raise Exception.new("Ambiguous parameters")
        end
      end # validate_params
      
    end # module BikeModelFactoryMethods
  end # module Models
end # module BikeMfg
