class EndDistributionMessage
  constructor: (id,d) ->
    @controller = 'game'
    @action = 'distribution_end'
    @params = {'id': id, 'territories': d}

class EndAttackMessage
  constructor: (id) ->
    @controller = 'game'
    @action = 'attack_end'
    @params = {'id': id}
    
class EndMovementMessage
  constructor: (id,m) ->
    @controller = 'game'
    @action = 'movement_end'
    @params = {'id': id, 'm': m}

class GameController
  constructor: (@app) ->
    @controllerName = 'game'
    @roomid = null
    @playerid = null
    @roomname = null
    @rightbar = $('div#rightbar')
    @territories = null
    @cards = null
    @objective = null
    @phase = null
    @attackController = null


  #fases
  distribution: (msg) ->
    distribution = new Distribution(msg.bonus,@territories,@app.controllers['action'],this,
    ((d) ->
      @app.conn.send(new EndDistributionMessage(@roomid,d))
      distribution = null
    ))

  attack: (msg) ->
    @attackController = new Attack(@app,@app.controllers['definitions'].get_territories(),@territories,@app.controllers['action'],this,
    (() ->
      @app.conn.send(new EndAttackMessage(@roomid))
      @attackController = null
    ))

  attack_result: (msg) ->
    @attackController.attackWindow(msg)

  movement: (msg) ->
    movement = new Movement(@territories,@app.controllers['definitions'].get_territories(),@app.controllers['action'],this,
    ((m) ->
      @app.conn.send(new EndMovementMessage(@roomid,m))
    ))

  update_status: (msg) ->
    @territories = msg.territories
    @phase = msg.phase
    @playerid = msg.id

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
    #atualiza territorios do controller de ataque se ele estiver ativo
    @attackController.updateTerritories_id(@territories) unless @attackController == null 

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

  update_room_data: (msg) ->
    @roomname = msg.name
    @roomid = msg.id

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

    #muda a cor do tspan se nao ficar legivel em preto
    if color ==  '#0000DD' || color == '#333333'
      $('#l' + id + ' tspan').attr('fill','#FFFFFF')
      $('#l' + id + ' tspan').attr('stroke','#FFFFFF')

  change_troops: (id,troops) ->
    o = $('#l' + id)
    o.find('tspan').text troops  
