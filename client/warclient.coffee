class Client

  constructor: (addr) ->
    @listening = []
    @socket = new WSConnection addr
      
    @socket.socket.onmessage = (msg) => 
      msg = eval("(#{msg.data})")
      @listening[msg.name].call(this,msg.params) if @listening[msg.name]
      console.log('Nao estou ouvindo essa mensagem! ' + msg.name) unless @listening[msg.name]      
     
    @socket.socket.onopen = () =>
      console.log 'Abriu!'
    
    @socket.socket.onclose = () =>
      console.log 'Fechou!'
        
  send: (obj) ->
    @socket.send(obj)
      
  listen: (msg,func) -> 
    @listening[msg] = func
