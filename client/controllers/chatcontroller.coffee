class TxtMessage
  constructor: (@msg) ->
    @action = 'chat'
    @type = 'txt'
        
class InitMessage
  constructor: (@nick) ->
    @action = 'set_nick'    


class ChatController
  constructor: (@app) ->
    @controllerName = 'chat'
    @inputElmnt = $('div#chatinput input[type=text]') 
    @chatElmnt = $('div#chat')
    @inputElmnt.keydown (eventObject) =>
      @sendTxt() if eventObject.keyCode == 13 
  
  txt: (msg) -> #recebe um objeto com os atributos author e msg
    @chatElmnt.append '&lt' + msg.author + '&gt ' + msg.msg + '<br/>'
    @chatElmnt.scrollTop @chatElmnt.height() #baixa a barra de rolagem
  
  warn: (msg) -> #recebe objeto com atributo msg
    @chatElmnt.append '<span class="warn">' + msg.msg + '</span><br/>'
    @chatElmnt.scrollTop @chatElmnt.height() 
    
  sendTxt: ->
    txt = @inputElmnt.val()
    @app.conn.send new TxtMessage(txt)
    @inputElmnt.val ''
    

