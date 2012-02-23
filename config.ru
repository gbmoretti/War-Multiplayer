#require 'rubygems'
require 'rack/websocket'

require './load.rb'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/websocket',
                           :expire_after => 2592000,
                           :secret => 'que_eh_isso'

map '/' do
  f = File.expand_path(File.dirname(__FILE__)) + '/client/'
  puts "Procurando em: " + f
  run Rack::File.new(f)
end

map '/websocket' do
  conn = ServerConnection.new
  sessioned = Rack::Session::Pool.new(conn, 
    :domain => 'localhost',
    :expire_after => 2592000)
    
  run sessioned
end
