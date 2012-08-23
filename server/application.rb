class Application

  attr_reader :controllers

  def initialize
    @controllers = {}
    @clients = []
    @players = PlayersCollection.get_instance #talvez isso esteja errado (arquiterualmente falando)
    puts 'Aplicacao WarApp iniciada...'
  end
  
  #adiciona um controller a aplicacao
  def add_c(obj)
    @controllers[obj.name] = obj if obj.respond_to?(:name) and obj.name.is_a?(Symbol)
  end
  
  #vincula um cliente a algum objeto
  def bind_client(conn,obj)
    @clients.push({:conn => conn, :obj => obj})
  end
  
  def unbind_client(o)
    @clients.each do |c|
      @clients.delete(c) if c[:obj] = o
    end
  end
  
  def get_conn(o)
    cr = nil
    @clients.each do |c|
      cr = c[:conn] if c[:obj] == o 
    end
    return cr
  end
  
  def get_client(conn)
    cr = nil
    @clients.each do |c|
      cr = c[:obj] if c[:conn] == conn 
    end
    return cr
  end
  
  def broadcast(msg,ignore=[])
    @clients.each do |c|
      c[:conn].send_msg(msg) unless ignore.include?(c[:obj])
    end
  end
  
  def send(o,msg)
    array = o.is_a?(Array)
    @clients.each do |c|
      if array
        c[:conn].send_msg(msg) if o.include?(c[:obj])
      else
        c[:conn].send_msg(msg) if c[:obj] == o
      end
    end
  end
  
  
  #events
  def new_conn(conn)
    #Percorre por todos os controllers chamando aqueles que implementam o método new_conn
    @controllers.each do |k,v|
      v.new_conn(conn) if v.respond_to?(:new_conn)
    end
    #########
  end
  
  def closed_conn(conn)
    #Percorre por todos os controllers chamando aqueles que implementam o método closed_conn
    @controllers.each do |k,v|
      v.closed_conn(conn) if v.respond_to?(:closed_conn)
    end
    #########
    
    p = get_client(conn)
    unless p.nil?
      @players.rem(p)
      unbind_client(p)
    end
  end
  
  #actions
  def message(msg,conn)
    #Exemplo de mensagem { controller: chat, action: send, params: { msg: 'exemplo' } }
    c = msg['controller'].to_sym
    a = msg['action'].to_sym
    p = msg['params']
    #puts "#{c}##{a}(#{p})"   
    
    #o = get_client(conn)   
    @controllers[c].__send__ a, conn, p if @controllers[c].respond_to?(a)
  end
end
