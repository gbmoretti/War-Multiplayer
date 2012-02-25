class Application

  def initialize
    @controllers = {}
    @clients = []
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
    @clients.each do |c|
      c[:conn].send_msg(msg) if c[:obj] == o
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
    @controllers.each do |c|
      c.closed_conn(conn) if c.respond_to?(:closed_conn)
    end
    #########
  end
  
  #actions
  def message(msg,conn)
    #Exemplo de mensagem { controller: chat, action: send, params: { msg: 'exemplo' } }
    c = msg['controller'].to_sym
    a = msg['action'].to_sym
    p = msg['params']
    puts "#{c}##{a}(#{p})"   
    
    @controllers[c].__send__ a, conn, p
  end
end
