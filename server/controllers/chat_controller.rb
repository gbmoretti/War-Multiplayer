#Controller reponsável pelo chat da aplicação
class ChatController < AppController
  
  #construtor
  def initialize(app)
    super(app)
    @players = PlayersCollection.get_instance #pega singleton da coleção de jogadores
  end
  
  #recebe uma mensagem do cliente e repassa para todo os outros
  def send_msg(conn,args)
    p = @app.get_client(conn) #pega objeto Player da lista de clientes
    unless p.nil?
      @app.broadcast(Message.new('chat','txt',
            {'author' => CGI::escapeHTML(p.to_s), 'msg' => CGI::escapeHTML(args['msg'])}
            )) #envia a mensagem para todos os clientes
      log(p.nick,args['msg'])
    end
  end
  
  #método executado quando um cliente sai da aplicação
  def closed_conn(conn)
    p = @app.get_client(conn) #pega objeto Player da lista de clientes
    unless p.nil?
      @app.broadcast(Message.new('playerList','update',
            {'list' => @players.list}),[p]) #atualiza lista de jogadores online para todos os clientes
      @app.broadcast(Message.new('chat','warn',
            {'msg' => CGI::escapeHTML(p.to_s) + " saiu..."}),[p]) #envia aviso no chat que cliente saiu
    end
  end
  
  #define nome do controller
  def name
    :chat
  end
  
end
