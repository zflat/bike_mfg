require 'spec_helper'
require 'bike_mfg/models/bike_model_factory_methods.rb'

module BikeMfg
  module Models

    module WhereStub
      def where(args)
        record = nil
        d = self.class.data
        if args.has_key?(:id)
          record = d[args[:id]]
        elsif args.has_key?(:name)
          d.each do |r|
            if r.name == args[:name]
              record = r
            end
          end
        end
        record
      end
    end

    class ModelScope
      def self.data
        
      end
      extend WhereStub
    end

    class BrandScope

    end

    class BikeModelFactory
      include BikeModelFactoryMethods
    end

    describe BikeModelFactory do

      it "should take a hash of arguments" do
        factory = BikeModelFactory.new(:model_id => 1)
        expect(factory).to_not be_nil
      end
      
    end


  end # modeul Model
end # module BikeMfg
