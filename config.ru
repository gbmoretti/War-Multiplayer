require 'rack/websocket'

require './load.rb'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/websocket',
                           :expire_after => 2592000,
                           :secret => 'que_eh_isso'

use Rack::Static,
  :root => "client"

app = Application.new
app.add_c ChatController.new(app)
app.add_c SetNickController.new(app)
app.add_c RoomsController.new(app)
app.add_c PregameController.new(app)
app.add_c DefinitionsController.new(app)
app.add_c GameController.new(app)

map '/websocket' do
  conn = ServerConnection.new(app)
  sessioned = Rack::Session::Pool.new(conn, 
    :domain => 'localhost',
    :expire_after => 2592000)
    
  run sessioned
end

map '/' do
  run lambda { |env|
    [
      200,
      {
        'Content-Type'  => 'text/html',
        'Cache-Control' => 'public, max-age=86400'
      },
      File.open('client/index.html', File::RDONLY)
    ]
  }
end