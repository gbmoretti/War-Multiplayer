$ ->
  @app = new AppController("ws://192.168.1.102:3000/websocket") 
  
  #carrega o mapa SVG
  $("#game").svg({
    onLoad: ->
      svg = $("#game").svg('get')
      svg.load('map.svg', {addTo: true, changeSize: false})
       
    settings: {}
  })
  
  svg = $("#game").svg('get')


  
  #adiciona os controllers da aplicação
  @app.add_controller new ChatController @app
  @app.add_controller new DefinitionsController @app  
  @app.add_controller new PlayerListController @app
  @app.add_controller new SetNickController @app
  @app.add_controller new RoomsController @app 
  @app.add_controller new PregameController @app
  @app.add_controller new GameController @app
  @app.add_controller new ActionController @app
  
  @app.start()
    
    
    
