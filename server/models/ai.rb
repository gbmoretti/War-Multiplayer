class Ai < Player

  #atributos importantes herdados de Player
  #@phase    => A fase atual da IA
  #@objetivo => A carta-objetivo
  #@cards    => Um vetor com as cartas-território que a IA é dona
  #@trocas   => A quantidade de trocas que a IA já fez
  
  #métodos importantes herdados de Player
  #get_territories => recebe um vetor com os territórios dominados pela IA
  #get_troops      => quantidade total de tropas
  #get_bonus       => quantidade de tropas que irá ganhar no próximo turno
  
  def initialize(controller,nick)
    @controller = controller
    sid = Random.rand(11111111..99999999)
    super(sid,nick)
  end
  
  #métodos que DEVEM ser implementados pela IA
  
  #método chamado ao iniciar fase de troca
  def cards
    #@controller.exchange_cards para efetuar troca
    #@controller.cards_end()
  end
  
  #método chamado ao receber resultado de um troca
  def cards_result(resultado)
  end

  #chamado no inicio da fase de distribuição
  def distribuition(bonus)
    #@controller.distribuition_end()
  end
  
  #chamado no inicio da fase de ataque
  def attack
    #usar @controller.attack_order() para fazer um ataque
    #usar @controller.attack_end() para terminar fase de ataque
  end
  
  #chamado depois que o resultado de um ataque é calculado
  def attack_result(result)
  end
  
  #chamado no inicio da fase de movimentação
  def movement
    #usar @controller.movement_end() para terminar a fase
  end
  
end
