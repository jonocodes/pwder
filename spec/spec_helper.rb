require 'rack/test'
require 'rspec'

require File.expand_path '../../app.rb', __FILE__

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.formatter = :documentation
  config.tty = true
  config.color = true
end
