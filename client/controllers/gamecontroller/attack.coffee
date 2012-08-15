class AttackMessage
  constructor: (origin,destiny,qtd) ->
    console.log "Attack order!"
    @controller = 'game'
    @action = 'attack_order'
    @params = {'origin': origin, 'destiny': destiny, 'qtd': qtd}

class Attack
  constructor: (@app,@allTerritories,@territories,@actionController,@callBackContext,@callBackFunction) ->
    @territories_id = []
    for t in @territories
      @territories_id.push(t.id)

    @modal = $('.modal-div#attack')
    @nomeAtk = @modal.find '#nome_atk'
    @nomeDef = @modal.find '#nome_def'
    @troopsAtk = @modal.find '#troops_atk'
    @troopsDef = @modal.find '#troops_def'
    @selectTroops = @modal.find '#qtd_troops'
    @atkButton = @modal.find '#btnattack'
    @resultDiv = @modal.find '#result'
    
    @modal.find('.closebtn').click =>
      @reset()
    
    @chooseOrigin()

  reset: () ->
    console.log "Chamaram o reset!"
    $('path').off("hover click") #retira eventos dos territorios
    $('path').attr('stroke-width',1)
    @chooseOrigin()

  chooseOrigin: () ->
    self = this
    @origin_id = null
    @destiny_id = null
    @actionController.open("Ataque","Escolha um território para ser a origem do ataque")

    #marcando bordas
    for id in @territories_id
      $('#' + id).hover(
       (o) ->  #handler in
          $(this).attr('stroke-width',2) unless $(this).find("tspan").text() == 1
        ,
        (o) -> #handler out
          $(this).attr('stroke-width',1) unless $(this).attr('id') == self.origin_id
      )

      
      $('#' + id).click((o) ->
        if $(this).find("tspan").text() != 1
          self.origin_id = $(this).attr('id')
          self.chooseDestiny()
      )

  chooseDestiny: () ->
    $('path').off("hover click") #retira eventos dos territorios
    self = this
    nome = @allTerritories[@origin_id].nome
    @actionController.open("Ataque","Escolha um território alvo<br/>Atacando de <b>#{nome}</b>")

    #adiciona evento os vizinhos do pais de origem
    
    for t in @allTerritories[@origin_id].vizinhos
      $('#' + t).hover(
        (o) -> #handler in
          $(this).attr('stroke-width',2)
        ,
        (o) -> #handler out
          $(this).attr('stroke-width',1) unless $(this).attr('id') == self.destiny_id
      )

      $('#' + t).click((o) ->
        if self.allTerritories[$(this).attr('id')].owner == self.app.controllers['game'].playerid
          self.chooseOrigin()
        self.destiny_id = $(this).attr('id')
        self.attackWindow()
      )

  attackWindow: (result=null) ->
    $('path').off("hover click") #retira eventos dos territorios
    @actionController.close()

    @nomeAtk.text @allTerritories[@origin_id].nome
    @nomeDef.text @allTerritories[@destiny_id].nome
    @troopsAtk.text $('#l' + @origin_id + ' tspan').text()
    @troopsDef.text $('#l' + @destiny_id + ' tspan').text()
    qtd_troops = parseInt($('#l' + @origin_id + ' tspan').text())
    qtd_troops -= 1

    qtd_troops = 3 if qtd_troops > 3

    @selectTroops.html ""
    while qtd_troops > 0
      @selectTroops.append "<option value=\"#{qtd_troops}\">#{qtd_troops}</option>"
      qtd_troops--
    
    @resultDiv.html ""
    
    @app.openModal @modal
    
    @atkButton.off("click") #primeiro desliga o evento anterior pois o JQuery empilha os eventhandlers
    @atkButton.html("Atacar!")
    @atkButton.click =>
      @app.conn.send new AttackMessage(@origin_id,@destiny_id,@selectTroops.val())
    
    
    if result != null
      html = "Resultados do último ataque:<br/>"
      html += "#{@nomeAtk.text()} perdeu #{result.atk.lost} tropas (#{result.atk.dice[0]} / #{result.atk.dice[1]} / #{result.atk.dice[2]})<br/>"
      html += "#{@nomeDef.text()} perdeu #{result.def.lost} tropas (#{result.def.dice[0]} / #{result.def.dice[1]} / #{result.def.dice[2]})<br/>"
      @resultDiv.html(html)
      
      
      if result.winner != null
        @atkButton.html("Fechar")
        @atkButton.off("click") #primeiro desliga o evento anterior pois o JQuery empilha os eventhandlers
        @atkButton.click =>
          @app.closeModal @modal
          @reset()
    
