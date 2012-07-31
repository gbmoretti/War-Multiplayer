class Territory

  attr_reader :name, :id
  attr_accessor :owner, :troops

  def initialize(id,nome,owner)
    @id = id
    @name = nome
    @owner = owner if owner.is_a?(Player)
    @troops = 1
  end

  def to_hash
    {
      'id' => id,
      'owner' => owner.id,
      'troops' => troops
    }
  end

end
