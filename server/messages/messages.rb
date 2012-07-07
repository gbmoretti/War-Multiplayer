require 'cgi'

#Classes que encapsulam os dados a serem enviados ao cliente
#Todas as classes herdadas de JSONable respondem aos métodos #to_json e #from_json!

#classe pai de todas as mensagens enviadas ao cliente
class Message < JSONable
    
  def each
    self.instance_variables.each do |v|
      puts "Message#each: #{v}"
      yield v, self.instance_variable_get(v)
    end
  end
  
  def html_escaped(str)
    CGI.escapeHTML(str)
  end    
end

class WarnMessage < Message
  def initialize(msg)
    @controller = 'chat'
    @action = 'warn'
    @params = { 'msg' => html_escaped(msg) }    
  end
end

class TxtMessage < Message
  def initialize(author,msg)
    @controller = 'chat'
    @action = 'txt'    
    @params = { 'author' => author.to_s, 
                'msg'    => html_escaped(msg) }
  end
end

class PlayerListMessage < Message
  def initialize(list)
    @controller = 'playerList'
    @action = 'update'
    @params = { 'list' => list }    
  end
end

class SetNewNick < Message
  def initialize
    @controller = 'setNick'
    @action = 'open'
    @params = ''
  end
end

class ListRooms < Message
  def initialize(list)
    @controller = 'rooms'
    @action = 'list'
    
    rooms = []
    list.each do |r|
      players = []
      
      r.players.each do |p|
        players.push({
            'nick' => p.nick,
            'color' => p.color,
            'ready' => p.ready
          }
        )
      end
      
      rooms.push({
        'id' => r.id,       
        'name' => r.name,
        'owner' => r.owner,
        'size' => '8',
        'players' => players
        }
      )
    end
    
    @params = { 'list' => rooms }
  end
end

class OpenListRooms < Message
  def initialize
    @controller = 'rooms'
    @action = 'open'
  end
end

class RoomUpdate < Message
  def initialize(room)
    @controller = 'pregame'
    @action = 'update'
    
    players = []
      
    room.players.each do |p|
      players.push({
          'nick' => p.nick,
          'color' => p.color,
          'ready' => p.ready
        }
      )
    end
    
    @params = {
      'id' => room.id,       
      'name' => room.name,
      'owner' => room.owner,
      'size' => '8',
      'players' => players
      }
  end
end

class PlayerUpdate < Message
  def initialize(p,i)
    @controller = 'pregame'
    @action = 'update_player'
    @params = {
      'index' => i,
      'nick' => p.nick,
      'color' => p.color,
      'ready' => p.ready
    }
  end
end

class PregameShow < Message
  def initialize
    @controller = 'pregame'
    @action = 'open'
    @params = ''
  end
end

class ColorsList < Message
  def initialize(c)
    @controller = 'game'
    @action = 'set_colors'
    @params = c
  end
end

