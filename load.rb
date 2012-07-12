
#TODO: Use Autoload gem

require 'redis'
require 'cgi'

SERVER_DIR = "./server/"

require SERVER_DIR + "includes/jsonable.rb"
require SERVER_DIR + "includes/messages.rb"

require SERVER_DIR + "models/player.rb"
require SERVER_DIR + "models/chat_log.rb"
require SERVER_DIR + "models/room.rb"
require SERVER_DIR + "models/game.rb"
require SERVER_DIR + "models/bucket.rb"
require SERVER_DIR + "models/players_bucket.rb"
require SERVER_DIR + "models/rooms_bucket.rb"

require SERVER_DIR + "server_connection.rb"

require SERVER_DIR + "application.rb"

require SERVER_DIR + "controllers/app_controller.rb"
require SERVER_DIR + "controllers/chat_controller.rb"
require SERVER_DIR + "controllers/set_nick_controller.rb"
require SERVER_DIR + "controllers/rooms_controller.rb"
require SERVER_DIR + "controllers/pregame_controller.rb"
require SERVER_DIR + "controllers/game_controller.rb"



