$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib/bike_mfg'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app/models'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'machinist/active_record'

I18n.enforce_available_locales = false

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
