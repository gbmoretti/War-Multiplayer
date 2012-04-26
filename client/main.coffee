$ ->
  client = new Client("ws://192.168.1.102:3000/websocket")
  
  #mensagem para imprimir na tela do chat
  client.listen 'print', (msg) -> 
    chat_window = $('div#chat')
    
    console.log('CHAT: ' + msg)
  
  #mensagem para imprimir na tela do chat como warning
  client.listen 'warn', (msg) ->
    chat_window = $('div#chat')
    
    console.log('WARN: ' + msg)  
 
  #abrir janela para setar nick
  client.listen 'set_nick', (msg) ->
    console.log('OPEN_SET_NICK: ' + msg)
    @send({controller: 'set_nick', action: 'set', nick: 'CLIENTE_BURRO' })
  
  #abrir janela para mostrar lista de salas
  client.listen 'rooms', (msg) ->
    console.log('OPEN_ROOMS ' + msg)
    
  #recebendo lista de jogadores
  client.listen 'player_list', (msg) ->  
    console.log('PLAYER_LIST ' + msg)
  
  #recebe lista de salas
  client.listen 'rooms_list', (msg) ->
    console.log('ROOMS_LIST', msg)

