require 'ostruct'

module BikeMfg
  module Models
    module BikeModelFactoryMethods
      
      #instance methods
      def initialize(paramaters={})
        @params = OpenStruct.new paramaters
        set_flags(params_list)

        @model = build
      end

      def model
        @model
      end

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
      #     0    |     1      |     0    |     0      || New/found model with unknown brand
      #     0    |     1      |     0    |     1      || New/found model with new/found brand
      #     0    |     1      |     1    |     0      || New/found model with given brand
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
            @params.model_id? && !@params.model_name? &&
            @params.brand_id? && !@params.brand_name?

          # Case new/found model with new/found brand
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

      def get_brand(id)
      end

      def get_model(id)
      end

      def build_model(name, brand)
      end

      def build_brand(name)
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
