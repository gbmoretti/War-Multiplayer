class Movement
  constructor: (@territories,@allTerritories,@actionController,@callBackContext,@callBackFunction) ->
    @territories_id = null
    @movement = {}
    
    @divEndPhase = "<div style=\"text-align: right\"><button id=\"endmovement\">Terminar fase</button></div>"
        
    $(document).on 'click', 'button#endmovement', =>
      @endPhase()
    
    @updateTerritories_id(@territories)
    
    #gera um vetor com a quantidade atual de tropas para saber quantas o jogador pode movimentar
    @total_movement = {}
    for t in @territories
      @total_movement[t.id] = parseInt($('#l' + t.id + ' tspan').text())
      @total_movement[t.id] -= 1
    
    @chooseOrigin()

  endPhase: () ->
    $('button#endmovement').off("click")
    $("path").off("hover click")
    @actionController.close()
    @callBackFunction.call(@callBackContext,@movement)

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

    $("path").off("hover click")

    #marcando bordas
    for id in @territories_id
      $('#' + id).hover(
       (o) ->  #handler in
          t_id = $(this).attr('id')
          $(this).attr('stroke-width',2) unless self.total_movement[t_id] == 0
        ,
        (o) -> #handler out
          $(this).attr('stroke-width',1) unless $(this).attr('id') == self.origin_id
      )

      $('#' + id).click((o) ->
        t_id = $(this).attr('id')
        if self.total_movement[t_id] != undefined or self.total_movement[t_id] > 1
          self.origin_id = $(this).attr('id')
          self.chooseDestiny()
      )

  chooseDestiny: () ->
    $('path').off("hover click") #retira eventos dos territorios
    self = this
    nome = @allTerritories[@origin_id].nome
    @actionController.open("Movimentação","Clique em um território vizinho ao #{nome} para receber uma tropa." + @divEndPhase)
    
    #adiciona evento aos vizinhos do pais de origem    
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
          if $(this).attr('id') == self.origin_id
            self.reset()
          
          self.destiny_id = $(this).attr('id')
          self.move(self.origin_id,self.destiny_id)
        )
    
  move: (origin,destiny) ->
    return @reset() if @total_movement[origin] == 0
    
    @total_movement[origin] -= 1
    
    @movement[origin] = {} unless @movement[origin] != undefined
    @movement[origin][destiny] = 0 unless @movement[origin][destiny] != undefined
    @movement[origin][destiny] += 1
   
    t = $("#l" + origin + " tspan")
    total = parseInt(t.text())
    total -= 1
    t.text(total)
    t = $("#l" + destiny + " tspan")
    total = parseInt(t.text())
    total += 1
    t.text(total)
    
    @chooseDestiny()
    

 
