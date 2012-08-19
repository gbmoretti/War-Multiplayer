class Attack
  constructor: (@territories,@actionController,@callBackContext,@callBackFunction) ->
    @territories_id = null
    @movement_out = {}
    @movement_in = {}
    
    @divEndPhase = "<div style=\"text-align: right\"><button id=\"endphase\">Terminar fase</button></div>"
        
    $('button#endphase').live 'click', =>
      @callBackFunction.call(@callBackContext,@movement_in,@movement_out)
    
    @updateTerritories_id(@territories)
    
    #gera um vetor com a quantidade atual de tropas para saber quantas o jogador pode movimentar
    @total_movement = {}
    for t in @territories_id
      @total_movement[t] = parseInt($('#l' + t + ' tspan').text()) -1
    
    @chooseOrigin()

  updateTerritories_id: (territories) ->
    @territories_id = []
    for t in territories
      @territories_id.push(t.id)

  reset: () ->
    $('path').off("hover click") #retira eventos dos territorios
    $('path').attr('stroke-width',1)
    @chooseOrigin()

  chooseOrigin: () ->
    self = this
    @origin_id = null
    @destiny_id = null
    @actionController.open("Movimentação","Escolha um território para mover tropas" + @divEndPhase)

    #marcando bordas
    for id in @territories_id
      $('#' + id).hover(
       (o) ->  #handler in
          $(this).attr('stroke-width',2) unless @total_movement[id] == 0
        ,
        (o) -> #handler out
          $(this).attr('stroke-width',1) unless $(this).attr('id') == self.origin_id
      )

      $('#' + id).click((o) ->
        if @total_movement[id] > 1
          self.origin_id = $(this).attr('id')
          self.chooseDestiny()
      )

  chooseDestiny: () ->
    $('path').off("hover click") #retira eventos dos territorios
    self = this
    nome = @allTerritories[@origin_id].nome
    @actionController.open("Movimentação","Clique em um território vizinho para receber uma tropa." + @divEndPhase)

    #adiciona evento os vizinhos do pais de origem
    
    for t in @allTerritories[@origin_id].vizinhos
      if $.inArray(t,@territories_id)
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
          self.move(origin_id,destiny_id)
        )
    
  move: (origin,destiny) ->
    @movement_out[origin] = 0 unless @movement_out[origin] == undefined
    @movement_in[destiny] = 0 unless @movement_in[destiny] == undefined
    
    @movement_out[origin] += 1
    @movement_in[destiny] += 1

 
