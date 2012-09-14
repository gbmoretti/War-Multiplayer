class Objective

  attr_reader :id, :descricao, :tipo, :params

  def initialize(id,descr,tipo,params)
    @id = id
    @descricao = descr
    @tipo = tipo
    @params = params
  end

  def completed?(player,territories,regions)
    case @tipo
      when "elimina"
        return verifica_elimina(player,territories)
      when "continente"
        return verifica_continente(player,territories,regions)
    end
  end

  protected
  def verifica_elimina(player,territories)
    encontrou = false
    territories.each do |t|
      if t.owner.color = @params 
        encontrou = true
        break 
      end
    end
    
    !encontrou
  end
  
  def verifica_continente(player,territories,regions)
    my_regions = []
    regions.each do |r|
      is_owner = true
      r.territories.each do |t|
        if territories[(t.to_i)-1].owner != player
          is_owner = false
          break
        end
      end
      my_regions.push(r.id) if is_owner 
    end
    
    my_regions.sort!
    @params.sort!
    puts "Jogador tem: #{my_regions.inspect}"
    puts "  Seu objetivo: #{@params.inspect}"
    
    
     
  end

end
