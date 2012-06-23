require 'rack/websocket'

require './load.rb'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/websocket',
                           :expire_after => 2592000,
                           :secret => 'que_eh_isso'

app = Application.new
app.add_c ChatController.new(app)
app.add_c SetNickController.new(app)
app.add_c RoomsController.new(app)
app.add_c PregameController.new(app)
app.add_c GameController.new(app)

map '/websocket' do
  conn = ServerConnection.new(app)
  sessioned = Rack::Session::Pool.new(conn, 
    :domain => 'localhost',
    :expire_after => 2592000)
    
  run sessioned
end

map '/' do
  f = File.expand_path(File.dirname(__FILE__)) + '/client/'
  run Rack::File.new(f)
end
