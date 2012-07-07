class ChangeColorMessage
  constructor: (i) ->
    @controller = 'pregame'
    @action = 'change_color'
    @params = {'color': i}

class ToggleStateMessage
  constructor: () ->
    @controller = 'pregame'
    @action = 'toggle_state'
    @params = { }

class PregameController
  constructor: (@app) ->
    @controllerName = 'pregame'
    @modal = $('.modal-div#pregame')
    @players = @modal.find 'ul#players'
    @colorSelect = @modal.find 'select[name=colors]'
    @readyButton = @modal.find 'button#ready'
    @title = null
    
    @list = null
    
    #event handlers
    @colorSelect.change (eventObject) =>
      index = $(eventObject.target).val()
      @app.conn.send new ChangeColorMessage(index)
      
    @readyButton.click (eventObject) =>
      @app.conn.send new ToggleStateMessage()
    
    
  open: (msg) ->  
    #atualiza lista de cores
    @colorSelect.html ''
    for i,color of @app.controllers['game'].get_colors()
      @colorSelect.append("<option value=#{i} style=\"color: #{color.hex}\">#{color.name}</option>")
    
    @app.openModal @modal    
    
  update: (msg) ->
    @modal.find('div#modal-title').html msg.name
    
    @players.html ''
    
    @list = msg.players
    @update_list()
    
  update_player: (msg) ->
    
    @list[msg.index].nick = msg.nick
    @list[msg.index].color = msg.color
    @list[msg.index].ready = msg.ready
    
    @update_list()
    
  update_list: (list) ->
    @players.html ''
    for p in @list
      colors = @app.controllers['game'].get_colors()
      console.log(p)
      hex = colors[p.color].hex
      @players.append "<li>#{p.nick} <div class=\"color\" style=\"background-color: #{hex}\">&nbsp;</div> <div class=\"ready-state\" id=#{p.ready}>&nbsp;</div></li>"
  
    
