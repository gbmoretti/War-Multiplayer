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
      rooms.push r.to_hash
    end
    
    @params = { 'list' => rooms }
  end
end

class PregameShow < Message
  def initialize(room)
    @controller = 'pregame'
    @action = 'open'
    @params = room.to_hash
  end
end


