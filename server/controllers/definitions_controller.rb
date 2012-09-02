class DefinitionsController < AppController
  
  def initialize(app)
    super(app)
    @defs = Definitions.get_instance
  end  
  
  def name
    :definitions
  end
  
  def new_conn(conn)
    get_colors(conn)
    get_territories(conn)
    get_regions(conn)
  end
  
  def get_colors(conn)
    conn.send_msg(Message.new('definitions','set_colors',@defs.colors))
  end
  
  def get_territories(conn)
    conn.send_msg(Message.new('definitions','set_territories',@defs.territories))
  end
  
  def get_regions(conn)
    conn.send_msg(Message.new('definitions','set_regions',@defs.regions))
  end
  
end
