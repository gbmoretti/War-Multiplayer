
#TODO: Use Autoload gem

require 'redis'

SERVER_DIR = "./server/"

require SERVER_DIR + "messages/jsonable.rb"
require SERVER_DIR + "messages/messages.rb"
require SERVER_DIR + "models/player.rb"
require SERVER_DIR + "models/chat_log.rb"
require SERVER_DIR + "server_connection.rb"
require SERVER_DIR + "application.rb"
require SERVER_DIR + "controllers/app_controller.rb"
require SERVER_DIR + "controllers/chat_controller.rb"
require SERVER_DIR + "controllers/set_nick_controller.rb"



