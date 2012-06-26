class GameController
  
  constructor: (@app) ->
    @controllerName = 'game'
    @colors = null    
        
  set_colors: (msg) ->
    console.log 'Recebendo lista de cores'
    @colors = msg.colors
    
  get_colors: () ->
    @colors
