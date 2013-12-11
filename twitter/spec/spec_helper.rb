$: <<  File.expand_path('../',File.dirname(__FILE__))
require 'rack/test'
require 'bundler/setup'

Bundler.require :test, :development

require 'app'
module AppHelper

  def app
    TwitterBackshop
  end

end

RSpec.configure do |config|

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :timeline 

  config.order = 'random'
  config.include AppHelper
  config.include Rack::Test::Methods

  config.after(:each) do 
    Redis.new.flushdb
  end

end
