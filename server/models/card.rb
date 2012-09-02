class Card
  attr_reader :id, :simbolo, :territorio, :nome
  
  def initialize(id,nome,territorio,simbolo)
    @id = id
    @nome = nome
    @territorio = territorio
    @simbolo = simbolo
  end
  
  def to_hash
    {
      'id' => @id,
      'nome' => @nome,
      'territorio' => @territorio,
      'simbolo' => @simbolo
    }
  end
  
end
