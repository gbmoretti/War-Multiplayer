class TxtMessage
  constructor: (msg) ->
    @controller = 'chat'
    @action = 'send_msg'
    @params = {'msg': msg}
        
class ChatController
  constructor: (@app) ->
    @controllerName = 'chat'
    
    #Objetos JQuery
    @inputElmnt = $('div#chatinput input[type=text]') 
    @chatElmnt = $('div#chat')
    @chatWindow= $('div#chat-window')
    @btnElmnt = $('div#btnchat')
    
    @chatWindow.hide(0) #janela de chat inicia fechada
    
    #eventos
    @inputElmnt.keydown (eventObject) =>
      @sendTxt() if eventObject.keyCode == 13       
   
    @btnElmnt.click (eventObject) =>
      @chatWindow.toggle(0)
  
  txt: (msg) -> #recebe um objeto com os atributos author e msg
    @chatElmnt.append '&lt' + msg.author + '&gt ' + msg.msg + '<br/>'
    @chatElmnt.scrollTop @chatElmnt.height() #baixa a barra de rolagem
    
    @animBtn()
     
  warn: (msg) -> #recebe objeto com atributo msg
    @chatElmnt.append '<span class="warn">' + msg.msg + '</span><br/>'
    @chatElmnt.scrollTop @chatElmnt.height() 
    
  sendTxt: ->
    txt = @inputElmnt.val()
    @app.conn.send new TxtMessage(txt)
    @inputElmnt.val ''
    
  animBtn: ->
    @btnElmnt.animate({
      'background-color': '#444'
    },'slow')
    
    @btnElmnt.animate({
      'background-color': '#000'
    },'slow')

