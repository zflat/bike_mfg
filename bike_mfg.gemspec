lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bike_mfg/version'

Gem::Specification.new do |gem|
  gem.name          = "bike_mfg"
  gem.version       = BikeMfg::VERSION
  gem.authors       = ["William Wedler"]
  gem.email         = ["wwedler@riseup.net"]
  gem.description   = %q{Add bike brand and model information to an application}
  gem.summary       = %q{Bike brand and model information as a model, database migration, seed data, REST interface and more}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency(%q<rake>, [">= 0"])
  gem.add_development_dependency(%q<rspec>, [">= 1.3.0"])
  gem.add_development_dependency(%q<bundler>, ["~> 1.2"])
  gem.add_development_dependency( "squeel", "~> 1.0.14")
  gem.add_development_dependency( "rabl", ">= 0.6")
  gem.add_development_dependency( "oj", ">= 0")  

  gem.add_dependency( "squeel", "~> 1.0.14")
  gem.add_dependency( "rabl", ">= 0.6")
  gem.add_dependency( "oj", ">= 0")
end
