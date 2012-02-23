class JSONable
  def to_json #pega todas os atributos e chama o método to_json deles
    hash = {}
    self.instance_variables.each do |var|
      key = var.to_s
      key.slice!('@') #retirando o @ do nome do atributo
      hash[key] = self.instance_variable_get(var)
    end
    hash.to_json
  end
  def from_json!(string)
    JSON.load(string).each do |var, val|
        self.instance_variable_set var, val
    end
  end
end
