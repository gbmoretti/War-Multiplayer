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
    @chooseOrigin()

  chooseOrigin: () ->
    @origin_id = null
    @destiny_id = null
    @actionController.open("Ataque","Escolha um território para ser a origem do ataque")

	  #marcando bordas
    $('path').hover(
     (o) =>  #handler in
        $(o.currentTarget).attr('stroke-width',2) if $.inArray($(o.currentTarget).attr('id'),@territories_id)
      ,
      (o) => #handler out
        $(o.currentTarget).attr('stroke-width',1) unless $(o.currentTarget).attr('id') == @origin_id
    )

    $('path').click((o) =>
      @origin_id = $(o.currentTarget).attr('id')
      @chooseDestiny()
    )

  chooseDestiny: () ->
    $('path').off("hover click") #retira eventos dos paises

    nome = @allTerritories[@origin_id].nome
    @actionController.open("Ataque","Escolha um território alvo<br/>Atacando de <b>#{nome}</b>")

    #adiciona evento os vizinhos do pais de origem
    $('path').hover(
      (o) => #handler in
        $(o.currentTarget).attr('stroke-width',2) if $.inArray($(o.currentTarget).attr('id'),@allTerritories[@origin_id].vizinhos)
      ,
      (o) => #handler out
        $(o.currentTarget).attr('stroke-width',1) unless $(o.currentTarget).attr('id') == @destiny_id
      )

    $('path').click((o) =>
      @destiny_id = $(o.currentTarget).attr('id')
      @attackWindow()
    )

  attackWindow: () ->
    $('path').off("hover click") #retira eventos dos paises
    @actionController.hide()

    @nomeAtk.text @allTerritories[@origin_id].nome
    @nomeDef.text @allTerritories[@destiny_id].nome
    @troopsAtk.text $('#l' + @origin_id + ' tspan').text()
    @troopsDef.text $('#l' + @destiny_id + ' tspan').text()
    qtd_troops = parseInt($('#l' + @origin_id + ' tspan').text()) -1

    qtd_troops = 3 if qtd_troops > 3

    @selectTroops.html ""
    while qtd_troops > 0
      @selectTroops.append "<option value=\"#{qtd_troops}\">#{qtd_troops}</option>"
      qtd_troops--
    @app.openModal @modal
