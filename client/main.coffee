$ ->
  #manipulando svg
  $("#game").svg({
    onLoad: ->
      svg = $("#game").svg('get');
      svg.load('map.svg', {addTo: true, changeSize: false});
        
    settings: {}
    }) 
  
  client = new Client("ws://192.168.1.102:3000/websocket")
  
  #mensagem para imprimir na tela do chat
  client.listen 'chat', (msg) -> 
    chat_window = $('div#chat')
    chat_window.append "&lt;#{msg.author}&gt; #{msg.msg}<br/>"    
  
  #mensagem para imprimir na tela do chat como warning
  client.listen 'warn', (msg) ->
    chat_window = $('div#chat')
    chat_window.append "<span class=warn>#{msg.msg}</span><br/>"    
 
  #abrir janela para setar nick
  client.listen 'set_nick', (msg) ->
    l_el = $('div#login')
    nick_modal = new Modal($('div#login'))
    
    nick_modal.open();    
    
    l_el.find('input[type=button]').click () =>
      n = l_el.find('input[type=text]').val()
      @send {controller: 'set_nick', action: 'set', params: {nick: n }} if n != ''
      nick_modal.close();
      
    l_el.find('input[type=text]').keydown (eventObj) =>
      if eventObj.keyCode == 13 
        n = l_el.find('input[type=text]').val()
        @send {controller: 'set_nick', action: 'set', params: {nick: n }} if n != ''
        nick_modal.close();        
    
    $('div#login').find('input[type=text]').focus();
      
  #abrir janela para mostrar lista de salas
  client.listen 'rooms', (msg) ->
    console.log('OPEN_ROOMS ' + msg.list)
    
  #recebendo lista de jogadores
  client.listen 'player_list', (msg) ->  
    console.log('PLAYER_LIST ' + msg)
  
  #recebe lista de salas
  client.listen 'rooms_list', (msg) ->
    console.log('ROOMS_LIST', msg)


