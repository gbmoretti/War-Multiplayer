class Client

  constructor: (addr) ->
    @listening = []
    @socket = new WSConnection addr
    
    @socket.on_msg = (msg) => 
      @listening[msg.name].call(this,msg.params) if @listening[msg.name]
      console.log('Nao estou ouvindo essa mensagem! ' + msg.name) unless @listening[msg.name]      
        
  send: (obj) ->
    @socket.send(obj)
      
  listen: (msg,func) -> 
    @listening[msg] = func
