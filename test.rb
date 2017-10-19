ENV['RACK_ENV'] = 'test'

# require 'app'
require 'test/unit'
require 'rack/test'


require File.expand_path 'app.rb', __FILE__

class Test < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def get_static_asset
    get '/static/pwd.js'
    assert last_response.ok?
  end

  def get_missing_static_asset
    get '/static/non-existing-file'
    assert last_response.ok?
  end

end
