$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib/bike_mfg'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'bike_mfg'

# Use i18n-spec if locales are added to the gem
# require 'i18n-spec'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end
