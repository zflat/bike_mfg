require 'ostruct'

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
      #     0    |     1      |     0    |     0      || New/found model w/ unknown/assigned brand
      #     0    |     1      |     0    |     1      || New/found model w/ new/found/assigned brand
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
        model = nil
        if true &&
            !@params.model_id? && !@params.model_name? &&
            !@params.brand_id? && !@params.brand_name?
          # Case nullify current assignment
          model = nil
        elsif true &&
            !@params.model_id? && !@params.model_name? &&
            !@params.brand_id? && @params.brand_name?
          
          # Case unknown model for new/found brand
          b = build_brand(@params.brand_name)
          model = build_model(nil, b)
        elsif true &&
            !@params.model_id? && !@params.model_name? &&
            @params.brand_id? && !@params.brand_name?

          # Case Unknown model for given brand
          b = get_brand(@params.brand_id)
          model = build_model(nil, b)
        elsif true &&
            !@params.model_id? && @params.model_name? &&
            !@params.brand_id? && !@params.brand_name?

          # Case new/found model with unknown brand
          model = build_model(@params.model_name, nil)
        elsif true &&
            !@params.model_id? && @params.model_name? &&
            !@params.brand_id? && @params.brand_name?

          # Case new/found model w/ new/found/assigned brand
          b = build_brand(@params.brand_name)
          model = build_model(@params.model_name, b)
        elsif true &&
            !@params.model_id? && @params.model_name? &&
            @params.brand_id? && !@params.brand_name?

          # Case new/found model with given brand
          b = get_brand(@params.brand_id)
          model = build_model(@params.model_name, b)
        elsif true &&
            @params.model_id? && !@params.model_name? &&
            !@params.brand_id? && !@params.brand_name?

          # Case given model
          model = get_model(@params.model_id)
        else
          # Exception due to ambiguity
          raise Exception.new("Ambiguous build parameters")
        end

        return model
      end


      def get_model(id)
        return @model_scope.where(:id => id)
      end

      def get_brand(id)
        return @brand_scope.where(:id=>id)
      end

      def build_model(name, brand)
        brand_id = brand.id if brand
        params = {:name => name, 
          (@param_prefix+'brand_id').to_sym => brand_id}
        model = @model_scope.where(params)
        model ||= @model_scope.new(params)
      end

      def build_brand(name)
        params = {:name=>name}
        brand = @brand_scope.where(params)
        brand ||= @brand_scope.new(params)
      end

      def parse_param_prefix(arg)
        @param_prefix = arg
        @param_prefix += '_' if @param_prefix
        @param_prefix ||= ''
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
          present = !val.nil? && val.strip != ''
          @params.send("#{p}?=", present)
        end
      end
      
    end # module BikeModelFactoryMethods
  end # module Models
end # module BikeMfg
