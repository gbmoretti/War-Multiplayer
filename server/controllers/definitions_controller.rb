#Controller responsável por enviar as definições do jogo aos jogadores conectados
class DefinitionsController < AppController
  
  def initialize(app)
    super(app)
    @defs = Definitions.get_instance #pega singleton Definitions
  end  
  
  #define nome do controller
  def name
    :definitions
  end
  
  #envia definições do jogo quando um novo jogador se conecta
  def new_conn(conn)
    get_colors(conn)
    get_territories(conn)
    get_regions(conn)
  end
  
  #envia lista de cores
  def get_colors(conn)
    conn.send_msg(Message.new('definitions','set_colors',@defs.colors))
  end
  
  #envia lista de territorios
  def get_territories(conn)
    conn.send_msg(Message.new('definitions','set_territories',@defs.territories))
  end
  
  #envia lista de regioes
  def get_regions(conn)
    conn.send_msg(Message.new('definitions','set_regions',@defs.regions))
  end
  
end
