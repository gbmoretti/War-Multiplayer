class Game

  def initialize(room)
    @players = room.players
    
    #cria 2 players fakes só para testes
    if @players.count == 1
      add_fake_player(room)
      add_fake_player(room)
    end
    
    #sorteia ordem dos jogadores
    @players.shuffle!
    
    #carrega territorios
    load_territories   
    
    puts @territories.inspect
  end

  def load_territories
    @territories = {}
    defs = Definitions.get_instance
    t = defs.territories
    
    i = 0
    t['territories'].each do |k,v|
      @territories[k] = {:troops => 0, :owner => i%@players.count}
      i += 1
    end
    
  end

  def add_fake_players(room)
    fake = Player.new(1,'bot')
    fake.color = 3
    fake.ready = true
    fake.room = room
        
    @players.push fake
  end

end
