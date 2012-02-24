class InitMessage
  constructor: (nick) ->
    @controller = 'set_nick'
    @action = 'set'
    @params = {'nick': nick}   

class SetNickController
  constructor: (@app) ->
    @controllerName = 'setNick' 
    @modal = $('#login')
    @inputNick = $('#login input[type=text]')
    @btn = $('#login input[type=button]')
    
    #chama método para setar nick ao clicar no botao do modal
    @btn.click () =>
      @setNick()
      
    #chama método para setar nick ao apertar enter no input
    @inputNick.keydown (eventObject) =>
      @setNick() if eventObject.keyCode == 13 
    
  open: () ->
    #abre modal para definição do nick
    @app.openModal @modal 
  
  setNick: () ->
    if @inputNick.val() != ''
      @app.user = @inputNick.val()
      @app.conn.send new InitMessage(@app.user)
      @app.closeModal @modal
