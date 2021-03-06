#encoding: utf-8
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
    
    sid = Random.rand(11111111..99999999)
    conn = FakeConnection.new(sid)
    super(conn,nick)
  end
  
  def todos_territorios
    @territorios ||= @room.game.territories
  end
  
  def todas_regioes
    @regioes = @room.game.regions
  end
  
  #métodos que DEVEM ser implementados pela IA
  
  #método chamado ao iniciar fase de troca
  def cards_phase
    #@controller.exchange_cards(@conn) para efetuar troca
    @controller.cards_end(@conn,nil)
  end
  
  #método chamado ao receber resultado de um troca
  def cards_result(resultado)
  end

  #chamado no inicio da fase de distribuição
  def distribuition_phase(bonus)
    #recebe como parametro o hash bonus. Com o seguinte formato:
    #bonus['troops'] => quantidade de tropas para distribuir em qualquer territorio seu
    #bonus[id_da_regiao] => quantidade de tropas para aquela regiao/continente
    
    distribuition = {} #hash para guardar os dados da distribuicao (distribuition[id_do_territorio] = qtd_tropas)
    
    bonus_tropas = bonus.delete('troops')
    #adiciona 1 exercito em cada territorio com pelo menos 1 vizinho de inimigo até acabar o bonus
    territorios = get_territories
    max = territorios.size
    i = 0
    while bonus_tropas > 0
      if vizinhos_inimigos(territorios[i%max]).size > 0
        distribuition[territorios[i%max].id] = 0 if distribuition[territorios[i%max].id].nil?
        distribuition[territorios[i%max].id] += 1
        bonus_tropas -= 1
      end
      i += 1
    end
    
    #adiciona 1 exercito em cada territorio com pelo menos 1 vizinhos inimigo até acabar o bonus
    bonus.each do |r_id,qtd|
      regiao = todas_regioes[(r_id.to_i)-1]
      max_territorios = regiao.territories.size
      i = 0
      while qtd > 0
        territorio = get_pais(regiao.territories[i%max_territorios])
        if vizinhos_inimigos(territorio).size > 0
          distribuition[territorio.id] = 0 if distribuition[territorio.id].nil?
          distribuition[territorio.id] += 1
          qtd -= 1
        end
        i += 1
      end
      
    end
    
    @controller.distribution_end(@conn,{'territories' => distribuition})
  end
  
  #chamado no inicio da fase de ataque
  def attack_phase
    
    #encontra o territorio com mais exercitos
    territorios = get_territories.clone
    territorios.sort! { |a,b| b.troops <=> a.troops }
    
    if territorios[0].troops == 1
      @controller.attack_end(@conn,nil)
      return
    else
      origem = territorios[0]

      #encontra territorio inimigo com menos tropas
      alvos = vizinhos_inimigos(origem)
      
      if alvos.size == 0 
        @controller.attack_end(@conn,nil)
        return
      end
      alvos.sort! { |a,b| a.troops <=> b.troops }  
      
      alvo = alvos[0]
      
      
      order = {'origin' => origem.id, 'destiny' => alvo.id, 'qtd' => origem.troops-1}
      @controller.attack_order(@conn,order)
    end
    
    
    
    #usar @controller.attack_order() para fazer um ataque
    #usar @controller.attack_end() para terminar fase de ataque
  end
  
  #chamado depois que o resultado de um ataque é calculado
  def attack_result(result)
    attack_phase
  end
  
  #chamado no inicio da fase de movimentação
  def movement_phase
    @controller.movement_end(@conn,{'m' => {}})
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
    while encontra_jogadas.count > 0
      melhor = melhor_jogada(jogadas)
    end
  end
  
  def encontra_jogadas
    jogadas = []
    get_territories.each do |t|
      if t.troops > 1
        t.vizinhos do |v|          
          qtd = t.troops-1 > 3 ? 3 : t.troops-1
          jogadas.push({'origin' => t.id, 'destiny' => v.id, 'qtd' => qtd})
        end
      end
    end
    return jogadas
  end
  
  def melhor_jogada(jogada)
    #objetivo.js linha 9
  end
  
  #########
  #retorna um vetor com todos os territorios vizinhos que sao controlados por um inimigo
  def vizinhos_inimigos(territorio)
    r = []
    territorio.vizinhos.each do |v|
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
  
  #pega objeto territorio pelo ID dele
  def get_pais(id)
    todos_territorios[(id.to_i)-1]
  end
  
end
