class RoomsController
  
  constructor: (@app) ->
    @controllerName = 'rooms'
    @modal = $('#rooms')
    @divList = @modal.find '#lista'
    @list 
    
      
  list: (msg) ->
    @list = msg.list
    
    console.log @list.length
    
    for sala in @list
      console.log sala 
    
    @divList.HTML '<li>Nenhuma sala encontrada</li>' if @list.size == 0
    
    @open()
    
  open: (msg) ->
    @app.openModal @modal
