
class AppController

  def initialize
    puts 'Controlller iniciado... ' + self.to_s
    @@players ||= []
  end

  def default(args,conn)
    puts 'NoAction ' << args.to_s
  end
  
  def player_by_conn(c)
    i = @@players.rindex { |x| x.conn == c }
    @@players[i] unless i.nil?
  end
  
  def broadcast(msg,ignore=[])
    @@players.each do |p|
      p.send_msg(msg) unless ignore.include?(p)
    end
  end
  
end
  
