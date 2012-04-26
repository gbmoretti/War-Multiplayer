class WSConnection
  constructor: (@addr,@statusElmnt = $('div#status')) ->
    @socket = new WebSocket(@addr)

      
  send: (obj) ->
    msg = JSON.stringify(obj)
    console.log "Enviando #{msg}"
    @socket.send(msg)
    
  ###
   ** por algum motivo bisonho isso nao funciona
  ###
  on_close: (func) ->
    @socket.onclose = func
    refreshStatus()
  
  on_open: (func) ->
    @socket.onopen = func
    refreshStatus()
    
  on_message: (func) ->
    @socket.onmessage = (msg) =>
      console.log(msg)
      msg = eval("(#{msg})")
      func(msg)
    
  ### 
   ** até aqui
  ###
  
    
  refreshStatus: ->
    state = @socket.readyState
    console.log(state)
    @statusElmnt.removeClass()
    if state == 0 #conectando  
      @statusElmnt.addClass('connecting')
      @statusElmnt.html('conectando')
    if state == 1 #conectado
      @statusElmnt.addClass('online')
      @statusElmnt.html('conectado')
    if state == 2 or state == 3 #desconectando ou desconectado
      @statusElmnt.addClass('offline')
      @statusElmnt.html('DESCONECTADO')
   
    
    
