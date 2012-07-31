class GameController
  
  constructor: (@app) ->
    @controllerName = 'game'
    @roomname = null
    @rightbar = $('div#rightbar')
    
  update_territories: (msg) ->
    max = msg.length
    i = 0
    while i < max
      t = msg[i]
      owner = @players[t.owner]
      color = @app.controllers['definitions'].colors[owner.color]
      @change_color(t.id,color.hex)
      @change_troops(t.id,t.troops)
      i++
  
  update_room_name: (msg) ->
    @roomname = msg.name
    
  update_players: (msg) ->
    @players = msg
    @update_rightbar()
    
  update_rightbar: ->
    pl = @rightbar.find('div#playerslist')
    pl.html "<div id=\"title\">#{@roomname}</div>"
    for id,player of @players
      color = @app.controllers['definitions'].colors[player.color]
      pl.append "<div class=player>#{player.nick}</div>
      <div class=\"color\" style=\"background-color: #{color.hex};\"></div>
      <div class=\"turn\"></div>"
   
  change_color: (id,color) ->
    $('path#' + id).attr('fill', color) 
  
  change_troops: (id,troops) ->
    o = $('#l' + id)
    #console.log(o)
    o.find('tspan').html troops  
     

