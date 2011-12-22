#require 'rubygems'
require 'rack/websocket'

require './warserver.rb'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/websocket',
                           :expire_after => 2592000,
                           :secret => 'que_eh_isso'

map '/' do
  run Rack::File.new(File.expand_path(File.dirname(__FILE__)) + '/')
end

map '/websocket' do
  app = WarServer.new
  sessioned = Rack::Session::Pool.new(app, 
    :domain => 'localhost',
    :expire_after => 2592000)
    
  run sessioned
end
