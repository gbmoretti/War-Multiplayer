class Region

  attr_reader :id, :name, :territories, :bonus

  def initialize(id,nome,territorios,bonus)
    @id = id
    @name = nome
    @territories = territorios
    @bonus = bonus
  end

end
