class NewRoomMessage
  constructor: (name) ->
    @controller = 'rooms'
    @action = 'new_room'
    @params = {'name': name}

class JoinRoomMessage
  constructor: (sala) ->
    @controller = 'rooms'
    @action = 'join'
    @params = {'room': sala}

class RoomsController
  
  constructor: (@app) ->
    @controllerName = 'rooms'
    @modal = $('.modal-div#rooms')
    @listElmt = @modal.find 'ul'
    @btn = @modal.find 'button'
    @input = @modal.find 'input'
    @linkJoin = @modal.find 'ul a'
    @openBtn = $('#btnrooms')
        
    @btn.click () =>      
      @newRoom(@input.val()) if @input.val != ''  
    
    @openBtn.click () =>
      @open(null)
    
    @input.keydown (eventObject) =>
      @btn.click if eventObject.keyCode == 13
      
    @linkJoin.live 'click', (o) =>
      @joinRoom($(o.target).attr('sala'))
    
  list: (msg) ->
    list = msg.list
        
    @listElmt.html ''
    for sala in list
      @listElmt.append '<li class="sala">' + sala.name + ' <a href="#" class="join" sala=' + sala.id + '>entrar</a></li>'
    
    @listElmt.append '<li id="none">Nenhuma sala encontrada</li>' if list.length == 0
       
  open: (msg) ->
    @app.openModal @modal
    
  newRoom: (name) ->
    @app.conn.send new NewRoomMessage(name)
    @app.closeModal @modal
    
  joinRoom: (sala) ->
    @app.conn.send new JoinRoomMessage(sala)
    @app.closeModal @modal
        
    
