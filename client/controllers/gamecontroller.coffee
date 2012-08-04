class GameController
  
  constructor: (@app) ->
    @controllerName = 'game'
    @roomname = null
    @rightbar = $('div#rightbar')
    @territories = null
    @cards = null
    @objective = null
    @phase = null
  
  
  #fases
  distribuition: (msg) ->
    bonus = msg.bonus
    
    @app.controllers['action'].open('Distribuição',"Você tem #{bonus} tropas para distribuir. Clique nos países para colocar as tropas.")
  
    #adiciona evento de clique nos paises que pertecem a esse jogador
    for i,t of @territories
      $('path#' + t.id).hover( 
        (o) -> #handler in
          console.log $(this)
          $(this).attr('stroke-width',2)
        ,
        (o) -> #handler out
          $(this).attr('stroke-width',1)        
        )
      $('path#' + t.id).click((o) ->
        @add_troop(t.id)
      )
  
  add_troop: (id) ->
    #como eu vou adicionar tropa agora? :(
  
  update_status: (msg) ->
    @territories = msg.territories
    @phase = msg.phase
    
    #atualiza status   
    status_bar = @rightbar.find('div#player-status .content')
    status_bar.html ''
    
    status_bar.append "<div class=\"status-line\">Exércitos: #{msg.troops}</div>"
    status_bar.append "<div class=\"status-line\">Bônus: #{msg.bonus}</div>"
    status_bar.append "<div class=\"status-line\">Territórios: #{@territories.length}</div>"      
    
    #atualiza cartas
    @cards = msg.cards
    str = "<div class=\"status-line\">Cartas: #{@cards}</div>"
    status_bar.append str
  
    #atualiza fase
    phase_line = @rightbar.find('div.phase-line')
    phase_line.each( (i,o) ->
      o = $(o)
      o.removeClass('active')
      o.removeClass('possibnext')
    )
    
    @rightbar.find('div.phase-line#phase' + @phase).addClass('active')  
    
  update_objective: (msg) ->
    @objective = msg.objective
    
    objective_bar = @rightbar.find('div#objetivo #texto-objetivo')
    objective_bar.html @objective
  
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
      player_line = "<div class=player>#{player.nick}</div>
      <div class=\"color\" style=\"background-color: #{color.hex};\"></div>
      <div class=\"turn\""
      player_line += " id=\"active\"" if player.turn 
      player_line += "></div>"
      pl.append player_line
   
  change_color: (id,color) ->
    $('path#' + id).attr('fill', color) 
  
  change_troops: (id,troops) ->
    o = $('#l' + id)
    #console.log(o)
    o.find('tspan').html troops  
     

