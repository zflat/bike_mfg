require 'ostruct'
require 'spec_helper'
require 'bike_mfg/models/bike_model_factory_methods.rb'

module BikeMfg
  module Models

    module WhereStub
      def where(args)
        d = data
        return nil if d.nil?

        record = nil
        if args.has_key?(:id)
          id = args[:id].to_i
          record = d[id]
        elsif args.has_key?(:name)
          d.each do |r|
            if r && r.name == args[:name]
              record = r
            end
          end
        end
        record
      end

      def initialize(attributes=[])
        @data = attributes
      end
      attr_reader :data

    end # module WhereStub

    module AttrDataStub
    end
    
    class ModelScope
      include ChainableScopeMethods
      include WhereStub
    end
    
    class BrandScope
      include ChainableScopeMethods
      include WhereStub
    end

    class BikeModelFactory
      include BikeModelFactoryMethods
    end

    describe BikeModelFactory do
      before :each do
        @brand_data = [nil,
                      OpenStruct.new(:id=>'1', :name=>'brand1'),
                      OpenStruct.new(:id=>'2', :name=>'brand2'),
                     ]

        @model_data = [nil,
                      OpenStruct.new(:id=>'1', :name=>'model1', :brand_id=>@brand_data[1].id),
                      OpenStruct.new(:id=>'2', :name=>'model2', :brand_id=>@brand_data[2].id),
                     ]

        @model_scope = ModelScope.new @model_data
        @brand_scope = BrandScope.new @brand_data
      end

      it "should take a hash of arguments" do
          args = {
            :model_id => '1',
            :brand_scope=>@brand_scope,
            :model_scope=>@model_scope
          }
        factory = BikeModelFactory.new(args)
        expect(factory).to_not be_nil
      end

      context "A name of an existing brand is given" do
        it "should have an unknown model with the found brand" do
          brand = @brand_data[1]
          args = {
            :brand_name => brand.name,
            :brand_scope=>@brand_scope,
            :model_scope=>@model_scope
          }
          factory = BikeModelFactory.new(args)
          expect(factory.model.name).to be_nil
          expect(factory.model.brand_id).to eq brand.id
        end
      end

      context "A name of non-existing brand is given" do
        it "should have an unknown model with a new brand" do
          args = {
            :brand_name => @brand_data[1].name + 'new',
            :brand_scope=>@brand_scope,
            :model_scope=>@model_scope
          }
          factory = BikeModelFactory.new(args)
          expect(factory.model.name).to be_nil
          expect(factory.model.brand_id).to_not be_nil
        end
      end

      context "A valid brand_id is given, but no model name" do
        it "should have an unknown model for the given brand" do
          brand = @brand_data[2]
          args = {
            :brand_id => brand.id,
            :brand_scope=>@brand_scope,
            :model_scope=>@model_scope
          }
          factory = BikeModelFactory.new(args)
          expect(factory.model.name).to be_nil
          expect(factory.model.brand_id).to eq brand.id
        end
      end

      context "A model name for an existing model is given" do
        it "should have a found model with the model's brand" do
          model = @model_data[2]
          args = {
            :model_name => model.name,
            :brand_scope=>@brand_scope,
            :model_scope=>@model_scope
          }
          factory = BikeModelFactory.new(args)
          expect(factory.model.name).to eq model.name
          expect(factory.model.id).to eq model.id
          expect(factory.model.brand_id).to eq model.brand_id
        end
      end
      context "A model name for a non-existing model is given" do
        it "should have a new model with unknown brand" do
          model = @model_data[2]
          args = {
            :model_name => model.name+'new',
            :brand_scope=>@brand_scope,
            :model_scope=>@model_scope
          }
          factory = BikeModelFactory.new(args)
          expect(factory.model.name).to eq args[:model_name]
          expect(factory.model.id).to eq 0
          expect(factory.model.brand_id).to be_nil
        end
      end

      context "A model name for an existing model and a brand name is given" do
        it "should have a found model" do
          model = @model_data[2]
          args = {
            :model_name => model.name,
            :brand_name => 'test',
            :brand_scope=>@brand_scope,
            :model_scope=>@model_scope
          }
          factory = BikeModelFactory.new(args)
          expect(factory.model.name).to eq model.name
          expect(factory.model.id).to eq model.id
          expect(factory.model.brand_id).to eq model.brand_id
        end
      end

      

      # TODO more test cases, continuing on use case 0101


      context "A model_id for existing model is given" do
        it "should have model with the same id" do
          args = {
            :brand_scope=>@brand_scope,
            :model_scope=>@model_scope,            
            :model_id => '1'}
          factory = BikeModelFactory.new(args)
          expect(factory).to_not be_nil
          expect(factory.model).to_not be_nil
          expect(factory.model.id).to eq args[:model_id]
        end

        it "should take prefixed params" do
          args = {
            :brand_scope=>@brand_scope,
            :model_scope=>@model_scope,            
            :param_prefix => 'bike',
            :bike_model_id => '1'}
          factory = BikeModelFactory.new(args)
          expect(factory).to_not be_nil
          expect(factory.model).to_not be_nil
          expect(factory.model.id).to eq args[:bike_model_id]
        end
      end
      
    end


  end # modeul Model
end # module BikeMfg
