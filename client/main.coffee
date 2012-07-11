$ ->
  app = new AppController("ws://192.168.1.102:3000/websocket") 
  
  #adiciona os controllers da aplicação
  
  app.add_controller new ChatController app
  app.add_controller new GameController app  
  app.add_controller new PlayerListController app
  app.add_controller new SetNickController app
  app.add_controller new RoomsController app 
  app.add_controller new PregameController app
  
  
  #app.start()
  
  
  
 #manipulando svg
  $("#game").svg({
    onLoad: ->
      svg = $("#game").svg('get')
      svg.load('map.svg', {addTo: true,  changeSize: false})        
       
    settings: {}
    })
    
  svg = $("#game").svg('get') 

  $('path').live 'click', () ->
    c = $(this)
    console.log 'Clicou! ' + c.attr('id')
    c.attr('fill','#00DD00')
    
  $('path').live 'mouseenter', () ->
    c = $(this)
    c.attr('fill','#45DD54')
    
  $('path').live 'mouseleave', () ->
    c = $(this)
    c.attr('fill','#FFFFFF')
    
    
    
