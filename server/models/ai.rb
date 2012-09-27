class Ai < Player

  #atributos importantes herdados de Player
  #@phase    => A fase atual da IA
  #@objetivo => A carta-objetivo
  #@cards    => Um vetor com as cartas-território que a IA é dona
  #@trocas   => A quantidade de trocas que a IA já fez
  #@conn     => Atributo que identifica o jogador para o controlador GameController
  
  #métodos importantes herdados de Player
  #get_territories => recebe um vetor com os territórios dominados pela IA
  #get_troops      => quantidade total de tropas
  #get_bonus       => quantidade de tropas que irá ganhar no próximo turno
  
  def initialize(controller,nick)
    @controller = controller
    @territorios = @controller.territories
    sid = Random.rand(11111111..99999999)
    super(sid,nick)
  end
  
  #métodos que DEVEM ser implementados pela IA
  
  #método chamado ao iniciar fase de troca
  def cards
    #@controller.exchange_cards(@conn) para efetuar troca
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
  
  #################################################
  #reescrevendo "literalmente" as funções do JS
  
  #encontra paises que nao tem nenhum vizinho inimigo e tem mais de um 1 tropa
  def encontra_pais_movimento
    get_territories.keep_if { |t| vizinhos_inimigos(t).empty? && t.troops > 1 }
  end
  
  def move
    possiveis = encontra_pais_movimento
    
    #encontra pais com maior importancia
    possiveis.each do |p|
      melhor = nil
      imp = 0
      p.vizinhos.each do |v|
        v = get_pais(v)
        if importancia(v) > imp
          imp = importancia(v)
          melhor = v
        end
        #movimenta todas as tropas possiveis para o pais mais importante
      end
    end   
  end
  
  def jogar
    #distribui_exercitos_continente()
    #distribui_exercitos()
    #joga()
    #move()
    #jogar()
  end
  
  def joga
    ##LINHA 156 do AI.js
  end
  
  def encontra_jogadas
    jogadas = []
    get_territories.each do |t|
      if t.troops > 1
        t.vizinhos do |v|
          qtd = t.troops-1 > 3 ? 3 : t.troops-1
          jogadas.push {'origin' => t.id, 'destiny' => v.id, 'qtd' => qtd}
        end
      end
    end
    return jogadas
  end
  
  #########
  #retorna um vetor com todos os territorios vizinhos que sao controlados por um inimigo
  def vizinhos_inimigos(territorio)
    r = []
    territorios.vizinhos.each do |v|
      v = get_pais(v)
      r.push v if v.owner != self
    end
    return r
  end
  
  #calcula importancia de um territorio
  def importancia(t)
    #fórmula para calculo de importancia
    ### quantidade de vizinhos dominados pelo inimigo + funcao impedeConquista
    ### se essa soma for 0, então usa a fórmula: 
    ### (distancia do inimigo mais proximo - 10) / 1000 
    
    ###### TODO: verificar como é "medida" essa distancia na classe de grafo do pereira #####
  end
  
  #pega objeto pais pelo ID dele
  def get_pais(id)
    @territorios[(id.to_i)-1]
  end
  
end
