$ ->
  app = new AppController("ws://192.168.132.137:3000/websocket") 
  
  #adiciona os controllers da aplicação
  app.add_controller new ChatController app
  app.add_controller new PlayerListController app
  app.add_controller new SetNickController app
  app.add_controller new RoomsController app
  app.add_controller new PregameController app
  
  app.start()
  
  
  #manipulando svg
  $("#game").svg({
    onLoad: ->
      svg = $("#game").svg('get');
      svg.load('map.svg', {addTo: true,  changeSize: false});        
        
    settings: {}
    })  

  

     

    
