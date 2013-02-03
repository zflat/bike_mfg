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

  #
  # @params Array given_params used to generate the factory params
  # @params (:sym, [:sym, :sym]) expected as model_case or [model_case, brand_case] 
  def run(given_params, expected)
    params = generate_params(given_params)
    params.merge!({:param_prefix => :bike})

    model_case = expected if expected.respond_to?(:to_sym)
    model_case = expected[0] if expected.respond_to?('[]')
    
    if model_case == :found
      factory = BikeModelFactory.new(params)
      @base.expect(factory.model).to @base.eq @model
    elsif model_case == :new
      factory = nil
      @base.expect{factory = BikeModelFactory.new(params)}.
        to @base.change{BikeModel.count}.by(1)      

      brand_case = expected[1]
      if brand_case == nil
        @base.expect(factory.model.brand).to @base.be_nil
      end
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

  # @params (nil, :found, :missing) sym id param case
  def generate_id(scope, sym)
    return nil if scope.nil?
    id = case sym
         when :found then scope.id
         when :missing then 0
         else nil
         end
    return id
  end

  # @params (nil, :found, :new) sym name param case
  def generate_name(scope, sym)
    return nil if scope.nil?
    id = case sym
           when :found then scope.name
           when :new then scope.name.to_s + " new"
           else nil
         end
    return id
  end

end # class ModelFactoryAsserter

describe 'BikeModelFactory#model' do
  before :all do
    @a = ModelFactoryAsserter.new(self)
  end

  should = "should be nil"
  it should do @a.run(nil , nil) end
  
  should = "should be found"
  it should do @a.run([:found, 0, 0, 0],:found) end
  it should do @a.run([0, :found, 0, :found],:found) end
  it should do @a.run([0, :found, :found, 0],:found) end

  should = "should be new with nil brand"
  it should do @a.run([0, :new, 0, 0], [:new, nil]) end
  it should do @a.run([0, :new, 0, :new], [:new, nil]) end

  it "should be new with found brand"

  it "should be new with new brand"

end # describe BikeModelFactory#model
