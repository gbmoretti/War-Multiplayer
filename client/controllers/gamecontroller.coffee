class GameController
  
  constructor: (@app) ->
    @controllerName = 'game'
    
  update_territories: (msg) ->
    console.log msg.length
    for t in msg
      console.log "Territorio #{t.id} pinta de #{@players[t.owner].color}"
    
    console.log "Nada que eu faça daqui pra baixo funciona?"
    
  update_players: (msg) ->
    @players = msg  
    console.log @players
