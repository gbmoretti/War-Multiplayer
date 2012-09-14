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
      when "territorio"
        return verifica_territorio(player,territories)
      else
        puts "ATENCAO! Regra #{@tipo} para os objetivos nao implementada!"
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
    #alimenta o vetor player_regions com os continentes que o jogador tem
    player_regions = []
    regions.each do |r|
      is_owner = true
      r.territories.each do |t|
        if territories[(t.to_i)-1].owner != player
          is_owner = false
          break
        end
      end
      player_regions.push(r.id.to_i) if is_owner 
    end
    
    #retorna falso se a quantidade de territorios que o jogador é menor que a quantidade necessaria
    return false if player_regions.count < @params.count
    
    #remove do vetor de regioes do jogador as regioes necessarias para o objetivo. 
    #se alguma regiao do objetivo nao estiver sob dominio do jogador. variavel result recebe true 
    result = false
    regions = @params.clone
    regions.each do |r|
      result = true if player_regions.delete(r).nil? && r != 0 
    end
    
    #se a variavel result é verdadeiro (o jogador nao tem todos os continente necessarios) ou
    #a quantidade de "territorios qualquer" (representado por 0) para completar o objetivo
    #for menor que a quantidade de territorios do jogador, retorna false
    return false if result || (@params.count(0) > player_regions.count)
    
    #se chegou até aqui é porque completou o objetivo
    return true
    
  end

  def verifica_territorio(player,territories)
    count = 0
    min_troops = @params[0]
    min_territories = @params[1]
    
    territories.each { |t| count += 1 if t.owner == player && t.troops >= min_troops }
    
    return count >= min_territories
  end

end
