$ ->
  app = new AppController("ws://localhost:3000/websocket") 
  
  #adiciona os controllers da aplicação
  app.add_controller new ChatController app
  app.add_controller new PlayerListController app
  app.add_controller new SetNickController app
  app.add_controller new RoomsController app
  
  app.start()
  
  
  #manipulando svg
  $("#game").svg({
    onLoad: ->
      svg = $("#game").svg('get');
      svg.load('map.svg', {addTo: true,  changeSize: false});        
        
    settings: {}
    })  

  

     

    
