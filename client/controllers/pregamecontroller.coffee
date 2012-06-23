class PregameController

  constructor: (@app) ->
    @controllerName = 'pregame'
    @modal = $('.modal-div#pregame')
    @players = @modal.find 'ul#players'
    @colorSelect = @modal.find 'select#colors'
    @title = null
    
    cs = @app.controllers
    console.log cs
    console.log cs['game']
    
    ###for k,color of @app.controllers['game'].colors
      console.log k + ' => ' + color ###
    
  open: (msg) ->     
    @app.openModal @modal    
    
  update: (msg) ->
    @modal.find('div#modal-title').html msg.name
    
    @players.html ''
    @updateplayers(msg.players)
        
  updateplayers: (list) ->
    for p in list
      @players.append "<li>#{p} <div class=\"color\" style=\"background-color: red;\">&nbsp;</div> <div class=\"turn\">&nbsp;</div
      ></li>" 
  
    
