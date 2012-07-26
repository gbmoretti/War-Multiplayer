class Game

  attr_reader :territories, :players, :jogador

  def initialize(room)
    @players = room.players
    @jogador = @players[0] #TIRA ISSO DAQUI DEPOIS
    @turn = 1
    @round = 1
    
    #cria 2 players fakes só para testes
    if @players.count == 1
      add_fake_player('bot1',room)
      add_fake_player('bot2',room)
    end
    
    #sorteia ordem dos jogadores
    @players.shuffle!
    
    #carrega territorios
    load_territories   
    
  end  

  def load_territories
    @territories = []
    defs = Definitions.get_instance
    t = defs.territories
    
    i = 0
    t['territories'].each do |k,v|
      @territories[(k.to_i)-1] = Territory.new(k,v['nome'],@players[i%@players.count])
      i += 1
    end
        
  end

  def add_fake_player(name,room)
    fake = Player.new(1,name)
    fake.color = Random.rand(4)+1
    fake.ready = true
    fake.room = room
    fake.id = Random.rand(96)+4
        
    @players.push fake
  end

end
