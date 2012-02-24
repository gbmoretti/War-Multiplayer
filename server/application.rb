class Application

  def initialize
    @controllers = {}
    puts 'Aplicacao WarApp iniciada...'
  end
  
  #adiciona um controller a aplicacao
  def add_c(obj)
    @controllers[obj.name] = obj if obj.respond_to?(:name) and obj.name.is_a?(Symbol)
  end
  
  #events
  def new_conn(conn)
    conn.send_msg SetNewNick.new #envia mensagem para cliente enviar nick
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
