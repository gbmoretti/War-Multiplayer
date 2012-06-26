class ChangeColorMessage
  constructor: (i) ->
    @controller = 'pregame'
    @action = 'change_color'
    @params = {'color': i}

class PregameController
  constructor: (@app) ->
    @controllerName = 'pregame'
    @modal = $('.modal-div#pregame')
    @players = @modal.find 'ul#players'
    @colorSelect = @modal.find 'select[name=colors]'
    @title = null
    
    #event handlers
    @colorSelect.change (eventObject) =>
      index = $(eventObject.target).val()
      @app.conn.send new ChangeColorMessage(index)
    
  open: (msg) ->  
    #atualiza lista de cores
    for i,color of @app.controllers['game'].get_colors()
      @colorSelect.append("<option value=#{i} style=\"color: #{color.hex}\">#{color.name}</option>")
    
    @app.openModal @modal    
    
  update: (msg) ->
    @modal.find('div#modal-title').html msg.name
    
    @players.html ''
    @updateplayers(msg.players)
        
  updateplayers: (list) ->
    for p in list
      @players.append "<li>#{p} <div class=\"color\" style=\"background-color: red;\">&nbsp;</div> <div class=\"turn\">&nbsp;</div></li>"
  
    
