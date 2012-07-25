class GameController
  
  constructor: (@app) ->
    @controllerName = 'game'
    @colors = null
    @territories = null  
  
    #talvez eu nao va usar de verdade
    @pintar = {}
  
    #manipulando svg
    $("#game").svg({
      onLoad: ->
        svg = $("#game").svg('get')
        svg.load('map.svg', {addTo: true,  changeSize: false})        
         
      settings: {}
    })
    
    svg = $("#game").svg('get') 

    $('path').live 'click', (e) =>
      @apaga_pintura()
      
      c = $(e.currentTarget).attr('id')
      @pintar[c] = '#00AA00'    
      for i,v of @territories[c].vizinhos
        @pintar[v] = '#00FF00'
      
      @faz_pintura()
  
  faz_pintura: () ->
    for id,cor of @pintar
      $('#' + id).attr('fill', cor)
      
  apaga_pintura: () ->
    for id,cor of @pintar
      $('#' + id).attr('fill', '#FFFFFF')
      
    @pintar = {}
      
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
