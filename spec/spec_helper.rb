RSPEC_ROOT = File.dirname(__FILE__)

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib/bike_mfg'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app/models'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'active_support'
require 'action_view'
require 'action_controller'
require 'rails'

require 'rspec/rails'
require 'machinist/active_record'
require 'rabl'
Rabl.configure do |config|
  config.view_paths = [$LOAD_PATH.unshift(File.join(RSPEC_ROOT, '..', 'app/views'))]
end

I18n.enforce_available_locales = false

require 'bike_brand'
require 'bike_model'
require 'bike_model_factory'
ActiveSupport::Dependencies::Loadable.unloadable BikeBrand
ActiveSupport::Dependencies::Loadable.unloadable BikeModel
ActiveSupport::Dependencies::Loadable.unloadable BikeModelFactory

class String
  def blank?
    strip.length == 0
  end
  def present?
    !blank?
  end
end

module ChainableScopeMethods
  [:where, :joins, :includes, :group].each do |method_name|
    define_method(method_name){self}
  end
  def new(params={})
    OpenStruct.new({:id=>0}.merge params)
  end
end

class ChainableScope
  include ChainableScopeMethods
  def all; [] end
end

# Use i18n-spec if locales are added to the gem
# require 'i18n-spec'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before(:suite) do
    Models.make
  end
end
