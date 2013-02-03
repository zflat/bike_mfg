require 'spec_helper'
require 'bike_model_factory'

describe BikeModelFactory do
  it "should take a hash of arguments with specified scope" do
    args = {
      :model_id => '1',
      :brand_scope=>BikeBrand,
      :model_scope=>BikeModel
    }
    factory = BikeModelFactory.new(args)
    expect(factory).to_not be_nil
  end
end

class ModelFactoryAsserter

  def initialize(base)
    @base = base
    @model = BikeModel.all.first
    @brand = @model.brand if @model
  end

  def run(given_params, expected)
    params = generate_params(given_params)
    params.merge!({:param_prefix => :bike})
    factory = BikeModelFactory.new(params)
    expected_model = generate_expected_model(expected)
    @base.expect(factory.model).to @base.eq expected_model
  end

  # map a symbol argument to a model object
  def generate_expected_model(sym)
    case sym
      when :found then @model
      when :new then BikeModel.all.last
      when nil then nil
    end
  end

  private

  #
  # given paramaters in form of
  # [model_id, model_name, brand_id, brand_name]
  def generate_params(given)
    given ||= []
    {:model_id => generate_id(@model, given[0]),
      :model_name => generate_name(@model, given[1]),
      :brand_id => generate_id(@brand, given[2]),
      :brand_name => generate_name(@brand, given[3])}
  end

  def generate_id(scope, sym)
    return nil if scope.nil?
    if sym == :id
      scope.id
    else
      nil
    end
  end

  def generate_name(scope, sym)
    return nil if scope.nil?
    if sym == :name
      scope.name
    elsif sym == :new_name
      scope.name.to_s + " new text"
    else
      nil
    end
  end

end # class ModelFactoryAsserter

describe 'BikeModelFactory#model' do
  before :all do
    @a = ModelFactoryAsserter.new(self)
  end

  should = "should be nil"
  it should do @a.run(nil , nil) end
  
  should = "should be found"
  it should do @a.run([:id, 0, 0, 0],:found) end
  it should do @a.run([0, :name, 0, :name],:found) end
  it should do @a.run([0, :name, :id, 0],:found) end

  should = "should be new with nil brand"
  it should do @a.run([0, :new_name, 0, 0], :new) end
  it should do @a.run([0, :new_name, 0, :new_name], :new) end

  it "should be new with found brand"

  it "should be new with new brand"

end # describe BikeModelFactory#model
