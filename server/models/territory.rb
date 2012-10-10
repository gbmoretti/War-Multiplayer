class Territory

  attr_reader :name, :id, :vizinhos
  attr_accessor :owner, :troops

  def initialize(id,nome,owner,vizinhos,region)
    @id = id
    @name = nome
    @owner = owner if owner.is_a?(Player)
    @troops = 1
    @vizinhos = vizinhos
    @region = region
  end

  def to_hash
    {
      'id' => @id,
      'owner' => @owner.id,
      'troops' => @troops,
      'nome' => @name,
      'vizinhos' => @vizinhos,
      'region' => @region
    }
  end

end
