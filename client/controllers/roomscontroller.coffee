class NewRoomMessage
  constructor: (name) ->
    @controller = 'rooms'
    @action = 'new_room'
    @params = {'name': name}

class RoomsController
  
  constructor: (@app) ->
    @controllerName = 'rooms'
    @modal = $('.modal-div#rooms')
    @listElmt = @modal.find 'ul'
    @btn = @modal.find 'button'
    @input = @modal.find 'input'
    
    @btn.click () =>      
      @newRoom(@input.val()) if @input.val != ''  
    
    @input.keydown (eventObject) =>
      @btn.click if eventObject.keyCode == 13
      
  list: (msg) ->
    @list = msg.list
        
    for sala in @list
      console.log sala 
      @listElmt.append '<li id="sala">' + sala + '</li>'
    
    @listElmt.append '<li id="none">Nenhuma sala encontrada</li>' if @list.length == 0
       
    @open()
    
  open: (msg) ->
    @app.openModal @modal
    
  newRoom: (name) ->
    console.log 'Criando nova sala com o nome de ' + name
    @app.conn.send new NewRoomMessage(name)
    
    
    
