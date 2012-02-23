class Player
  attr_reader :conn, :nick

  def initialize(conn=nil,nick=nil)
    @conn = conn
    @nick = nick
  end
  
  def to_s
    nick
  end
  
  def send_msg(msg)
    @conn.send_msg(msg)
  end
  
end
