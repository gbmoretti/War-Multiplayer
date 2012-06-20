class AppController
  constructor: (@wsAddr) ->
    @conn = null
    @user = 'nick'
    @controllers = {}
    
    #atribui método hideModal ao evento click do 'X' da janela modal
    self = this #gambiarrets
    $('.closebtn').click () ->  
      self.closeModal $(this).parent()
    
  add_controller: (obj) ->
    @controllers[obj.controllerName] = obj
  
  openModal: (elmnt) ->
    $('.modal-overlay').show()
    elmnt.show()
    
  closeModal: (elmnt) ->
    elmnt.hide()
    $('.modal-overlay').hide()
      
    
  start: () ->
    @conn = new WSConnection(@wsAddr)    
    
    #definindo event handlers da conexão
    @conn.socket.onopen = () =>
      @conn.refreshStatus()
      #@conn.send(new InitMessage(@user))      
    
    @conn.socket.onclose = () =>
      @conn.refreshStatus()
    
    @conn.socket.onmessage = (msg) => 
      msgObj = eval("(#{msg.data})")
      c_name = msgObj.controller
      #console.log "#{c_name}##{msgObj.action}(#{msgObj.params})"
      controller = @controllers[c_name]
      console.log controller
      controller[msgObj.action]() if msgObj.params == ''
      controller[msgObj.action](msgObj.params) if msgObj.params != ''
           
      
      
      
      
      
      
      
