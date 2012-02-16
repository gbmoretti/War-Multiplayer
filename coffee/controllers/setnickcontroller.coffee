class InitMessage
  constructor: (@nick) ->
    @action = 'set_nick'

class SetNickController
  constructor: (@app) ->
    @controllerName = 'setNick' 
    @modal = $('#login')
    @inputNick = $('#login input[type=text]')
    @btn = $('#login input[type=button]')
    
    #chama método para setar nick ao clicar no botao do modal
    @btn.click () =>
      @setNick()
    
  open: () ->
    #abre modal para definição do nick
    @app.openModal @modal 
  
  setNick: () ->
    if @inputNick.val() != ''
      @app.user = @inputNick.val()
      @app.conn.send new InitMessage(@app.user)
      @app.closeModal @modal
