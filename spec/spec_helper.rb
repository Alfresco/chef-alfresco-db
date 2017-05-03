require 'coveralls'
Coveralls.wear!

require 'chefspec'
require 'rspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.log_level = :error
end
