class DefinitionsController
  
  constructor: (@app) ->
    @controllerName = 'definitions'
    @colors = null
    @territories = null  
  
          
  set_colors: (msg) ->
    console.log 'Recebendo lista de cores'
    @colors = msg.colors
    
  set_territories: (msg) ->
    console.log 'Recebendo lista de territórios'
    @territories = msg.territories
  
  get_colors: () ->
    @colors
    
  get_territories: () ->
    @territories
