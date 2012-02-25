LIST = 'chat_log' #nome da chave que guarda a lista de mensagens
MAX_MSG = 5 #tamanho maximo da lista

class ChatLog

  def self.get(n=5)
    a = []
    redis.llen(LIST).times do |i|
      a.push redis.lindex LIST, i
    end
    return a
  end

  def self.log(msg)
    redis.rpush LIST, msg
    redis.ltrim LIST, 1, MAX_MSG if redis.llen(LIST) > MAX_MSG
  end

  private
  def self.redis
    @@r ||= Redis.new
  end

end
