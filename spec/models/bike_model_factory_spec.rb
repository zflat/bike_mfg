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

  context "constructed with nil params" do
    let(:params){h={:model_id => nil,
        :model_name =>nil,
        :brand_id =>nil,
        :brand_name => nil,
      :param_prefix => :bike}}
    subject(:factory){BikeModelFactory.new(params)}
    it "is not nil" do
      expect(factory).to_not be_nil
    end
  end

  context "constructed with model name and brand name" do
    let(:params){h={:model_id => nil,
        :model_name =>'mymodelname',
        :brand_id =>nil,
        :brand_name => 'mybrandname',
      :param_prefix => :bike}}
    subject(:factory){BikeModelFactory.new(params)}
    it "is not nil" do
      expect(factory).to_not be_nil
    end
  end
end

class ModelFactoryAsserter

  def initialize(base, model=nil)
    @base = base
    @model = model || BikeModel.all.first
    @brand = @model.brand if @model
  end

  #
  # @params Array given_params used to generate the factory params
  # @params (:sym, [:sym, :sym]) expected as model_case or [model_case, brand_case] 
  def run(given_params, expected)
    params = generate_params(given_params)
    params.merge!({:param_prefix => :bike})

    brand_case = 0 # initialize to not nil
    model_case = 0 # initialize to not nil

    if expected.respond_to?(:to_sym)
      model_case = expected 
    elsif expected.respond_to?('to_a')
      model_case = expected.to_a[0] 
      brand_case = expected.to_a[1]
    end

    if model_case == :found
      factory = BikeModelFactory.new(params)
      @base.expect(factory.model).to_not @base.be_nil
      @base.expect(factory.model).to @base.eq @model

      if brand_case == :found
        @base.expect(factory.model.brand).to @base.eq @brand
      elsif brand_case.nil?
        @base.expect(factory.model.brand).to @base.be_nil
      end

    elsif model_case == :new
      factory = BikeModelFactory.new(params)
      
      @base.expect(factory.model).to_not @base.be_nil
      @base.expect(factory.model).to @base.be_valid
      
      if brand_case == :found
        @base.expect{ factory.model.save }.
          to @base.change{BikeModel.count + BikeBrand.count}.by(1)
        @base.expect(factory.model.brand).to_not @base.be_nil
      elsif brand_case == :new
        @base.expect{ factory.model.save }.
          to @base.change{BikeModel.count + BikeBrand.count}.by(2)      
        @base.expect(factory.model.brand).to_not @base.be_nil
      elsif brand_case == nil
        @base.expect{ factory.model.save }.
          to @base.change{BikeModel.count + BikeBrand.count}.by(1)      
        @base.expect(factory.model.brand).to @base.be_nil
      end
    elsif model_case.nil?
      factory = BikeModelFactory.new(params)
      @base.expect(factory.model).to @base.be_nil      
    elsif model_case == :exception
      e_thrown = false
      begin
        factory = BikeModelFactory.new(params)
      rescue Exception
        e_thrown = true
      end
      @base.expect(e_thrown).to @base.be_truthy
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
         when :new then scope.name.to_s + " new#{scope.class.count+1}"
           else nil
         end
    return id
  end

end # class ModelFactoryAsserter

describe 'BikeModelFactory#model' do
  before :all do
    model_with_brand = BikeModel.where{ bike_brand_id != nil}.first
    expect(model_with_brand).to_not be_nil
    @a = ModelFactoryAsserter.new(self, model_with_brand)

    model_without_brand = BikeModel.where{bike_brand_id == nil}.first
    expect(model_without_brand).to_not be_nil
    @b = ModelFactoryAsserter.new(self, model_without_brand)
    
    model_without_name = BikeModel.where{ name == '' }.first
    expect(model_without_name).to_not be_nil
    @c = ModelFactoryAsserter.new(self, model_without_name)

    unknown_model_with_brand = BikeModel.where{ (name == '') & (bike_brand_id != nil)}.first
    expect(unknown_model_with_brand).to_not be_nil
    @d = ModelFactoryAsserter.new(self, unknown_model_with_brand)
  end

  should = "should be nil"
  it should do @a.run(nil , nil) end
  it should do @a.run([0,0,0,0] , nil) end
  it should do @a.run([:missing,0,0,0] , nil) end
  
  should = "should be found"
  context "with brand" do
    it should do @a.run([:found, 0, 0, 0],:found) end
    it should do @a.run([0, :found, 0, :found],:found) end
    it should do @a.run([0, :found, :found, 0],[:found, :found]) end
  end
  context "without brand" do
    it should do @b.run([0, :found, 0, 0], [:found, nil]) end
  end
  context "model without name" do
    it should do @c.run([0, :found, :found, 0], :found) end
    it should do @c.run([0, :found, 0, :found], :found) end
    it should do @c.run([0, 0, :found, 0], [:found, :found]) end
    it should do @c.run([0, 0, 0, :found], [:found, :found]) end
  end
  
  should = "should be new with nil brand"
  it should do @a.run([0, :new, 0, 0], [:new, nil]) end

  should = "should be new with found brand"
  it should do @a.run([0, :new, :found, 0], [:new, :found]) end
  it should do @a.run([0, :new, 0, :found], [:new, :found]) end

  should = "should be found with found brand"
  it should do @d.run([0, 0, :found, 0], [:found, :found]) end
  it should do @d.run([0, 0, 0, :found], [:found, :found]) end

  should = "should be new with new brand"
  it should do @a.run([0, :new, 0, :new], [:new, :new]) end
  it should do @a.run([0, 0, 0, :new], [:new, :new]) end

  should = "should be new with new brand"
  it should do @d.run([0, 0, 0, :new], [:new, :new]) end
  
  should = "should raise exception"
  it should do @a.run([0, 0, :found, :found], :exception) end
  it should do @a.run([0, :found, :found, :found], :exception) end

  it should do @a.run([:found, 0, 0, :found], :exception) end
  it should do @a.run([:found, 0, :found, 0], :exception) end
  it should do @a.run([:found, 0, :found, :found], :exception) end
  it should do @a.run([:found, :found, 0, 0], :exception) end
  it should do @a.run([:found, :found, 0, :found], :exception) end
  it should do @a.run([:found, :found, :found, 0], :exception) end
  it should do @a.run([:found, :found, :found, :found], :exception) end

end # describe BikeModelFactory#model
