class Distribuition

  constructor: (@bonus,@territories,@actionController,@callBack) ->
    @distribuition = {}
    
    @update_action()
  
    #adiciona evento de clique nos paises que pertecem a esse jogador
    for i,t of @territories
      #efeito de marcar borda
      $('path#' + t.id).hover( 
        (o) -> #handler in
          $(this).attr('stroke-width',2)
        ,
        (o) -> #handler out
          $(this).attr('stroke-width',1)        
        )
      #evento do clique    
      $('path#' + t.id).click((o) =>
        @add_troop(o.currentTarget.id)
      )
  
  add_troop: (id) ->
    if @bonus > 0
      @bonus--
      @distribuition[id] = @distribuition[id] + 1
      o = $('#l' + id + " tspan")
      x = o.text()
      o.text(parseInt(x) + 1)
      @update_action()
    
    @callBack.call(@distribuition) if @bonus == 0       
    
      
  update_action: (b) ->
    msg = "Você tem #{@bonus} tropas para distribuir. Clique nos países para colocar as tropas." if @bonus > 0
    msg = "Acabou essa fase. Passando para a proxima..." if @bonus == 0
    @actionController.open('Distribuição',msg)
    
      
       
