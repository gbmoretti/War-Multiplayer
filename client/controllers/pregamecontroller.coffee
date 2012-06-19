class PregameController

  constructor: (@app) ->
    @controllerName = 'pregame'
    @modal = $('.modal-div#pregame')
    @players = @modal.find 'ul#players'
    
    
  open: (msg) ->
    @modal.find('div#modal-title').html msg.name
    
    for p in msg.players
      @players.append "<li>#{p} <div class=\"color\" style=\"background-color: red;\">&nbsp;</div> <div class=\"turn\">&nbsp;</div></li>"
    
  
    @app.openModal @modal
    
