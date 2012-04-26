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
    @name = 'warn'
    @params = { 'msg' => html_escaped(msg) }    
  end
end

class TxtMessage < Message
  def initialize(author,msg)
    @name = 'chat'
    @params = { 'author' => author.to_s, 
                'msg'    => html_escaped(msg) }
  end
end

class PlayerListMessage < Message
  def initialize(list)
    @name = 'player_list'
    @params = { 'list' => list }    
  end
end

class SetNewNick < Message
  def initialize
    @name = 'set_nick'
    @params = ''
  end
end

class ListRooms < Message
  def initialize(list)
    @name = 'rooms_list'
    @params = { 'list' => list }
  end
end


