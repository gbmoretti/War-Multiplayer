class WSConnection
  constructor: (@addr,@statusElmnt = $('div#status')) ->
    #if $.browser.mozilla
     # @socket = new MozWebSocket(@addr)
    #else
      @socket = new WebSocket(@addr)
      
  send: (obj) ->
    msg = JSON.stringify(obj)
    console.log "Enviando #{msg}"
    @socket.send(msg)
    
  on_close: (func) ->
    @socket.onclose = func.call
    refreshStatus()
  
  on_open: (func) ->
    @socket.onopen = func.call
    refreshStatus()
    
  on_message: (func) ->
    @socket.onmessage = (msg) =>
      msg = eval("(#{msg})")
      func(msg)
    
  refreshStatus: ->
    state = @socket.readyState
    @statusElmnt.removeClass()
    if state == 0 #conectando  
      @statusElmnt.addClass('connecting')
    if state == 1 #conectado
      @statusElmnt.addClass('online')
    if state == 2 or state == 3 #desconectando ou desconectado
      @statusElmnt.addClass('offline')
   
    
    
